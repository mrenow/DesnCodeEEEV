#include "lpc24xx.h"

#define BMASK(start, end) ((0xFFFFFFFF>>(31-(end)+(start)))<<(start))
#define B(n) 1<<n
#define BIT_WRITE(reg, val, start, end) reg=(reg&~BMASK(start, end))|(val<<start);

/*
 * Assume that the external 32.786kHz clock is configured externally
 * This function will only need to be called once on device initialization,
 * as RTC registers are not reset on reset as long as VBAT is held constant.
 * Values will need to be externally entered.
 */
 
void initRTC(char year, char month, short doy, char dom, char dow, char hour, char minute, char second){
	// Turn off clk so that it can be set to its initial values,
	// Make sure that clock source is from external RTC.
	
	PCONP = B(9); // Enable writing to RTC 
	RTC_CCR = 0x10; // CLKEN=0, CLKSRC=1
	RTC_YEAR = year;
	RTC_MONTH = month;
	RTC_DOY = doy;
	RTC_DOM = dom;
	RTC_DOW = dow;
	RTC_HOUR = hour;
	RTC_MIN = minute;
	RTC_SEC = second;
	// Only trigger interrupts on alarms
	RTC_ILR = B(2);
	// Alarm mask register is set to only consider number of minutes
	RTC_AMR = ~B(1);
	// Set alarm two minutes from now
	RTC_ALMIN = RTC_MIN + 2;
	
	// Enable clock 
	RTC_CCR = 0x11; // CLKEN=1, CLKSRC=1
	
	// Clear battery ram:
	
}
