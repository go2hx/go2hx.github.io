# Haxe extern

Refrence Haxe code with ease from Golang.

## main.go
```go
package main

func main() {
    test(10)
}

//#go2hx sub.Foo.data
func test(i int) {
    println("Go:",i)
}
```
## sub/Foo.hx
```haxe
package sub;
import stdgo.StdGoTypes;

function data(i:GoInt) {
  Sys.println("Haxe: " + i);
}
```

## Notes
* The module path is determined by the hxml config being used on the Haxe side for instance if -cp sub was included the extern config could be changed to //#go2hx Foo.data
* Argument name matching does not matter.
* Argument types and return types in most cases should be [mapped](./types.html) to the go2hx type.