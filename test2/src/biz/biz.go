package biz

import (
	"fmt"
	"go_test/test2/src/lib"

	//"lib"
)
func formatTwoNumber(a, b int) string {
	return fmt.Sprintf("%d-%d\n", a, b)
}
func GetRandomPair() string {
	return formatTwoNumber(lib.GetRandomNumber(), lib.GetRandomNumber())
}
func formatThreeNumber(a, b, c int)  string{
	return fmt.Sprintf("%d-%d+%d\n", a, b , c)
}