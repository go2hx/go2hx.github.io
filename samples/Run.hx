import sys.io.File;
import haxe.macro.Compiler;
import sys.FileSystem;
using haxe.io.Path;
using StringTools;

inline var runCode = true;

function main() {
    Sys.command("haxelib run go2hx text/scanner hash/adler32 strings encoding/hex");
    for (file in FileSystem.readDirectory("samples/cases")) {
        if (file.extension() != "hx")
            continue;
        final fileName = file.withoutExtension();
        final name = fileName.toLowerCase();
        var args = [
            "haxe",
            "-cp",
            "samples",
            "-m",
            'cases.$fileName',
            '-js',
            'page/samples/$name.js'
        ];
        var hasDCE = true;
        var obfuscateBool = true;
        switch name {
            case "harmonica":
                args.push("-lib");
                args.push("heaps");
                args.push("-lib");
                args.push("go2hx_harmonica");
                hasDCE = false;
                obfuscateBool = false;
            default:
                args.push("-cp");
                args.push("golibs");
                args.push("-w");
                args.push("-WStaticInitOrder");
               // trace("skip!");
                //continue;
        }
        if (hasDCE) {
            args.push("--dce");
            args.push("full");
        }
        // normal
        final code = runCode ? Sys.command("npx", args) : 0;
        if (code != 0)
            throw 'failed running command: ' + args.join(" ");
        final normalSize = FileSystem.stat('page/samples/$name.js').size >> 10;
        trace("normalSize " + normalSize);
        // minified
        args.push("-lib");
        args.push("closure");
        if (obfuscateBool) {
            args.push("-lib");
            args.push("hxobfuscator");
        }
        final code = runCode ? Sys.command("npx", args) : 0;
        if (code != 0)
            throw 'failed running command';

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