#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/gpio.h"

#ifdef __cplusplus
extern "C" {
void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName );
void vApplicationTickHook( void );
void vApplicationMallocFailedHook( void );
}
#endif

void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName ) {}
void vApplicationTickHook( void ) {}
void vApplicationMallocFailedHook( void ) {}

constexpr int LED_PIN = 25;

void vBlink(void* unused_arg) {
    stdio_init_all();
    for (;;) {

        gpio_put(LED_PIN, 1);
        vTaskDelay(250);
        gpio_put(LED_PIN, 0);
        puts("Hello FreeRTOS\n");
        vTaskDelay(250);
    }
}

int main() {
    gpio_init(LED_PIN);

    gpio_set_dir(LED_PIN, GPIO_OUT);

    xTaskCreate(vBlink, "Blink", 128, NULL, 1, NULL);

    vTaskStartScheduler();
}
