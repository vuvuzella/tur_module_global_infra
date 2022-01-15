### Pre-requisites
1. Go 1.17

### Steps to run the tests
1. set GOPATH to your go directory
2. set GOBIN to you go's bin directory
3. From root folder, cd into tests
4. run `go mod tidy` to download dependencies
5. run `go test -v -timeout 30m` to start the tests.

### Notes
* Tests have their own cleanups
* Tests uses the examples folder to deploy infrastructure
* Each Test have their own statre files
* Tests run in parallel
