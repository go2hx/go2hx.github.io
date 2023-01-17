# Reflection

Go's reflection is more complex then Haxe's therefore a hybrid macro compiler generation approach is used to deal with reflection types.

Conversion to AnyInterface or in Go terms: any or interface{}
```haxe
Go.toInterface(x);
```

Reflection Type info is stored in the GoType enum found in internal reflect (also used for the compiler).
