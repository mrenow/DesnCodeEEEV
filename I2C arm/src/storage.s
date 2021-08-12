				AREA bat_ram CODE

				EXPORT record_meas;
				EXPORT write_flash;
				EXPORT begin_flash;
				EXPORT end_flash;
					
RAM_BASE		EQU 0xE0084000
RAM_END			EQU 0xE00847FF

; Records each measurement without byte alignment for maximum storage.
; First two bytes of memory designate the next free byte.
;


record_meas;(int data, char len)
				; If ram cannot contain next word, write all of ram to flash
				
				
				;
				MOV A1, #RAM_BASE
				LDRH A2, [A1]; A1 = N bits
				; Store in ram
				STRH A2, [A1]
				MOV PC, LR

begin_flash; ()



write_flash; (int data, char len)
; IMPORTANT: write data BEFORE changing length register at 0x0
; This is because in initialization, we write 0x00000000 to initialize the
; length register.




end_flash; ()