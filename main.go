package main

import (
	"bufio"
	"os"
	"syscall"
	"unicode/utf8"
)

func main() {
	prompt := "[Y/N]: "

	if len(os.Args) > 1 {
		prompt = os.Args[1]
	}

	os.Stdout.WriteString(prompt)

	scanner := bufio.NewScanner(os.Stdin)
	for scanner.Scan() {
		text := scanner.Bytes()
		if len(text) == 0 {
			syscall.Exit(-1)
		}

		if !utf8.ValidString(string(text)) {
			syscall.Exit(-2)
		}

		switch text[0] {
		case 'y', 'Y':
			syscall.Exit(0)
		}

		syscall.Exit(1)
	}

	syscall.Exit(1)
}
