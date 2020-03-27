package biz

import (
	"fmt"
	"go_test/golang/test2/src/lib"

	//"lib"
)
func formatTwoNumber(a, b int) string {
	print(fmt.Sprintf("%d-%d\n", a, b))
	return fmt.Sprintf("%d-%d\n", a, b)
}
func GetRandomPair() string {
	print(formatTwoNumber(lib.GetRandomNumber(), lib.GetRandomNumber()))
	return formatTwoNumber(lib.GetRandomNumber(), lib.GetRandomNumber())
}
func formatThreeNumber(a, b, c ,d int)  string {
	print(fmt.Sprintf("%d-%d+%d-%d*%d\n", a, b , c, d, a))
	return fmt.Sprintf("%d-%d+%d-%d*%d\n", a, b , c, d, a)
}
func GetRandomPair2() string {
	return formatThreeNumber(lib.GetRandomNumber(), lib.GetRandomNumber(), lib.GetRandomNumber(), lib.GetRandomNumber())
}
func formatfourNumber(a, b, c ,d int)  string {
	print(fmt.Sprintf("%d-%d+%d-%d*%d\n", a, b , c, d, a))
	return fmt.Sprintf("%d-%d+%d-%d*%d\n", a, b , c, d, a)
}
func GetRandomPair3() string {
	return formatfourNumber(lib.GetRandomNumber(), lib.GetRandomNumber(), lib.GetRandomNumber(), lib.GetRandomNumber())
}