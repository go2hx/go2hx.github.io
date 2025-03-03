## go4hx
- Written in Golang.
- ``./export.go`` and ``./analysis``
- Go is a bootstrapped language, and the Go compiler is in the stdlib and accessed via ``./export.go``
- Uses reflection and recursion to turn the Go typed AST into JSON data
- Sends the json data over local TCP network to go2hx. go4hx uses the TCP client, and go2hx is the TCP server.
- go4hx the name is a play on words of Go being used for Haxe.

## go2hx
- Written in Haxe
### ./src
- ``Typer.hx`` handles all of the AST transformation.
- ``Patch.hx`` patches the Go stdlib with Haxe code.
- ``Gen.hx`` generates all of the Haxe files from arrays of TypeDefinition, creates the interop layer.
- ``Main.hx`` entry point to the compiler handles the CLI arguments and calling ``./src/Typer.hx`` and ``./src/Gen.hx``.
- ``Printer.hx`` modified ``haxe.macro.Printer`` 
- ``Args.hx`` a fork of a fork of hxargs.
- ``Cache.hx`` a cache to skip files already generated with the same contents as previously.
- ``Network.hx`` a network abstraction of the TCP server that accepts connections from ``go4hx``
- ``Types.hx`` type information copied over from ``stdgo/_internal/internal/reflect/Reflect`` and used internally within the compiler and most of the time transformed into ``haxe.macro.Expr.ComplexType``
- ``Util.hx`` utility functions that are often used by [scripts](#scripts) and [src](#src)

### ./scripts
- ``StdGo.hx`` compiles Go's stdlib into Haxe and adds it to package [stdgo](#stdgo)



## ./stdgo
Most files here are compiled, the list below are the exceptions
- ``Go.hx`` and ``Go.macro.hx`` the all in one class that handles creating ``interface{}/any``(stdgo.AnyInterface), normal interfaces, it holds recover exception, etc. Best way to learn more is to read the api.
- ``GoNumber.hx``, ``GoInt32.hx`` etc, there are number abstracts that mimic how Go does math, for example Go integer division results in an integer.
- ``Pointer`` an abstract class that mimics Pointers in Haxe.
- ``Slice.hx`` an abstract class that represents the slice type ``[]type``.
- ``Slice.hx`` an abstract class that represents the Go array type ``[count]type``.
- ``AnyInterface`` an abstract class that represents any type in Go ``any`` or ``interface{}``.

