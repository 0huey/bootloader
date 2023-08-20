bits 16

start_protected_mode:
	cli

	lgdt [gdt_descriptor]

	; set 32 bits bit
	mov eax, cr0
	or eax, 1
	mov cr0, eax

	; far jump clears 16 bit instruction cache
	jmp CODE_SEG:init_32_bit

bits 32

init_32_bit:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; initialize stack
	mov ebp, 0x00ff0000
	mov esp, ebp

	mov esi, msg_32_bit
	mov edi, 0xb8a38
	mov ah, 0x40
	cld
.print_loop:
	lodsb
	test al, al
	jz .break
	stosw
	add ah, 3
	jmp .print_loop

.break:
	call halt

msg_32_bit: db "reached protected mode!", 0
