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

void vBlink(void* unused_arg) {

   for (;;) {

      gpio_put(PICO_DEFAULT_LED_PIN, 1);

      vTaskDelay(250);

      gpio_put(PICO_DEFAULT_LED_PIN, 0);

      vTaskDelay(250);

   }

}

int main() {

   gpio_init(PICO_DEFAULT_LED_PIN);

   gpio_set_dir(PICO_DEFAULT_LED_PIN, GPIO_OUT);

   xTaskCreate(vBlink, "Blink", 128, NULL, 1, NULL);

   vTaskStartScheduler();

}
