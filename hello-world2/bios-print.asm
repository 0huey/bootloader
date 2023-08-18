BITS 16
hex_chars: db "0123456789abcdef"

; <--- void print_hex(si: char* buff) --->
print_str:
	cld		; clear direction flag for lodsb
.print_str_loop:
	lodsb
	test al, al
	jz .return
	call print_char
	jmp .print_str_loop
.return:
	ret

; <--- void print_hex(si: uchar* buff, cx: short len) --->
print_hex:
	pusha
	test cx, cx
	jz .return
	cld
	mov bx, hex_chars
.hex_loop:
	lodsb
	mov ah, 0
	mov dx, ax	; store byte in dx since lodsb incremented si
	mov di, ax
	shr di, 4
	mov al, [bx + di]	; in 16 bit mode, only bx can be a base pointer and di an index
	call print_char
	mov di, dx
	and di, 0x0f
	mov al, [bx + di]
	call print_char
	call print_space
	loop .hex_loop
.return:
	popa
	ret

print_space:
	mov al, ' '
	call print_char
	ret

print_newline:
	mov al, 0xd
	call print_char
	mov al, 0xa,
	call print_char
	ret

; <--- void print_char(al: char character) --->
print_char:
	mov ah, 0xe
	int 0x10
	ret
