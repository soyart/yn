package main

import (
	"bufio"
	"os"
	"strings"
	"syscall"
)

func main() {
	prompt := "[Y/N]: "

	if len(os.Args) > 1 {
		prompt = os.Args[1] + " " + prompt
	}

	os.Stdout.WriteString(prompt)

	stdin := bufio.NewScanner(os.Stdin)
	if !stdin.Scan() {
		syscall.Exit(1)
	}

	text := stdin.Text()
	text = strings.TrimSpace(text)

	if len(text) == 0 {
		syscall.Exit(1)
	}

	if text[0] != 'y' && text[0] != 'Y' {
		syscall.Exit(1)
	}

	syscall.Exit(0)
}
