## Get started


### Installation
* [Download Go 1.16+](https://golang.org/dl/)
* [Download Haxe 4.3.0-rc.1 or later](https://build.haxe.org/builds/haxe/)

```sh
haxelib git go2hx https://github.com/go2hx/go2hx
```
Create a main.go to find good small test programs look at [gobyexample](https://gobyexample.com/):
```go
package main
func main() {
    println("hello world")
}
```
Run compiler:
```sh
haxelib run go2hx ./main.go
```