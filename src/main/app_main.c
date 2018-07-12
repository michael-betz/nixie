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

static void nixieTask(void* arg)
{
    while(1){
        vTaskDelay(3000 / portTICK_RATE_MS);
        gpio_set_level(PIN_CLK, 1);
        gpio_set_level(PIN_DAT, 1);
        gpio_set_level(PIN_N_LATCH, 1);
        vTaskDelay(3000 / portTICK_RATE_MS);
        gpio_set_level(PIN_CLK, 0);
        gpio_set_level(PIN_DAT, 0);
        gpio_set_level(PIN_N_LATCH, 0);
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
