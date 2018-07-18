// Copyright 2017 Espressif Systems (Shanghai) PTE LTD
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include "driver/gpio.h"
#include "esp_log.h"
#include "wifi_startup.h"
#include "web_console.h"
#include "app_main.h"
#include "rom/ets_sys.h"

static const char *T = "MAIN_APP";

void initGpio(void)
{
    gpio_config_t io_conf;
    io_conf.intr_type = GPIO_PIN_INTR_DISABLE;
    io_conf.mode = GPIO_MODE_OUTPUT;
    io_conf.pin_bit_mask = (1<<PIN_CLK)|(1<<PIN_DAT)|(1<<PIN_N_LATCH)|(1<<PIN_LED_DAT);
    io_conf.pull_down_en = 0;
    io_conf.pull_up_en = 0;
    gpio_config(&io_conf);
}

static void shiftOut( uint8_t *data, unsigned len )
{
    while( len-- ){
        uint8_t tmp = *data++;
        for (unsigned bit=0; bit<=7; bit++ ){
            gpio_set_level(PIN_CLK, 1);
            gpio_set_level(PIN_DAT, !(tmp&0x80));
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

uint64_t getTimeVal()
{
    uint64_t val = 0;
    time_t now=0;
    struct tm t = { 0 };
    time(&now);
    localtime_r(&now, &t);
    val |= (1LL)<<(g_digitLookup[0][ t.tm_sec%10]);
    val |= (1LL)<<(g_digitLookup[1][ t.tm_sec/10]);
    val |= (1LL)<<(g_digitLookup[2][ t.tm_min%10]);
    val |= (1LL)<<(g_digitLookup[3][ t.tm_min/10]);
    val |= (1LL)<<(g_digitLookup[4][t.tm_hour%10]);
    val |= (1LL)<<(g_digitLookup[5][t.tm_hour/10]);
    return val;
}

static void nixieTask(void* arg)
{
    uint64_t val1=0, val2=0;
    unsigned temp=0;
    while(1){
        // for( unsigned i=0; i<6; i++ ){
        //     for( unsigned d=0; d<10; d++ ){
        //         ESP_LOGI(T, "[%d,%d]", i, d);
        //         val = (1LL)<<(g_digitLookup[i][d]);
        //         shiftOut((uint8_t*)(&val), 8);
        //         vTaskDelay(100 / portTICK_RATE_MS);
        //     }
        // }
        val1 = getTimeVal();
        val2 = val1 | (1LL)<<(BIT_COLON1) | (1LL)<<(BIT_COLON2);
        if( temp & 0x01 ){
            shiftOut((uint8_t*)(&val2), 8);
        }
        shiftOut((uint8_t*)(&val1), 8);
        temp++;
        vTaskDelay(500 / portTICK_RATE_MS);
    }
}

void app_main()
{
    //------------------------------
    // Enable RAM log file
    //------------------------------
    // esp_log_level_set( "*", ESP_LOG_INFO );
    esp_log_set_vprintf( wsDebugPrintf );

    //------------------------------
    // Init filesystems
    //------------------------------
    initSpiffs();

    //------------------------------
    // Init digits
    //------------------------------
    initGpio();
    xTaskCreate(nixieTask, "nixieTask", 2048, NULL, 10, NULL);

    //------------------------------
    // Startup wifi & webserver
    //------------------------------
    ESP_LOGI(T,"Starting network infrastructure ...");
    wifi_conn_init();
    xEventGroupWaitBits(wifi_event_group, CONNECTED_BIT, 0, 0, 20000/portTICK_PERIOD_MS);
    vTaskDelay(3000 / portTICK_PERIOD_MS);

    //------------------------------
    // Set the clock / print time
    //------------------------------
    // Set timezone to Eastern Standard Time and print local time
    setenv("TZ", "PST8PDT", 1);
    tzset();
    time_t now = 0;
    struct tm timeinfo = { 0 };
    char strftime_buf[64];
    time(&now);
    localtime_r(&now, &timeinfo);
    strftime(strftime_buf, sizeof(strftime_buf), "%c", &timeinfo);
    ESP_LOGI(T, "Local Time: %s (%ld)", strftime_buf, time(NULL));
    srand(time(NULL));

    ESP_LOGI(T, "Done");
}
