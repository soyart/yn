// yn
// A simple program that exits with 0
// if the first char read from stdin
// starts with 'y' or 'Y', 1 otherwise

#include <stdio.h>

// Gets first character of the input line
char get_first();

int main(int argc, char **argv) {
    if (argc > 1) {
        printf("%s ", argv[1]);
    }

    printf("[Y/N]: ");

    char c = get_first();

    if (c == 'Y' || c == 'y') {
        return 0;
    }

    return 1;
}

char get_first() {
    char c = getchar();
    if (c == '\n') {
        return 0;
    }

    char ch = 0;
    while ((ch = getchar()) && ch != EOF) {
        if (ch == '\n') {
            return c;
        }
    }

    return 0;
}
