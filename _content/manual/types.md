# Basic Types

| go2hx | underlying type | Haxe equivalent | Go|
| --- | --- | --- | --- |
| <pre><code class="language-haxe">GoInt</code></pre> | <pre><code class="language-haxe">Int</code></pre> | <pre><code class="language-haxe">Int</code></pre> | <pre><code class="language-go">int32</code></pre> |
| <pre><code class="language-haxe">GoInt64</code></pre> | <pre><code class="language-haxe">haxe.Int64</code></pre> | <pre><code class="language-haxe">haxe.Int64</code></pre> | <pre><code class="language-go">int64/int</code></pre> |
| <pre><code class="language-haxe">GoFloat64</code></pre> | <pre><code class="language-haxe">Float</code></pre> | <pre><code class="language-haxe">Float</code></pre> | <pre><code class="language-go">float64 |
| n/a | n/a | <pre><code class="language-haxe">Bool</code></pre> | <pre><code class="language-go">bool</code></pre> |
| <pre><code class="language-haxe">GoString</code></pre> | <pre><code class="language-haxe">haxe.io.Bytes</code></pre> | <pre><code class="language-haxe">String</code></pre> | <pre><code class="language-go">string</code></pre> |

* Integer division returns an Integer not a Float unlike Haxe.
* Haxe's default Integer size is ``32`` Go's default Integer size is ``64``, go2hx uses Integer ``32`` as the default.


# Pointer Types
| go2hx | underlying type | Haxe equivalent | Go|
| --- | --- | --- | --- |
| <pre><code class="language-haxe">stdgo.Pointer<T></code></pre> | <pre><code class="language-haxe">stdgo.Pointer.PointerData<T></code></pre> | n/a | <pre><code class="language-go">*T</code></pre> |
| <pre><code class="language-haxe">Ref<T> | <pre><code class="language-haxe">typedef Ref<T> = T</code></pre> | n/a | <pre><code class="language-go">*T</code></pre> |
* Pointer is used for all pass by value types of Haxe i.e BasicTypes
* Ref is used for all pass by ref values, all other Haxe types besides BasicTypes.

# Channel Type
| go2hx | underlying type | Haxe equivalent | Go
| --- | --- | --- | --- |
| <pre><code class="language-haxe">stdgo.Chan<T></code></pre> | n/a | n/a | <pre><code class="language-go">chan[T]</code></pre> |
* Uses Haxe locks/mutexs internally.
* Used for goroutine data passing in a thread safe way.

# Map Type
| go2hx | underlying type | Haxe equivalent | Go|
| --- | --- | --- | --- |
| <pre><code class="language-haxe">stdgo.GoMap<K,V></code></pre> | <pre><code class="language-haxe">stdgo.GoMap.GoMapData<K,V></code></pre> | <pre><code class="language-haxe">Map<K,V></code></pre> | <pre><code class="language-go">map[K]V</code></pre> |
* Key equality is preformed using deep equality thereby structs for go2hx can be keys.
* Internally it uses an array of keys and values with calls to reflection.
* GoMap always holds the GoType information.

# Array Types
| go2hx | underlying type | Haxe equivalent | Go|
| --- | --- | --- | --- |
| <pre><code class="language-haxe">stdgo.Slice<T></code></pre> | <pre><code class="language-haxe">haxe.ds.Vector<T></code></pre> | <pre><code class="language-haxe">Array<T></code></pre> | <pre><code class="language-go">[]T</code></pre> |
| <pre><code class="language-haxe">stdgo.GoArray<T></code></pre> | <pre><code class="language-haxe">haxe.ds.Vector<T> | <pre><code class="language-haxe">haxe.ds.Vector<T></code></pre> | <pre><code class="language-go">[]T</code></pre> |

* Slice can have it's length change by creating a new copy with ``append``