%if 0;
 * Title: A Bootloader For Bromine OS Created By Parambir Singh
 * Author: Hecker Github => (Sherry65-code)
%endif;

	BITS 16

	jmp short _start ; jump past disk description section
	nop

; Disk Description table, to make a valid floppy
OEMLabel 			db "BromineOS" 		; Disk Label
BytesPerSector 		dw 512 				; Bytes per section
SectorsPerCluster 	db 1 				; Sectors Per Cluster
ReservedForBoot 	dw 1 				; Reserved sectors for boot record
NumberOfFats 		db 2 				; Numbers of copies of FAT
RootDirEntries 		dw 224
LogicalSectors 		dw 2880 			; Number of logical sectors
MediumByte 			db 0F0h 			; Medium Descriptor Byte
SectorsPerFat 		dw 9 				; Sectors per FAT
SectorsPerTrack 	dw 18 				; Sectors per track (36/cylinder)
Sides 				dw 2 				; Number of sides/heads
HiddenSectors 		dd 0 				; Number of hidden sectors
LargeSectors 		dd 0 				; Number of LBA sectors
DriveNo 			dw 0 				; Drive No: 0
Signature 			db 41 				; Drive signature: 41 for floppy
VolumeID 			dd 12345678h 		; VolumeID: any number
VolumeLabel 		db "BromineBoot" 	; Volume Label: any 11 chars
FileSystem 			db "FAT12" 			; File System type: don't change!


_start:
	mov ax, 07C0H 						; mov 0x7c00 into ax
	mov ds, ax 							; set data segment to where we are loaded
	mov dh, 1 							; initalize the first line
	
	mov ah, 0
	mov al, 3
	int 0x10 							; clear the screen
	
	mov si, welcome 					; set si to welcome
	call print_string 					; print welcome

	.loop2:
		mov ah, 0x0e 						; switch to teletype mode
		mov al, '>' 						; set al to >
		int 0x10 							; print >
		call input 							; call input function to take an input
		jmp .loop2		

	jmp $ 								; infinite loop
	
	welcome db "Welcome to Bromine OS Minimal Shell", 10, 0
	prompt db "Type Here >", 0

input:
	mov ah, 0
	int 0x16
	mov ah, 0x0e
	mov al, al
	int 0x10
;	cmp al, 8
;	je backspace
	cmp al, 13
;	inc dl
	jne input
	jmp gotouser

gotouser:
	mov ah, 0x02
	mov bh, 0
	inc dh
	mov dh, dh
	mov dl, 0
	int 0x10	
	ret

;backspace:
;	mov ah, 0x0e
;	mov al, ' '
;	int 0x10
;	mov ah, 0x02
;	mov bh, 0
;	mov dh, dh
;	dec dl
;	int 0x10
;	jmp input
print_string:
	mov ah, 0x0e
.loop:
	lodsb 								; load single byte into al
	cmp al, 0 							; compare al to 0
	je .goback							; if al == 0 then jump to .done
	int 0x10 							; print al register as character BIOS Interrupt
	jmp .loop
.goback:
	mov ah, 0x02 						; set BIOS function for setting cursor position
	mov bh, 0 							; set page to 0
	inc dh
	mov dh, dh 							; set row to dh itself
	mov dl, 0 							; set column to 0
	int 0x10 							; set cursor
	ret 								; transfer back control
.done:
	ret 								; transfers control to the return address located on the stack
	times 510-($-$$) db 0 				; padding for file to fill 510 bytes
	db 0x55, 0xaa 						; last two bytes of the boot sector
