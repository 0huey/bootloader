C_SOURCES = $(wildcard src/*.c)

libc.o: $(C_SOURCES)
	gcc -c -m32 -Wall -O1 -ffreestanding -fno-pic -nostdlib $^ -o $@

clean:
	rm *.o
