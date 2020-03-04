package main

import (
	"flag"
	"testing"
)

var systemTest *bool

func init() {
	systemTest = flag.Bool("SystemTest", false, "Set to true when running system tests")
}

func TestMain(t *testing.T) {
	if *systemTest {
		main()
	}
}
