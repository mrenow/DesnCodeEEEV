RAM_BASE		EQU 0xE0084000
RAM_END			EQU 0xE00847FF

				AREA bat_ram, CODE

				EXPORT record_meas;
				EXPORT write_flash;
				EXPORT begin_flash;
				EXPORT end_flash;
					

; Records each measurement without byte alignment for maximum storage.
; First two bytes of memory designate the next free byte.
;

record_meas;(int data - 4 bytes,) 
				; If ram cannot contain next word, write all of ram to flash
	
				
				;
				LDR A2, =RAM_BASE
				LDRH A3, [A2]; A3 = N bits
				ADD A3, #4
				LDR A4, =RAM_END
				ADD V1, A2, A3
				CMP V1, A4
				STRHHI A3, [A2]
				ADDHI A2, A2, A3
				STRHI A1, [A2]
				MOVHI PC, LR
				BL begin_flash

				BL end_flash

begin_flash; ()


end_flash; ()

write_flash; (int data, char len)
; IMPORTANT: write data BEFORE changing length register at 0x0
; This is because in initialization, we write 0x00000000 to initialize the
; length register.



				END