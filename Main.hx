package;

import haxe.Template;
import sys.io.File;
import haxe.io.Path;
import sys.FileSystem;

var header:String = "";
var support:String = "";
var go:String = "";

var exportPath = "page/"; // add trailing backslash at end

function main() {
    if (exportPath != "" && !FileSystem.exists(exportPath))
        FileSystem.createDirectory(exportPath);
    if (!FileSystem.exists("go2hx"))
        Sys.command("git clone https://github.com/go2hx/go2hx");
    if (!FileSystem.exists("page/stdgo"))
        FileSystem.createDirectory("page/stdgo");
    header = File.getContent("_content/header.html");
    var path = "go2hx/stdgo/README.md";
    final stdList:Array<String> = haxe.Json.parse(File.getContent("go2hx/tests/std.json"));
    support = File.getContent("go2hx/stdgo/stdgo.md");
    final lines = support.split("\n");
    var startIndex = 0;
    final targets = ["hl"];
    for (i in 0...lines.length) {
        if (lines[i].charAt(0) == "|") {
            startIndex++;
        }
        switch startIndex {
            case 1:
                //lines[i] = StringTools.replace(lines[i], "compile", "docs");
                lines[i] += " " + targets.join(" | ") + " |";
            case 2:
                lines[i] += " --- | --- |";
            default:
                final str = "| [";
                final index = lines[i].indexOf(str);
                if (index != -1) {
                    var line = lines[i].substring(index + str.length,lines[i].indexOf("]",index));
                    line = line.substr("stdgo.".length);
                    line = StringTools.replace(line,".","/");
                    final noTestStr = "| no |";
                    if (lines[i].substr(lines[i].length - noTestStr.length) == noTestStr) {
                        lines[i] += [for (i in 0...targets.length) " _ |"].join("");
                    }else{
                        for (target in targets) {
                            if (stdList.indexOf('$target|$line') != -1) {
                                lines[i] += " ✅ |";
                            }else{
                                lines[i] += " ❌ |";
                            }
                        }
                    }
                }
        }
    }
    support = readmeToHtmlLink(Markdown.markdownToHtml(lines.join("\n")), false);
    final dir = "_content";
    for (path in FileSystem.readDirectory(dir)) {
        if (Path.extension(path) == "md") {
            saveContent(dir,"",path);
            continue;
        }
       final path2 = Path.join([dir,path]);
        if (!FileSystem.isDirectory(path2))
            continue;
        if (!FileSystem.exists(exportPath + path))
            FileSystem.createDirectory(exportPath + path);
        for (file in FileSystem.readDirectory(path2)) {
            if (Path.extension(file) != "md")
                continue;
            saveContent(dir,path,file);
        }
    }
    stdgo();
    if (exportPath != "") {
        for (path in FileSystem.readDirectory(".")) {
            switch Path.extension(path) {
                case "js","css","svg","png":
                    File.copy(path,'$exportPath$path');
                default:
            }
        }
    }
}

private function prettyprint(content:String) {
    content = StringTools.replace(content,"prettyprint haxe","language-haxe");
    content = StringTools.replace(content,"prettyprint go","language-go");
    return content;
}

private function stdgo() {
    stdgoRecursive("go2hx/stdgo",1);
}

private function readmeToHtmlLink(content:String,isStdgoPath:Bool):String {
    content = StringTools.replace(content,"README.md","index.html");
    content = StringTools.replace(content,"stdgo.md","index.html");
    if (!isStdgoPath) {
        content = StringTools.replace(content,'a href=".','a href="./stdgo');
    }
    return content;
}

private function stdgoRecursive(dir:String,depth:Int) {
    for (path in FileSystem.readDirectory(dir)) {
        path = Path.join([dir,path]);
        if (FileSystem.isDirectory(path)) {
            FileSystem.createDirectory(exportPath + path.substr("go2hx/".length));
            stdgoRecursive(path,depth+1);
        }else{
            if (Path.extension(path) == "md") {
                var content = File.getContent(path);
                content = readmeToHtmlLink(content,true);
                path = path.substr(0,path.length - "README.md".length);
                final fullpath = "https://github.com/go2hx/go2hx/tree/master/" + path.substr("go2hx/".length);
                content = StringTools.replace(content,"[\\(view code\\)](<.","[\\(view code\\)](<" + fullpath);
                content = prettyprint(Markdown.markdownToHtml(content));
                // open new tab for code preview
                content = StringTools.replace(content,">(view code)</a>",'target="_blank" rel="noopener noreferrer">(view code)</a>');
                trace(path);
                final temp = new Template(File.getContent("_content/stdgo.html"));
                final depth = [for (i in 0...depth) ".."].join("/");
                File.saveContent(exportPath + Path.join([Path.withoutExtension(path.substr("go2hx/".length)),"index.html"]),temp.execute({content: content,depth: depth,fullpath: fullpath,header: header}));
            }
        }
    }
}

private function saveContent(dir,path,file) {
    var content = File.getContent(Path.join([dir,path,file]));
    var temp = new Template(content);
    content = temp.execute({support: support}); // index.md template
    content = prettyprint(Markdown.markdownToHtml(content));
    content = highlight(content);
    if (FileSystem.exists(Path.join([dir,path,"index.html"]))) {
        temp = new Template(File.getContent(Path.join([dir,path,"index.html"])));
        trace(Path.join([dir,path,file]) + " -> " + Path.join([path,Path.withoutExtension(file) + ".html"]));
        File.saveContent(exportPath + Path.join([path,Path.withoutExtension(file).toLowerCase() + ".html"]),temp.execute({content: content, header: header})); // index.html template
    }else{
        throw  "not found index.html at: " + dir + " | " + path;
    }
}

private function highlight(content:String):String {
    content = StringTools.replace(content,".hx ",'.<font color="#e2ac3f">hx</font> ');
    content = StringTools.replace(content," hx ",' <font color="#e2ac3f">hx</font> ');
    content = StringTools.replace(content,"Haxe ",'<font color="#e2ac3f">Haxe</font> ');
    content = StringTools.replace(content,"Haxe.",'<font color="#e2ac3f">Haxe.</font>');
    content = StringTools.replace(content,"Haxe's ",'<font color="#e2ac3f">Haxe' + "'" + 's</font> ');

    content = StringTools.replace(content,"go2hx?",'<font color="#357b99">go</font>2<font color="#e2ac3f">hx</font>?');
    content = StringTools.replace(content,"go2hx's",'<font color="#357b99">go</font>2<font color="#e2ac3f">hx</font>' + "'s");
    content = StringTools.replace(content,"go2hx type",'<font color="#357b99">go</font>2<font color="#e2ac3f">hx</font> type');
    content = StringTools.replace(content,"and go2hx",'and <font color="#357b99">go</font>2<font color="#e2ac3f">hx</font>');
    content = StringTools.replace(content,"| go2hx |",'| <font color="#357b99">go</font>2<font color="#e2ac3f">hx</font> |');

    content = StringTools.replace(content," go ",' <font color="#357b99">go</font> ');
    content = StringTools.replace(content,"Go's",'<font color="#357b99">Go</font>' + "'s");
    content = StringTools.replace(content," Go ",' <font color="#357b99">Go</font> ');
    content = StringTools.replace(content,"golang ",'<font color="#357b99">golang</font> ');
    content = StringTools.replace(content,"Golang ",'<font color="#357b99">Golang</font> ');
    content = StringTools.replace(content,"Golang.",'<font color="#357b99">Golang</font>.');
    return content;
}

private function execUrl(url:String):Void {
	switch (Sys.systemName()) {
		case "Linux", "BSD":
			Sys.command("xdg-open", [url]);
		case "Mac":
			Sys.command("open", [url]);
		case "Windows":
			Sys.command("start", [url]);
		default:
	}
}