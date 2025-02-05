
<img src="logo.svg" width="420" align="right"/>


<h1><font color="#357b99">go</font><font color="#cad0d8">2</font><font color="#e2ac3f">hx</font></h1>

*warning: experimental version.*

Compile [Go](https://go.dev) to [Haxe](https://haxe.org).

Use Go libs with ease!
    
[**Get started!**](./manual/getstarted.html)

[Samples](./samples/index.html)

[Manual](./manual/index.html)

[In progress tracking graph](./test883/index.html)

<details open><summary>Standard Library compatibility/api docs</summary>::support::</details>
<details><summary>FAQ</summary>

## Can library X be compiled?
Maybe, to see if the library is supported at the moment ``go get library_here`` the library and then run:
```sh
go list -f '{{ .Imports }}' library here
```
Then check to see if the standard libraries used are all passing with the compatibility table above.



## Does the compiler support Go as a Haxe target?
No and it's not within the scope of the project.

## Why not use externs instead of compiling Go code into Haxe?
Because externs can target lock a code base and they require maintenance, abstraction code etc.

## Cgo support?
Not available but planned and happily accepting contributions for it!

## How does this compare to Gopherjs or Go wasm?
go2hx's design is built with Haxe devs in mind, therefore the goals align with Haxe dev advantages of the compiler, with that said go2hx does have some advantages already, smaller code generation, access to Haxe's compiler tooling such as dce and optimizations, and Haxe as a language being very portable, high level and statically typed.

## What internals does stdlib use?
go2hx's compiler, compiles the standard library packages for example ``os``. After compilation a Patcher system switches out functions/variables/structs for a Haxe equivalent, for example ``os.Open`` uses ``sys.io.File.read`` and ``sys.io.File.write``.

</details>

### Contributing:

The project is still at an experimental level, so expect undocumented problems to spring up.
**The best way to contribute** is to simply use the compiler on code you would like and inevitably run into errors. From there we can answer some questions to see:

<details>
<summary>how to proceed!</summary>

## What time is the error happening?: 
* Go compiler time (``./export.go`` named: go4hx)
* Haxe compiler time (``src/Typer.hx`` and ``./stdgo/internal/reflect/Reflect.hx`` etc)
* compile time (Haxe build tools example: ``haxe build.hxml``)
* runtime (Code running example: ``hl build.hl`` or ``node build.js``).

## How can the code causing the error be reduced to a simple sample?
* Use ``./rnd/main.go`` as a testbed and run it with: ``haxe rnd.hxml``
* Modify the Go code with debug prints or the Haxe compiled code with traces and figure out where is the precise error point.
* Copy over structs and interfaces if needed that are used by the erroring code sample.
* Make usage of go2hx's reflection for example:
```go
println(reflect.TypeOf(value).String())
```

## Does the code throw "not implemented" error?
* Look at the unimplemented function's [documentation](https://pkg.go.dev/std)
* Implement the missing functionality into the Patcher ``./src/Patch.hx`` following the naming convention ``path:FunctionName`` or ``path.Type:FunctionName`` for [recv functions](./ast.html).

## Is the type casting invalid?
* Look into ``./src/Typer.hx`` and search for ``function checkType`` for implicit type conversions and for casts ``function castTranslate``
* A lot of helper type functions are called in ``./stdgo/internal/reflect/Reflect`` for example ``getUnderlying`` and the entire module is imported into ``Typer.hx`` so you won't see clear reference that the code is there.

</details>

#### Have issues and/or want to contribute?
[![github](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/go2hx/go2hx)
[![discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/ewnMZAV)