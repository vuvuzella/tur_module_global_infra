package tests

import (
	"fmt"
	"modules/tests/data-stores/MySqlTest"
	"modules/tests/network/AlbTest"
	"modules/tests/services/HelloWorldAppTest"
	"testing"
)

func TestMain(t *testing.T) {
	fmt.Println("Starting Parallel Tests")

	t.Run("group", func(t *testing.T) {
		t.Run("Alb", AlbTest.TestAlbExample)
		t.Run("Hello World App", HelloWorldAppTest.TestHelloWorldAppExample)
		t.Run("My SQL", MySqlTest.TestMySql)
	})

	fmt.Println("Tests have Finished")
}
