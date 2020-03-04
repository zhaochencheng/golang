package biz

import (
	"testing"
)

func TestGetRandomPair(t *testing.T) {
	str := formatTwoNumber(11,22)
	if str == "11-22\n"{
		t.Log("formatTwoNumber pas")

	} else {
		t.Error("formatTwoNumber fail")

	}
}
