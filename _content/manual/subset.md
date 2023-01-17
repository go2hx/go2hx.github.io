# Supported Subset

* Passing stdlib pkgs such as: unicode,math,string.
* All language features (go language without reference to the stdlib).


# Unsupported
* Cgo.
* Go assembly.
* Unsafe operations.
* Almost all of ``runtime``.
* syscall.
* Pointer addresses.
* Array unable to hold onto length value.
* UIntptr.
* Non passing stdblib pkgs.
* Some parts of ``reflection``.
* Parts of ``testing``.