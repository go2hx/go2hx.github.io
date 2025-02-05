# go2hx specific debugging

go2hx uses the ``./rnd`` testbed for debugging and testing. It compiles Go code and then compiles the Haxe code and after compiles the Go source to compare the results.

A similar solution or forking from this system is a good approach. Hooks could be established into the compiler to check that the code is behaving exactly the same, and debug info could be added into the Gosource code so that both Goand go2hx can be debugged at the same time.