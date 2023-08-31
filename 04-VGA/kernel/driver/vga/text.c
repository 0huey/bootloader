#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "../port.h"
#include "string.h"
#include "text.h"

static void term_write_char_at(uint8_t row, uint8_t col, uint16_t value);
static inline uint16_t term_get_vga_value(uint8_t letter);
static inline size_t term_get_index(uint8_t row, uint8_t col);
static void term_set_fg_color(uint8_t fg);
static void term_set_bg_color(uint8_t bg);
static void term_scroll(void);
static void term_update_cursor(void);

uint8_t term_color;
uint8_t term_row;
uint8_t term_col;

void term_init(void) {
	term_row = 0;
	term_col = 0;
	term_set_color(VGA_COLOR_WHITE, VGA_COLOR_BLACK);

	term_clear();
}

void term_clear(void) {
	uint16_t value = term_get_vga_value(' ');

	for (size_t r = 0; r < TERM_HEIGHT; r++) {
		for (size_t c = 0; c < TERM_WIDTH; c++) {
			term_write_char_at(r, c, value);
		}
	}
}

void term_write_str(const char* str) {
	while(*str != '\0') {
		term_write_char(*str++);
	}
}

void term_write_char(char letter) {
	static bool fg_was_set = false;

	if (letter == '\n') {
		term_row++;
		term_col = 0;
	}
	else if (letter == '\r') {
		term_col = 0;
	}
	else if (letter < 0) {
		if (fg_was_set) {
			term_set_bg_color((uint8_t)letter);
			fg_was_set = false;
		}
		else {
			term_set_fg_color((uint8_t)letter);
			fg_was_set = true;
		}
	}
	else if (letter == TERM_CHAR_DEL) {
		if (term_col > 0) {
			term_write_char_at(term_row, --term_col, term_get_vga_value(' '));
		}
		fg_was_set = false;
	}
	else {
		term_write_char_at(term_row, term_col++, term_get_vga_value(letter));
		fg_was_set = false;
	}

	if (term_col >= TERM_WIDTH) {
		term_row++;
		term_col = 0;
	}

	if (term_row >= TERM_HEIGHT) {
		term_scroll();
	}
}

static void term_write_char_at(uint8_t row, uint8_t col, uint16_t value) {
	uint16_t* video_buff = (uint16_t*)VIDEO_ADDR;
	size_t index = term_get_index(row, col);
	video_buff[index] = value;
}

static inline uint16_t term_get_vga_value(uint8_t letter) {
	return (uint16_t)letter | (uint16_t)term_color << 8;
}

static inline size_t term_get_index(uint8_t row, uint8_t col) {
	return row * TERM_WIDTH + col;
}

void term_set_color(enum vga_color fg, enum vga_color bg) {
	term_color = fg | bg << 4;
}

static void term_set_fg_color(uint8_t fg) {
	term_color = (term_color & 0xff00) | (fg & 0x0f);
}

/*pass bg in low 4 bits*/
static void term_set_bg_color(uint8_t bg) {
	term_color = (term_color & 0x00ff) | (bg << 4);
}

static void term_scroll(void) {
	uint16_t* video_buff = (uint16_t*)VIDEO_ADDR;

	memcpy(
		video_buff,
		video_buff + term_get_index(1, 0),
		TERM_WIDTH * TERM_HEIGHT * 2 - TERM_WIDTH
	);

	term_row = TERM_HEIGHT - 1;
}

static void term_update_cursor(void) {

}

__attribute__ ((const)) char term_str_color(enum vga_color color) {
	return (char)color | 0xf0;
}
