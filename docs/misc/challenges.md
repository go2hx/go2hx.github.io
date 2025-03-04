# Challenges
Didn't think your life was easy enough?

Wanted a new type of challenge to embark on... welcome!


## Bootstrapping

```json
{
    "Imports": [
        "bytes",
        "compress/zlib",
        "embed",
        "encoding/binary",
        "encoding/json",
        "fmt",
        "github.com/go2hx/go4hx/analysis",
        "go/ast",
        "go/constant",
        "go/importer",
        "go/printer",
        "go/token",
        "go/types",
        "golang.org/x/tools/go/packages",
        "golang.org/x/tools/go/types/typeutil",
        "log",
        "math/rand",
        "net",
        "os",
        "path",
        "path/filepath",
        "reflect",
        "runtime",
        "runtime/debug",
        "strconv",
        "strings"
    ]
}
```

Get this list of imports working along with the code and slowly allow the compiler to compile it's self.

## Stdgo cleanup

1.6 million lines of code, change that code is compiled on the fly rather then committed for the stdlib and excluded when normal compiling.

## HXB

Use the new Haxe binary format to store the generated code in a compact and pre typed AST format.

## LSP and compile times

Related to HXB find out ways to cut down on the language server response time. As well as compiling the code into a given target.


