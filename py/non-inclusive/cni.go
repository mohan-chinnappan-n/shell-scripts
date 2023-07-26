package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func loadInclusiveMapping(file *os.File, delim string) map[string]string {
	inclusiveMapping := make(map[string]string)

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		parts := strings.Split(line, delim)
		if len(parts) == 2 {
			nonInclusive := strings.TrimSpace(strings.ToLower(parts[0]))
			inclusive := strings.TrimSpace(parts[1])
			inclusiveMapping[nonInclusive] = inclusive
		}
	}

	return inclusiveMapping
}

func replaceNonInclusive(document string, inclusiveMapping map[string]string) string {
	words := strings.Fields(document)
	for i, word := range words {
		lowerWord := strings.ToLower(word)
		if inclusive, found := inclusiveMapping[lowerWord]; found {
			words[i] = "[" + word + "/" + inclusive + "]"
		}
	}
	return strings.Join(words, " ")
}

func main() {
	if len(os.Args) < 4 {
		fmt.Println("Usage: go run main.go --noninclusive <non_inclusive_file> --doc <document_file> [--delim <delimiter>]")
		os.Exit(1)
	}

	nonInclusiveFile, err := os.Open(os.Args[2])
	if err != nil {
		fmt.Println("Error: Unable to open non-inclusive words file.", err)
		os.Exit(1)
	}
	defer nonInclusiveFile.Close()

	documentFile, err := os.Open(os.Args[3])
	if err != nil {
		fmt.Println("Error: Unable to open document file.", err)
		os.Exit(1)
	}
	defer documentFile.Close()

	delim := ","
	if len(os.Args) >= 6 && os.Args[4] == "--delim" {
		delim = os.Args[5]
	}

	inclusiveMapping := loadInclusiveMapping(nonInclusiveFile, delim)

	scanner := bufio.NewScanner(documentFile)
	var document string
	for scanner.Scan() {
		document += scanner.Text() + "\n"
	}

	replacedDocument := replaceNonInclusive(document, inclusiveMapping)

	fmt.Println("Replaced document:")
	fmt.Println(replacedDocument)
}

