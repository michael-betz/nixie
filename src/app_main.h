#ifndef APP_MAIN_H
#define APP_MAIN_H

// Random number within the range [a,b]
#define RAND_AB(a,b) (rand()%(b+1-a)+a)

#define SHIFT_DEL   100     // Bit banging delay [us]

#define PIN_CLK     GPIO_NUM_13
#define PIN_DAT     GPIO_NUM_26
#define PIN_N_LATCH GPIO_NUM_27
#define PIN_LED_DAT GPIO_NUM_14
#define PIN_1MHZ_IN GPIO_NUM_12

#endif
