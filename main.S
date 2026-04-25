/**
 * RISC-V Assembly Wire Function Example
 * Usando API simplificada para estudantes
 */

.section .text
.global main

# Definições para os estudantes
.equ INPUT_PIN,  12
.equ OUTPUT_PIN, 15
.equ DIR_IN,     0
.equ DIR_OUT,    1

main:
    # Configura pino de entrada: pico_gpio_init(pin=12, is_output=0)
    li   a0, INPUT_PIN
    li   a1, DIR_IN
    call pico_gpio_init

    # Configura pino de saída: pico_gpio_init(pin=15, is_output=1)
    li   a0, OUTPUT_PIN
    li   a1, DIR_OUT
    call pico_gpio_init

wire_loop:
    # Lê pino 12: pico_gpio_read(pin=12) → a0
    li   a0, INPUT_PIN
    call pico_gpio_read

    # Escreve no pino 15: pico_gpio_write(pin=15, value=a0)
    mv   a1, a0
    li   a0, OUTPUT_PIN
    call pico_gpio_write

    j    wire_loop
