package lib

import (
	"testing"
)

func TestGetRandomNumber(t *testing.T) {
	if GetRandomNumber() >= 0 {
		t.Log("GetRandomNumber pass")

	} else {
		t.Error("GetRandomNumber fail")
	}
}