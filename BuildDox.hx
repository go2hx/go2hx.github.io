function main() {
    if (!sys.FileSystem.exists("page/api"))
        sys.FileSystem.createDirectory("page/api");
    
    if (sys.FileSystem.exists("page/api/hashes/go2hx.md5"))
        sys.FileSystem.deleteFile('page/api/hashes/go2hx.md5');
    sys.io.File.copy("page/logoapi.svg", "page/api/logo.svg");
    addImports();
    Sys.command("haxe dox.hxml");
    final version = haxe.Json.parse(sys.io.File.getContent("go2hx/haxelib.json")).version;
    Sys.command('haxelib run dox -D description "Go to Haxe source-to-source compiler" -D toplevel-package stdgo -D website https://go2hx.github.io -D logo logo.svg -i go2hx.xml -o page/api --title "go2hx Compiler" -D version $version -in stdgo -D source-path "https://github.com/go2hx/go2hx/blob/master/"');
}

function addImports() {
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

function title(s:String):String {
    return s.charAt(0).toUpperCase() + s.substr(1);
}