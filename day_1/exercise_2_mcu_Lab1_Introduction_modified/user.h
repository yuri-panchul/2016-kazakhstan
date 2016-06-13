/******************************************************************************/
/* User Level #define Macros                                                  */
/******************************************************************************/

/* TODO Application specific user parameters used in user.c may go here */
#define BIT_MASK(pos)   (1<<(pos))
#define LED_DELAY       (1000000)
/******************************************************************************/
/* User Function Prototypes                                                    /
/******************************************************************************/

/* TODO User level functions prototypes (i.e. InitApp) go here */

void InitApp(void);         /* I/O and Peripheral Initialization */

void Echo_Buttons(void);
void Scan_LEDs(void);
void Flash_LED(void);
