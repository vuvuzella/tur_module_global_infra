To use this test:

1. Install Go from https://golang.org/doc/install. use default installation
2. Configure the GOPATH. by default, the GOPATH is in $HOME/go. if this does not exist, create it using `mkdir -p ~/go/src`
3. Create a symlink `ln -s /usr/local/go/bin ~/go` 
4. Now your `go` in home directory should have a `bin` and `src` folder
5. Create a symlink in the src folder to this test folder where the go code is located:
`ln -s <absolute_path_to_this_folder>/test ~/go/src/<any_name>`
6. Inside the go test folder, run `go test -v`. it should output the text in the test sanity file
7. Run `gp mod tidy` to ensure terratest module has been downloaded
