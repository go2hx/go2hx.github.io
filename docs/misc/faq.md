# FAQ

### Does the compiler support Go as a Haxe target?
No and it's not within the scope of the project, however happy to knowledge transfer and support any Go target for Haxe.

### Can high performance be achieved with the compiled code?
Yes! There is no inherent systemic issue with the compiled code having comparable speeds with normal Haxe code. The compiler does AST to AST translation so it is at the same level of abstraction for the Haxe compiler to be able to optimize the code in the same way as if it was handwritten.

The layer functions or interop files for the go2hx styled Haxe code to normal Haxe code does have a performance penalty, however for basics types it can be 0 because of Haxe's 0 cost abstractions.

In the case of structures or other cases where there is an allocation, it is possible to use the internal go2hx data types to not pay the penalty (at the cost of ease of use).

This area is truthfully not very well explored, as the current priority of the project is correctness.

If it is a pain point for your use case, we would love to hear more about it and improve it.

### Why not use externs instead of compiling Go code into Haxe?
Because externs prevent multi target usage of the compiler and they need to be maintained and written. This project is meant to provide 100s of thousands of high quality tested Go libraries with no maintenance and no need to write an abstraction level.

### Cgo support?
Not supported but happily accepting contributions for it!

[More information](../comptaibility/cgo.md)

### How does this compare to Gopherjs or Go wasm?
go2hx's design is built with Haxe devs in mind, therefore the goals align with Haxe dev advantages of the compiler, with that said go2hx does have some advantages already, smaller code generation, access to Haxe's compiler tooling such as dce and optimizations, and Haxe as a language being very portable, high level and statically typed.

### What internals does stdlib use?
The compiler uses Haxe stdlib implementations when interacting with the file system and primitive math operations.
In other cases the internals are transpiled into Haxe code and uses those.
