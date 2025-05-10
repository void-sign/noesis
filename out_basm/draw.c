#include "../../include/utils/noesis_lib.h"

#define WIDTH 10
#define HEIGHT 10
#define TERMINAL_WIDTH 80
#define TERMINAL_HEIGHT 24

void write(const char *str, unsigned int len) {
    asm volatile (
        "mov $1, %%rax\n" // syscall: write
        "mov $1, %%rdi\n" // file descriptor: stdout
        "syscall\n"
        :
        : "S"(str), "d"(len)
        : "rax", "rdi"
    );
}

void draw_pixel(int x, int y, int on) {
    char buffer[WIDTH + 1];
    for (int i = 0; i < WIDTH; i++) {
        buffer[i] = on ? '#' : ' ';
    }
    buffer[WIDTH] = '\n';

    for (int i = 0; i < HEIGHT; i++) {
        char move_cursor[32];
        int len = 0;
        move_cursor[len++] = '\033';
        move_cursor[len++] = '[';
        move_cursor[len++] = '0' + (y + i) / 10;
        move_cursor[len++] = '0' + (y + i) % 10;
        move_cursor[len++] = ';';
        move_cursor[len++] = '0' + x / 10;
        move_cursor[len++] = '0' + x % 10;
        move_cursor[len++] = 'H';
        move_cursor[len] = '\0';

        noesis_print(move_cursor);
        noesis_print(buffer);
    }
}

void clear_screen() {
    const char *clear = "\033[2J\033[H";
    write(clear, 7);
}

void sleep(int milliseconds) {
    volatile unsigned long count = milliseconds * 100000;
    while (count--) {
        // Busy-wait loop for delay
    }
}

int main() {
    clear_screen();

    // Calculate the center of the terminal
    int center_x = (TERMINAL_WIDTH - WIDTH) / 2;
    int center_y = (TERMINAL_HEIGHT - HEIGHT) / 2;

    // Draw the pixel in the center of the terminal
    draw_pixel(center_x, center_y, 1); // Turn the pixel "on"
    sleep(1000);                      // Wait for 1 second

    draw_pixel(center_x, center_y, 0); // Turn the pixel "off"
    sleep(1000);                      // Wait for 1 second

    // Toggle the pixel a few times
    for (int i = 0; i < 5; i++) {
        draw_pixel(center_x, center_y, 1); // Turn "on"
        sleep(500);                       // Wait for 0.5 seconds
        draw_pixel(center_x, center_y, 0); // Turn "off"
        sleep(500);                       // Wait for 0.5 seconds
    }

    return 0;
}
