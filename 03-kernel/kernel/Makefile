C_SOURCES = $(wildcard *.c)
OBJ = ${C_SOURCES:.c=.o}

kernel.bin: kernel-entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x7e00 --oformat binary $^
	python3 ../util/pad-file.py --tosector $@

kernel-entry.o: kernel-entry.asm
	nasm $< -f elf32 -o $@

%.o : %.c
	gcc -m32 -ffreestanding -fno-pic -c $< -o $@

clean:
	@rm *.o *.bin 2> /dev/null || true
