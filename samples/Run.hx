import sys.io.File;
import haxe.macro.Compiler;
import sys.FileSystem;
using haxe.io.Path;
using StringTools;
function main() {
    for (file in FileSystem.readDirectory("samples/cases")) {
        final fileName = file.withoutExtension();
        final name = fileName.toLowerCase();
        File.saveContent('_content/samples/$name.md', File.getContent("_content/samples/rnd.md")
            .replace("rnd.js", name + ".js")
            .replace("# Rnd", "# " + fileName)
        );
        final cmd = 'haxe -cp samples -m cases.$fileName -lib go2hx -js page/samples/$name.js';
        Sys.println(cmd);
        Sys.command(cmd);
    }
}