## Name conversions

Go uses uppercase field/class/method names to mark a field as public access and non as private.
The Haxe compiler requires uppercase class names, but has no requirement for fields however the best practice is for field names to be lowercase camelCasing styled.

The compiler go2hx converts Gostyled names to Haxe styled names with a set of rules.

* Method/Field names: uppercase to lowercase, and lowercase to underline.
* Class names: uppercase no conversion, and lowercase to "T_" prefix added.

## Reserved names

go2hx holds a list of reserved names which if seen have "_" added as a suffix.

```haxe
final reserved = [
	"iterator", "keyValueIterator", "switch", "case", "break", "continue", "default", "is", "abstract", "cast", "catch", "class", "do", "function", "dynamic",
	"else", "enum", "extends", "extern", "final", "for", "function", "if", "interface", "implements", "import", "in", "inline", "macro", "new", "operator",
	"overload", "override", "package", "private", "public", "return", "static", "this", "throw", "try", "typedef", "untyped", "using", "var", "while",
	"construct", "null", "in", "wait", "length", "capacity", "bool", "float", "int", "struct", "offsetof", "alignof",
];
```