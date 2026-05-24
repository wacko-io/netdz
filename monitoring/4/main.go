package main

import (
	"errors"
	"time"

	"github.com/getsentry/sentry-go"
)

func main() {
	sentry.Init(sentry.ClientOptions{
		Dsn: "dsn", //убрал чтобы в гит не сливать
	})
	defer sentry.Flush(2 * time.Second)

	sentry.CaptureMessage("Hello from Sentry!")

	sentry.CaptureException(errors.New("test error"))
}
