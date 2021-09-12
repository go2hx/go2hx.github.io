package;

import haxe.Template;
import sys.io.File;
import haxe.io.Path;
import sys.FileSystem;

function main() {
    final dir = "_content";
    for (path in FileSystem.readDirectory(dir)) {
        if (Path.extension(path) == "md") {
            saveContent(dir,"",path);
            continue;
        }
        if (!FileSystem.isDirectory(path))
            continue;
        for (file in FileSystem.readDirectory(path)) {
            if (Path.extension(file) != "md")
                continue;
            saveContent(dir,path,file);
            break;
        }
    }
}

private function saveContent(dir,path,file) {
    final content = Markdown.markdownToHtml(File.getContent(Path.join([dir,path,file])));
    if (FileSystem.exists(Path.join([dir,path,"index.html"]))) {
        var temp = new Template(File.getContent(Path.join([dir,path,"index.html"])));
        File.saveContent(Path.join([path,"index.html"]),temp.execute({content: content}));
    }
}