package lib

import (
	"math/rand"
	"time"
)
func GetRandomNumber() int {
	rand.Seed(time.Now().UnixNano())
	return rand.Int()
}