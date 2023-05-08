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
	mov ax, 07C0h 		; move 0x7c00 into ax
	mov ds, ax 			; set data segment to where we are loaded
	mov sp, 0x7c00
	mov dh, 1
	mov ah, 0 			; moves ah to 0 to go to input mode
	mov al, 3 			
	int 0x10 			; finally cleared
	mov si, string 		; Put string position into SI
	call print_string 	; Call our string-printing routine

	jmp $

	string db "BROMINE OS Minimal Command Line [BIOS]", 0

print_string:
	mov ah, 0Eh 		; int 10h 'print char' function
.loop:
	lodsb 				; load string byte to al
	cmp al, 0 			; cmp al with 0
	je .askfirst 		; if char is zero, ret
	int 10h 			; else, print
	jmp .loop
.askfirst:
	mov ah, 02h
	mov bh, 0
	inc dh
	mov dh, dh
	mov dl, 0
	int 10h
	mov ah, 0x0e
	mov al, 10
	int 0x10
	mov al, '>'
	int 0x10
	jmp .input
.input:
	mov ah, 0
	int 0x16
	push ax
	mov ah, 0x0e
	int 0x10
	cmp al, 13
	jne .input
	je .askfirst
.done:
	ret
	times 510-($-$$) db 0 	; Pad boot sectors
	db 0x55, 0xaa 		 	; The standard PC Boot Signature
