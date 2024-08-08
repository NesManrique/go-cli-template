package main

import (
	"log"
	"os"

	"github.com/NesManrique/go-cli-template/cmd/hello"
	"github.com/urfave/cli/v2"
)

var Version string

func main() {
	app := &cli.App{ //nolint: exhaustruct
		Name:                 "go-cli-template",
		EnableBashCompletion: true,
		Version:              Version,
		Description:          "Go CLI Project Template",
		Commands: []*cli.Command{
			hello.CommandHello(),
		},
		Metadata: map[string]any{
			"Author":  "NesManrique",
			"LICENSE": "MIT",
		},
	}

	if err := app.Run(os.Args); err != nil {
		log.Fatal(err)
	}
}
