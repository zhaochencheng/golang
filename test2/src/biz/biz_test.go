package biz

import (
	"fmt"
	"testing"
)

func TestGetRandomPair(t *testing.T) {
	str := formatTwoNumber(11,22)
	if str == "11-22\n"{
		t.Log("formatTwoNumber pass")

	} else {
		t.Error("formatTwoNumber fail")

	}
	//str1 := formatThreeNumber(11,22, 33,55)
	//if str1 == "11-22+33-55*11"{
	//	t.Log("formatThreeNumber pass")
	//} else {
	//	t.Error("formatThreeNumber fail")
	//}
}
func TestGetRandomPair2(t *testing.T) {
	str1 := formatThreeNumber(11,22, 33,55)
	if str1 == "11-22+33-55*11\n"{
		t.Log("formatThreeNumber pass")
	} else {
		fmt.Println(str1)
		t.Error("formatThreeNumber fail")
	}
}
