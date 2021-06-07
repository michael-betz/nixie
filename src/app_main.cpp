#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "driver/gpio.h"
#include "ArduinoOTA.h"
#include "app_main.h"
#include "rom/ets_sys.h"
#include "Arduino.h"
#include "WiFi.h"
#include "SPIFFS.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "rom/rtc.h"
#include "esp_comms.h"
#include "web_console.h"
#include "json_settings.h"
#include "esp_heap_caps.h"

// Web socket RX data received callback
static void on_ws_data(
    AsyncWebSocket * server,
    AsyncWebSocketClient * client,
    AwsEventType type,
    void * arg,
    uint8_t *data,
    size_t len
) {
    switch (data[0]) {
        case 'a':
            wsDumpRtc(client);  // read rolling log buffer in RTC memory
            break;

        case 'b':
            settings_ws_handler(client, data, len);  // read / write settings.json
            break;

        case 'r':
            ESP.restart();
            break;

        case 'h':
            client->printf(
                "h{\"heap\": %d, \"min_heap\": %d}",
                ESP.getFreeHeap(), ESP.getMinFreeHeap()
            );
            break;
    }
}

void initGpio(void)
{
    gpio_config_t io_conf;
    io_conf.intr_type = GPIO_INTR_DISABLE;
    io_conf.mode = GPIO_MODE_OUTPUT;
    io_conf.pin_bit_mask = (1<<PIN_CLK) | (1<<PIN_DAT) | (1<<PIN_N_LATCH) | (1<<PIN_LED_DAT);
    io_conf.pull_down_en = GPIO_PULLDOWN_DISABLE;
    io_conf.pull_up_en = GPIO_PULLUP_DISABLE;
    gpio_config(&io_conf);
}

static void shiftOut( uint8_t *data, unsigned len )
{
    while (len--) {
        uint8_t tmp = *data++;
        for (unsigned bit = 0; bit <= 7; bit++){
            gpio_set_level(PIN_CLK, 1);
            gpio_set_level(PIN_DAT, !(tmp & 0x80));
            ets_delay_us(SHIFT_DEL);
            tmp <<= 1;
            gpio_set_level(PIN_CLK, 0);
            ets_delay_us(SHIFT_DEL);
        }
    }
    gpio_set_level(PIN_N_LATCH, 1);
    ets_delay_us(SHIFT_DEL);
    gpio_set_level(PIN_N_LATCH, 0);
}

// Mapping of output channels g_digitLookup[X][Y]
// X = nixie index (from right)
// Y = digit
uint8_t g_digitLookup[6][10] = {
//    0  1  2  3  4  5  6  7  8  9
    {25, 4, 5, 6, 7,28, 3,24,27,26},
    { 1,10,11,12,13,14, 9, 2,15, 0},
    {22,31,16,17,18,19,30,23,20,21},
    {63,50,51,52,53,54,49,48,61,62},
    {42,45,46,47,32,33,44,43,40,41},
    {36,39,60,58,57,56,38,37,34,35}
};

#define BIT_COLON1  8
#define BIT_COLON2 55

uint64_t getTimeVal( uint8_t *secs )
{
    uint64_t val = 0;
    time_t now=0;
    struct tm t = { 0 };
    time(&now);
    localtime_r(&now, &t);
    val |= (1LL) << (g_digitLookup[0][ t.tm_sec%10]);
    val |= (1LL) << (g_digitLookup[1][ t.tm_sec/10]);
    val |= (1LL) << (g_digitLookup[2][ t.tm_min%10]);
    val |= (1LL) << (g_digitLookup[3][ t.tm_min/10]);
    val |= (1LL) << (g_digitLookup[4][t.tm_hour%10]);
    val |= (1LL) << (g_digitLookup[5][t.tm_hour/10]);
    if( secs ) *secs = t.tm_sec;
    return val;
}

void setup()
{
    initGpio();
    uint64_t zeros=0;
    shiftOut((uint8_t*)(&zeros), 8);

    // report initial status
    log_w(
        "reset reason: %d, heap: %d, min_heap: %d",
        rtc_get_reset_reason(0),
        esp_get_free_heap_size(),
        esp_get_minimum_free_heap_size()
    );

    // forwards each serial character to web-console
    web_console_init();
    log_w(
        "after web_console, heap: %d, min_heap: %d",
        esp_get_free_heap_size(),
        esp_get_minimum_free_heap_size()
    );

    SPIFFS.begin(true, "/spiffs", 5);
    log_w(
        "after SPIFFS, heap: %d, min_heap: %d",
        esp_get_free_heap_size(),
        esp_get_minimum_free_heap_size()
    );

    // When settings.json cannot be opened, it will copy the default_settings over
    set_settings_file("/spiffs/settings.json", "/spiffs/default_settings.json");
    log_w(
        "after settings, heap: %d, min_heap: %d",
        esp_get_free_heap_size(),
        esp_get_minimum_free_heap_size()
    );

    init_comms(SPIFFS, "/", on_ws_data);
    log_w(
        "after init_comms, heap: %d, min_heap: %d",
        esp_get_free_heap_size(),
        esp_get_minimum_free_heap_size()
    );

    // This is how to access a string item from settings.json
    log_d(
        "settings[hostname] = %s",
        jGetS(getSettings(), "hostname", "fallback_value")
    );
}

void loop() {
    uint64_t val1=0, val2=0;
    uint8_t sec=0, osec=0;
    // for( unsigned i=0; i<6; i++ ){
    //     for( unsigned d=0; d<10; d++ ){
    //         ESP_LOGI(T, "[%d,%d]", i, d);
    //         val = (1LL)<<(g_digitLookup[i][d]);
    //         shiftOut((uint8_t*)(&val), 8);
    //         vTaskDelay(100 / portTICK_RATE_MS);
    //     }
    // }
    val1 = getTimeVal(&sec);
    val2 = val1 | (1LL) << (BIT_COLON1) | (1LL) << (BIT_COLON2);
    if(sec != osec){
        osec = sec;
        // shiftOut((uint8_t*)(&val2), 8);
        vTaskDelay(15 / portTICK_RATE_MS);
    }
    shiftOut((uint8_t*)(&val1), 8);

    g_ws.cleanupClients();
    ArduinoOTA.handle();
    vTaskDelay(100 / portTICK_RATE_MS);
}
