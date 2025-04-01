
<img src="logo.svg" width="340" align="right"/>


<br>
<br>

    Open source Haxe compiler

    Import Go libraries in your Haxe projects


[Get started!](https://github.com/go2hx/go2hx#getting-started)

[Cool graphs!](https://go2hx.github.io/test883)

<iframe width="420" height="315" src="https://www.youtube.com/embed/fzyGwSGyoRw">

<details open><summary>Standard Library compatibility</summary>::support::</details>
<details open><summary>FAQ</summary>

### Can library X be compiled?

#### Check online via:
<iframe src="https://go2hx.mki.sh/" width="400" height="500"></iframe>


#### Manual check:
You would need to check what imports and language features the library is using.


If it uses unsafe or generics, the library will not work.


If it uses networking or unsupported stdlibs it also will not work.

### Does the compiler support Go as a Haxe target?
No and it's not within the scope of the project, however happy to knowledge transfer and support any Go target for Haxe.

### Can high performance be achieved with the compiled code?
Yes! There is no inherent systemic issue with the compiled code having comparable speeds with normal Haxe code. The compiler does AST to AST translation so it is at the same level of abstraction for the Haxe compiler to be able to optimize the code in the same way as if it was handwritten.

The layer functions or interop files for the go2hx styled Haxe code to normal Haxe code does certantily have a performance penality, however for basics types it can be 0 because of Haxe's 0 cost abstractions, and in the case of structures or other cases where this is an allocation, it is possible to use the internal go2hx datatypes to not pay the penality (at the cost of ease of use).

This area is truthfully not very explored because of the priority of getting the compiler correct. If it is a painpoint for your usecase, we would love to hear more about it and improve it.

### Why not use externs instead of compiling Go code into Haxe?
Because externs prevent multi target usage of the compiler and they need to be maintained and written. This project is meant to provide 100s of thousands of high quality tested Go libraries with no maintance and no need to write an abstraction level.

### Cgo support?
Not available but planned and happily accepting contributions for it!

### How does this compare to Gopherjs or Go wasm?
go2hx's design is built with Haxe devs in mind, therefore the goals align with Haxe dev advantages of the compiler, with that said go2hx does have some advantages already, smaller code generation, access to Haxe's compiler tooling such as dce and optimizations, and Haxe as a language being very portable, high level and statically typed.

### What internals does stdlib use?
The compiler uses Haxe stdlib implmentations when interacting with the fileysytem and primitive math operations.
In other cases the internals are transpiled into Haxe code and uses those.

#### Have issues and/or want to contribute?
[![github](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/go2hx/go2hx)
[![discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/ewnMZAV)