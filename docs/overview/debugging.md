# debugging

The project has no support for a debugger. Debugging can be done on the Haxe code and Go code and compared but often that approach is slow and complex.

The current method is to add prints in the Go code and compile it into Haxe and compare the Go running version with the Haxe version's output.

If you don't want to create a testbed to do this, there is one included within the compiler source.

## Rnd

It is found in ``./rnd`` where ``./rnd/main.go`` is the file to edit to make the changes and can be run with the command(requires hashlink by default):
```sh
haxe --run Make rnd
```

Contributions welcome for improvements or adding more sophisticated debuggers!
