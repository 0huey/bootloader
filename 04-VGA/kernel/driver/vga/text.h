#define VIDEO_ADDR 0xb8000;

#define TERM_HEIGHT 25
#define TERM_WIDTH  80

#define TERM_CHAR_DEL 0x7f

enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
};


void term_init(void);
void term_clear(void);
void term_write_str(const char* str);
void term_write_char(char letter);
void term_set_color(enum vga_color fg, enum vga_color bg);
__attribute__ ((const)) char term_str_color(enum vga_color color) ;
