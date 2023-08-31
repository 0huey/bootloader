#include <stddef.h>
#include <string.h>
#include "driver/vga/text.h"


void main(void) {
	term_init();

	const char* msg = "running da kernel\n";
	const char* msg2 = "printing strings!\n";
	const char* msg3 = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";

	char white = term_str_color(VGA_COLOR_WHITE);
	char black = term_str_color(VGA_COLOR_BLACK);
	char cyan  = term_str_color(VGA_COLOR_CYAN);
	char magenta = term_str_color(VGA_COLOR_MAGENTA);

	const char msg4[] = "last line";

	char colors[ sizeof(msg4)+4 ];

	size_t i = 0;

	colors[i++] = black;
	colors[i++] = cyan;

	i += strncpy(colors+i, msg4, 4);

	colors[i++] = white;
	colors[i++] = magenta;

	strncpy(colors+i, msg4+4, sizeof(msg4)+4-i);

	term_write_str(msg);
	term_write_str(msg2);
	term_write_str(msg3);
	term_write_str(colors);

}
