import sys.FileSystem;

var exportPath = "page/"; // add trailing backslash at end

function main() {
    if (exportPath != "" && !FileSystem.exists(exportPath))
        FileSystem.createDirectory(exportPath);
    if (!FileSystem.exists("go2hx"))
        Sys.command("git clone https://github.com/go2hx/go2hx");
    if (!FileSystem.exists("page/stdgo"))
        FileSystem.createDirectory("page/stdgo");
}