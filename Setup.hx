import sys.FileSystem;

var exportPath = "page/"; // add trailing backslash at end

function main() {
    if (exportPath != "" && !FileSystem.exists(exportPath))
        FileSystem.createDirectory(exportPath);
    if (!FileSystem.exists("go2hx"))
        Sys.command("git clone --depth 1 https://github.com/go2hx/go2hx");
    Sys.command("haxelib run go2hx std --nohxb");
}