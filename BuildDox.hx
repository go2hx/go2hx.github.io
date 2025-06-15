function main() {
    Sys.command("rm -d -r page/api/hashes");
    if (sys.FileSystem.exists("page/api/hashes/go2hx.md5"))
       sys.FileSystem.deleteFile('page/api/hashes/go2hx.md5');
    addStdImports();
    createDox("go2hx Compiler", "Go to Haxe source-to-source compiler", "go2hx", "stdgo", "stdgo", "api", "-cp golibs");
    return;
    // regexp2
    trace("regexp2");
    Sys.command("rm -d -r page/regexp2/api/hashes");
    addImport("github_dot_com.dlclark.regexp2.Regexp2");
    // create dox for regexp2
    createDox("go2hx regexp2", "Precompiled regexp2 library in Haxe", "regexp2", "github_dot_com.dlclark.regexp2", ".", "regexp2/api", "-lib go2hx_regexp2");
}

function createDox(title:String, desc:String, repo:String, topLevel:String, inStr:String, output:String, command:String) {
    if (!sys.FileSystem.exists('page/$output'))
        sys.FileSystem.createDirectory('page/output');
    /*if (title == "go2hx Compiler") {
        sys.io.File.copy("page/logoapi.svg", 'page/$output/logo.svg');
    }*/
    Sys.command('haxe dox.hxml $command');
    final version = haxe.Json.parse(sys.io.File.getContent("go2hx/haxelib.json")).version;
    // -D logo logo.svg
    final cmd = 'haxelib run dox -D description "$desc" -D toplevel-package $topLevel -D website https://go2hx.github.io -i go2hx.xml -o page/$output --title "$title" -D version $version -in $topLevel -D source-path "https://github.com/go2hx/$repo/blob/master/"';
    trace(cmd);
    Sys.command(cmd);
}

function addStdImports() {
    final list:Array<String> = haxe.Json.parse(sys.io.File.getContent("go2hx/tests/std_hl.json"));
    final imps = [];
    for (std in list) {
        std = std.substr("hl|".length);
        final fileName = title(haxe.io.Path.withoutDirectory(std));
        std = StringTools.replace(std, "/", ".");
        final path = 'stdgo.$std.$fileName';
        imps.push('import $path;');
    }
    imps.push("function main() {}");
    sys.io.File.saveContent("DoxMain.hx", imps.join("\n"));
}

function addImport(imp:String) {
    final imps = [
        'import $imp;',
        "function main() {}",
    ];
    sys.io.File.saveContent("DoxMain.hx", imps.join("\n"));
}

function title(s:String):String {
    return s.charAt(0).toUpperCase() + s.substr(1);
}