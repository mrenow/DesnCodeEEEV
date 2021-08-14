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
				CMP V1, A4; Check if we have reached the end of ram
				STRHHI A3, [A2]; If not update n bits and store data to ram
				ADDHI A2, A2, A3
				STRHI A1, [A2]
				MOVHI PC, LR
				BL begin_flash; Else we must write all of ram to flash
				MOV V1, A1; lets move the new piece of data to v1 first
				MOV V2, #0
				STRH V2, [A2] # reset n bits to 0
				ADD A2, A2, #2.; ignoring the n bits area 
loop_write
				LDR A1, [A2], #4; load the data from ram post-indexed to next word
				BL write_flash
				CMP A4, A2; check that we have not reached RAM_END yet
				BHI loop_write; if not go to next peice of data and repeat write
end_loop_write	
				MOV A1, V1; finally move back new piece of data to A1 and write to flash
				BL write_flash
				BL end_flash

begin_flash; ()


end_flash; ()

write_flash; (int data)
; IMPORTANT: write data BEFORE changing length register at 0x0
; This is because in initialization, we write 0x00000000 to initialize the
; length register.



				END