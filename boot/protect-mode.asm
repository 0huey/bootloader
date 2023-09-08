BITS 16

start_protected_mode:
	cli

	; test and enable A20 line
	in al, 0x92
	test al, 2
	jnz a20_end
	or al, 2
	and al, 0xFE
	out 0x92, al
a20_end:

	lgdt [gdt_descriptor]

	; set 32 bits bit
	mov eax, cr0
	or eax, 1
	mov cr0, eax

	; far jump clears 16 bit instruction cache
	jmp CODE_SEG:init_32_bit

BITS 32

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

	sti ; reenable interupts

	;print a message
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
	call KERNEL_ENTRY

msg_32_bit: db "reached protected mode!", 0
