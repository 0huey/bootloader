C_SOURCES = $(shell find ./ -iname '*.c')
LIBC_SOURCES = $(shell find ../libc/src -iname '*.c')
ASM_SOURCES = $(shell find ./ -iname '*.asm')
ASM_OBJ = $(ASM_SOURCES:.asm=.o)

CC_OPTS = -m32 -Wall -O1 -ffreestanding -fno-pic -nostdlib -I ../libc/include
LD_OPTS = -m,elf_i386,--oformat,binary,-Ttext,0x7e00

kernel.bin: kernel-entry.o $(ASM_OBJ) $(C_SOURCES) $(LIBC_SOURCES)
	gcc $(CC_OPTS) -Wl,$(LD_OPTS) -o $@ $^
	python3 ../util/pad-file.py --tosector $@

%.o : %.asm
	nasm -f elf32 -o $@ $^

clean:
	@rm $(ASM_OBJ) *.o *.bin 2>/dev/null || true
