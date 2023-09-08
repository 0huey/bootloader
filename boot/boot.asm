%define SECTOR_SIZE 512
%define MBR_SIGNATURE 0xaa55
%define CUR_POS ($-$$)

org 0x7c00
BITS 16

entry_point:
	jmp main

%include "print.asm"
%include "disk.asm"

main:
	mov ax, 0
	mov ss, ax
	mov ds, ax
	mov es, ax
	mov sp, 0x7b00
	mov bp, sp

	mov ax, [KERNEL_SIZE]	; num sectors to read, not bytes
	test ax, ax
	jz .size_zero

	mov bx, 0x7e00	; read buff
	mov cx, 1		; logical sector read start; LBA addressing with 0-based index
	call disk_read

	call start_protected_mode

.size_zero:
	mov si, msg_kernel_size_zero
	call print_str

halt:
	cli
	hlt

; include later because these set BITS 32
%include "gdt.asm"
%include "protect-mode.asm"

msg_kernel_size_zero: db "error: kernel size 0", 0

; pad to 508 bytes
times SECTOR_SIZE - CUR_POS - 4 db 0

KERNEL_SIZE: dw 0	; size in sectors

dw MBR_SIGNATURE

KERNEL_ENTRY:
