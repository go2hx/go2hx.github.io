# Supported Subset


* [Passing stdlibs on supported targets](https://go2hx.github.io/stdgo/index.html) for example: unicode,math,string on hashlink and interp
* The go language excluding the [stdlib](https://pkg.go.dev/std).


# Unsupported
* [Cgo](https://go.dev/blog/cgo).
* [Go assembly](https://go.dev/doc/asm).
* [Unsafe operations](https://pkg.go.dev/unsafe).
* Almost all of stdlib [runtime](https://pkg.go.dev/runtime).
* stdlib [syscall](https://pkg.go.dev/syscall).
* Pointer addresses for example: 0xc000014088.
* Array unable to always hold onto length value.
* UIntptr.
* Some parts of stdlib [reflection](https://pkg.go.dev/reflect).
* Some parts of libs [testing](https://pkg.go.dev/testing).