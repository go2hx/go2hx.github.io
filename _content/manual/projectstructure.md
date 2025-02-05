# Project structure

1. ``export.go`` handles the Gocompiler getting the AST and type info as input and then outputting with the help of reflection into json data to send to the Haxe part of go2hx.

2. ``src/Main.hx`` handles arguments and the initial setup of spinning up ``export.go`` calling ``src/Typer.hx`` and running ``src/Gen.hx`` on the results. Also deals with creating hxmls and sending commands to the Haxe compiler. Decodes the json and creates an InstanceData class to be sent to ``src/Typer.hx``

3. ``src/Typer.hx`` handles the bulk of the compilation process by turning typed Go AST into Haxe AST.