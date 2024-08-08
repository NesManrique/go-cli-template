package hello

import (
	"fmt"

	"github.com/urfave/cli/v2"
)

const (
	flagHelloName = "name"
)

func CommandHello() *cli.Command {
	return &cli.Command{ //nolint:exhaustruct
		Name:   "hello",
		Action: commandHello,
		Usage:  "Say hello to someone",
		Flags: []cli.Flag{
			&cli.StringFlag{ //nolint:exhaustruct
				Name:        flagHelloName,
				Value:       "World",
				Usage:       "Set who you want to greet.",
				EnvVars:     []string{"HELLO_NAME"},
				DefaultText: "World",
			},
		},
	}
}

func commandHello(cCtx *cli.Context) error {
	fmt.Printf("Hello %s\n", cCtx.String(flagHelloName))
	return nil
}
