import sys.io.File;
import haxe.macro.Compiler;
import sys.FileSystem;
using haxe.io.Path;
using StringTools;

inline var runCode = true;

function main() {
    for (file in FileSystem.readDirectory("samples/cases")) {
        if (file.extension() != "hx")
            continue;
        final fileName = file.withoutExtension();
        final name = fileName.toLowerCase();
        var cmd = 'haxe -cp samples -m cases.$fileName -lib go2hx -js page/samples/$name.js --dce full ';
        // normal
        Sys.println(cmd);
        final code = runCode ? Sys.command(cmd) : 0;
        if (code != 0)
            throw 'failed running command: $cmd';
        final normalSize = FileSystem.stat('page/samples/$name.js').size >> 10;
        trace("normalSize " + normalSize);
        // minified
        cmd += "-lib hxobfuscator -lib closure";
        Sys.println(cmd);
        final code = runCode ? Sys.command(cmd) : 0;
        if (code != 0)
            throw 'failed running command: $cmd';

        final minifiedSize = FileSystem.stat('page/samples/$name.min.js').size >> 10;
        trace("minifiedSize " + minifiedSize);

        final saveSize = Std.int((normalSize / minifiedSize) * 100);

        // save markdown
        File.saveContent('_content/samples/$name.md', File.getContent("_content/samples/rnd.md")
        // replace parts of rnd markdown with sample
        .replace("rnd.min.js", name + ".min.js")
        .replace("rnd.js", name + ".js")
        .replace("Rnd.hx", fileName + ".hx")
        .replace("rnd.svg", name + ".svg")
        .replace("normal_size", "" + normalSize)
        .replace("minified_size", "" + minifiedSize)
        .replace("save_size", "" + saveSize)
        .replace("# Rnd", "# " + fileName)
        );
    }
}