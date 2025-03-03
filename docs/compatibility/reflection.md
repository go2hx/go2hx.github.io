# Reflection

The package is fully patched out, and replaced with a system that uses the construction of type information with enums created for go2hx emulation of the Go type system.

Many reflection methods are unimplemented or incorrect, heavily used reflection methods will likely work but are not directly tested as other stdlibs are.

The patches for reflection can be found ``stdgo/_internal/internal/reflect/Reflect`` and ``src/Patch.hx``.