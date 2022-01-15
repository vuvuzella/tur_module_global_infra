package tests

import (
	"fmt"
	"modules/tests/network/alb"
	"modules/tests/services/HelloWorldAppTest"
	"testing"
)

func TestMain(t *testing.T) {
	fmt.Println("Starting Parallel Tests")

	t.Run("group", func(t *testing.T) {
		t.Run("Alb", alb.TestAlb)
		t.Run("Hello Worl App", HelloWorldAppTest.TestHelloWorldAppExample)
	})

	fmt.Println("Tests have Finished")
}
