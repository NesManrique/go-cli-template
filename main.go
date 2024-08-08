package main

import (
	"log"
	"os"

	"github.com/urfave/cli/v2"
)

var Version string

func main() {
	//flags, err := clienv.Flags()
	//if err != nil {
	//panic(err)
	//}

	app := &cli.App{ //nolint: exhaustruct
		Name:                 "go-cli-template",
		EnableBashCompletion: true,
		Version:              Version,
		Description:          "Go CLI Project Template",
		Commands:             []*cli.Command{},
		Metadata: map[string]any{
			"Author":  "NesManrique",
			"LICENSE": "MIT",
		},
		// Flags: flags,
	}

	if err := app.Run(os.Args); err != nil {
		log.Fatal(err)
	}
}
