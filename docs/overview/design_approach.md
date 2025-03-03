## Design approach


## Haxe focused
- Intentionally written primarily in Haxe code.
- Focused on improving the Haxe ecosystem first.
- Uses the latest language features from Haxe.
- Uses Haxe macros to simulate the Go type system.
- Creates an interop layer to interact with the compiled code as if it was handwritten Haxe code.
- Plan to remove Go as a dependency.
- Haxe focused but not excluding the opportunities in the Go ecosystem, more using the Haxe ecosystem to build up correctness and a community before branching out more.


## AST to AST
- Transforms Go's AST to Haxe's AST.
- No needless intermediate representations.
- Keeps the abstraction level practically the same for both language.

## Not reinventing the wheel
- Uses Go's own compiler to generate the typed AST.
- Uses Haxe's ``macro`` keyword to create Haxe exprs.
- Uses Haxe's own printer to print out the Haxe AST.
- go2hx does not have its own parser, lexer, type inference system, printer, or expr data structures.

## Built on the backs of giants
- Spiritual successor to tardisgo created by Elliott Stoneham who is a core contributor and founder of the project.
- Pulling lessons from the projects that came before, and iterating upon the knowledge both technical, design and communication wise.
- Uses both tardisgo and gopherjs as a reference implementation for many parts of the compiler.