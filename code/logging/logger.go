package logging

import (
	"fmt"
	"os"
)

type logger interface {
	write(string, ...interface{})
	flush()
}

var currentLogger Logger = Logger{dummyLogger{}}

type dummyLogger struct{}

func (l dummyLogger) write(f string, a ...interface{}) {
	fmt.Fprintf(output, f, a...)
}

func (l dummyLogger) flush() {
	os.Stdout.Sync()
}
