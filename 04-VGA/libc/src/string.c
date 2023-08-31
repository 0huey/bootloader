#include <stddef.h>
#include <stdint.h>

size_t strcpy(char* dest, const char* src) {
	size_t num_copied = 0;

	while (*src != '\0') {
		*dest++ = *src++;
		num_copied++;
	}
	*dest = '\0';
	return num_copied;
}

size_t strncpy(char* dest, const char* src, size_t size) {
	size_t num_copied = 0;

	while (*src != '\0' && size > 0) {
		*dest++ = *src++;
		size--;
		num_copied++;
	}

	if (size > 0) {
		*dest = '\0';
	}

	return num_copied;
}

void memcpy(void* dest, const void* src, size_t size) {
	while (size-- > 0) {
		*(uint8_t*)dest++ = *(uint8_t*)src++;
	}
}
