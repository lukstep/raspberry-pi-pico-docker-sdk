#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/gpio.h"
#include "pico/binary_info.h"

const int LED_PIN = 25;

int main ()
{
    bi_decl(bi_program_description("Sample binary"));
    bi_decl(bi_1pin_with_name(LED_PIN, "on-board PIN"));

    stdio_init_all();

    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);

    while(1)
    {
        gpio_put(LED_PIN, 0);
        sleep_ms(250);
        gpio_put(LED_PIN, 1);
        puts("Hello Word\n");
        sleep_ms(1000);
    }
}

