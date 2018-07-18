#ifndef APP_MAIN_H
#define APP_MAIN_H

#define WS_ID_WEBCONSOLE 'a'
#define WS_ID_LOGLEVEL   'l'
#define WS_ID_FONT       'f'
#define WS_ID_MAXFONT    'g'

#define MIN(a,b) (a<b?a:b)
#define MAX(a,b) (a>b?a:b)
#define pi M_PI

// Random number within the range [a,b]
#define RAND_AB(a,b) (rand()%(b+1-a)+a)

#define SHIFT_DEL   1     // Bit banging delay [us]

#define PIN_CLK     13
#define PIN_DAT     26
#define PIN_N_LATCH 27
#define PIN_LED_DAT 14
#define PIN_1MHZ_IN 12

#endif
