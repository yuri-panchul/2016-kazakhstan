/******************************************************************************/
/* Files to Include                                                           */
/******************************************************************************/

#ifdef __XC32
    #include <xc.h>          /* Defines special function registers, CP0 regs  */
#endif

#include <stdint.h>          /* For uint32_t definition                       */
#include <stdbool.h>         /* For true/false definition                     */
#include "user.h"            /* variables/params used by user.c               */

/******************************************************************************/
/* User Functions                                                             */
/******************************************************************************/

#if defined (DIGILENT_CHIPKIT_WIFIRE)

// Version for Digilent chipKIT Wi-Fire board with Microchip PIC32MZ2048EFH064 microcontroller

void InitApp(void)
{
    // LED output
    // Disable analog mode
    ANSELGbits.ANSG6 = 0;
    // Set direction to output
    TRISGbits.TRISG6 = 0;
    // LED off
    LATGbits.LATG6 = 0;
    // Button input
    // Disable analog mode
    ANSELAbits.ANSA5 = 0;
    // Set directions to input
    TRISAbits.TRISA5 = 1;
}

void Delay(int n) {
    volatile int i;
    for (i=0; i<n; i++) {
    }
 }

#define VER 3

#if VER==1
void Flash_LED(void) {
    while (1) {
        LATGbits.LATG6 = 1; // Turn on LED
        LATGbits.LATG6 = 0; // Turn off LED
    }
}
#elif VER==2
void Flash_LED(void) {
    while (1) {
        LATGbits.LATG6 = 1; // Turn on LED
        Delay(1000000);
        LATGbits.LATG6 = 0; // Turn off LED
        Delay(1000000);
    }
}
#elif VER==3
void Flash_LED(void) {
    int delay_count;
    while (1) {
        if (PORTAbits.RA5 == 1) {
            // switch is pressed
            delay_count = 1000000;
        } else {
            // switch is not pressed
            delay_count = 4000000;
        }
        LATGbits.LATG6 = 1; // Turn on LED
        Delay(delay_count);
        LATGbits.LATG6 = 0; // Turn off LED
        Delay(delay_count);
    }
}
#endif

#elif defined (OLIMEX_PIC32_EMZ64)

// Version for Olimex PIC32-EMZ64 board with Microchip PIC32MZ2048EFH064 microcontroller

void InitApp(void)
{
    // LED output
    // Disable analog mode
    ANSELBbits.ANSB8 = 0;
    ANSELBbits.ANSB9 = 0;
    ANSELBbits.ANSB10 = 0;
    // Set direction to output
    TRISBbits.TRISB8 = 0;
    TRISBbits.TRISB9 = 0;
    TRISBbits.TRISB10 = 0;
    // LED off
    LATBbits.LATB8 = 0;
    LATBbits.LATB9 = 0;
    LATBbits.LATB10 = 0;

    // Button input
    // Disable analog mode
    // Button input
    // Disable analog mode
    ANSELBbits.ANSB12 = 0;
    ANSELBbits.ANSB13 = 0;
    ANSELBbits.ANSB14 = 0;
    // Set directions to input
    TRISBbits.TRISB12 = 1;
    TRISBbits.TRISB13 = 1;
    TRISBbits.TRISB14 = 1;
}

void Delay(int n) {
    volatile int i;
    for (i=0; i<n; i++) {
    }
 }

#define VER 3

#if VER==1
void Flash_LED(void) {
    while (1) {
        LATBbits.LATB8 = 1; // Turn on LED
        LATBbits.LATB8 = 0; // Turn off LED
    }
}
#elif VER==2
void Flash_LED(void) {
    while (1) {
        LATBbits.LATB8 = 1; // Turn on LED
        Delay(1000000);
        LATBbits.LATB8 = 0; // Turn off LED
        Delay(1000000);
    }
}
#elif VER==3
void Flash_LED(void) {
    int delay_count;
    while (1) {
        if (PORTBbits.RB12 == 1 || PORTBbits.RB13 == 1 || PORTBbits.RB14 == 1) {
            // switch is pressed
            delay_count = 1000000;
        } else {
            // switch is not pressed
            delay_count = 4000000;
        }
        LATBbits.LATB8 = 1; // Turn on LED
        Delay(delay_count);
        LATBbits.LATB8 = 0; // Turn off LED
        Delay(delay_count);
        LATBbits.LATB9 = 1; // Turn on LED
        Delay(delay_count);
        LATBbits.LATB9 = 0; // Turn off LED
        Delay(delay_count);
        LATBbits.LATB10 = 1; // Turn on LED
        Delay(delay_count);
        LATBbits.LATB10 = 0; // Turn off LED
        Delay(delay_count);
    }
}
#endif

#endif
