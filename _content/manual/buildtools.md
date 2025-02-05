# Build tools

Run for help with flags:
```haxe
haxelib run go2hx -h
```

# lib go2hx

go2hx is also a library that needs to be included with any go2hx compiled code.

That's because go2hx as a lib holds the compiled Go std lib in order to speed up compiles.

# Go test
Flag ``-test`` toggles go2hx testing mode and compiles code as if ``go test`` command was used.

Test mode will use the test ``main`` Go generates as the main entry point.

go2hx by default in test mode will call Haxe eval on the compiled code.


# Targets

In the same way as Haxe, go2hx can take a target flag to compile the Haxe code for example ``-hl out.hl``

You can also set a target flag and then use ``-norun`` to not run the Haxe compiler after go2hx compiles.

Setting ``-norun`` is useful with ``-hxml build.hxml`` flag that will create an hxml that can be manually run and has all of the flags needed.

# Extra flags

| Flag | Description | 
| --- | --- |
| -nocomments | removes comments from the compiled code. |
| -printgocode | add Go code as a comment to the generated Haxe code. |
| -libwrap | all non main packages wrapped as a haxelib library. |
| -out | output path for the generated code to Go, default golibs |
| -root | set the root package for all compiled files for example: -root stdgo -> ``package root...`` |
