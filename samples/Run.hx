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
        var extraCommand = "-lib go2hx";
        var hasDCE = true;
        var obfuscateBool = true;
        switch name {
            case "harmonica":
                extraCommand = "-lib heaps -lib go2hx_harmonica";
                hasDCE = false;
                obfuscateBool = false;
            default:
               // trace("skip!");
                //continue;
        }
        var cmd = 'npx haxe -cp samples -cp go2hx/golibs -m cases.$fileName $extraCommand -js page/samples/$name.js ' + (hasDCE ? "--dce full " : "");
        // normal
        Sys.println(cmd);
        final code = runCode ? Sys.command(cmd) : 0;
        if (code != 0)
            throw 'failed running command: $cmd';
        final normalSize = FileSystem.stat('page/samples/$name.js').size >> 10;
        trace("normalSize " + normalSize);
        // minified
        cmd += "-lib closure" + (obfuscateBool ? " -lib hxobfuscator" : "");
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