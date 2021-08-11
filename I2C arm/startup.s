
			AREA startup CODE
			ENTRY

BRAM_BASE	EQU 0xE0084000; Battery ram, 2kB.
BRAM_MAX
RTC_BASE	EQU 0xE0024000; Real time clock; Manual Table 566
RTC_ILR		EQU 0x0; Interupt location register
RTC_CIIR	EQU 0xC; Counter Increment Interrupt Register
RTC_AMR		EQU 0x10; Alarm mask register 
	
	
PCOMP_BASE	EQU 0x10; Manual table 63

	
	
main
;/*
; *  
; * 
;
;*/

setup_device
	


setup_rtc



setup_batram






	
	
