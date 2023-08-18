bits 16
org 7C00h

boot:
	mov ah, 0x0e
	mov si, Msg

.print_loop:
	cld			;Ensure direction flag is cleared (for LODSB)
	lodsb
	test al, al
	jz .halt
	int 0x10
	jmp .print_loop


.halt:
	cli
	hlt

Msg: db "Hello World!", 0

times 0200h - 2 - ($ - $$) db 0

dw 0xaa55
