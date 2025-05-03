package;

import haxe.Template;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

var header:String = "";
var support:String = "";
var supportBuildInfo:String = "";
var supportLastUpdated:String = "";
var go:String = "";

var exportPath = "page/"; // add trailing backslash at end

function main() {
    header = File.getContent("_content/header.html");
    var path = "go2hx/stdgo/README.md";
    final stdList:Array<String> = haxe.Json.parse(File.getContent("go2hx/tests/std.json"));
    final targets = ["hl","interp","js"];
    final lines = ["| module | " + targets.concat(["info"]).join(" | ") + " |"];
    var spacer = "|";
    for (i in 0...targets.length + 2) {
        spacer += " --- |";
    }
    lines.push(spacer);
    var allTests:Array<String> = haxe.Json.parse(File.getContent("go2hx/data/tests.json"));
    allTests = allTests.filter(test -> test.indexOf("internal") == -1);
    allTests.sort((a, b) -> a > b ? 1 : -1); 
    for (i in 0...allTests.length) {
        lines[i + 2] = allTests[i] + " |";
    }
    //trace(lines.join("\n"));
    for (target in targets) {
        final path = 'go2hx/tests/std_$target.json';
        final data:Array<String> = haxe.Json.parse(File.getContent(path)).map(s -> s.split("|")[1]);
        //trace(target, data);
        for (i in 0...allTests.length) {
            final test = StringTools.replace(allTests[i], "/", "_");
            final link = 'https://github.com/go2hx/go2hx/blob/master/tests/stdlogs/${test}_$target.log'; 
            if (data.indexOf(allTests[i]) != -1) {
                lines[i + 2] += ' ✅ |';
            }else{

                if (FileSystem.exists('go2hx/tests/stdlogs/${test}_$target.json')) {
                    final data = haxe.Json.parse(File.getContent('go2hx/tests/stdlogs/${test}_$target.json'));
                    final pass = data.passes.length;
                    final total = data.runs.length;
                    if (pass > 1 && total > 0) {
                        //final graphLink = 'test883/index.html#${test}_$target';
                        lines[i + 2] += ' [❌ log]($link) $pass/$total|';
                        continue;
                    }
                }
                final pass = 0;
                final total = 0;
                final graphLink = 'test883/index.html#${test}_$target';
                lines[i + 2] += ' [❌ error]($link)|';
            }
        }
    }
    // add info section
    for (i in 0...allTests.length) {
        lines[i + 2] += '[imports](https://pkg.go.dev/${allTests[i]}?tab=imports)|';
    }
    supportBuildInfo = readmeToHtmlLink(Markdown.markdownToHtml(buildInfo()), false);
    supportLastUpdated = readmeToHtmlLink(Markdown.markdownToHtml(lastUpdated()), false);
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
        if (path == "_internal" || path == "internal")
            continue;
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
                content = StringTools.replace(content,"[\\(view file containing code\\)](<.","[\\(view file containing code\\)](<" + fullpath);
                content = prettyprint(Markdown.markdownToHtml(content));
                // open new tab for code preview
                content = StringTools.replace(content,">(view code)</a>",'target="_blank" rel="noopener noreferrer">(view code)</a>');
                content = StringTools.replace(content,">(view file containing code)</a>",'target="_blank" rel="noopener noreferrer">(view file containing code)</a>');
                //trace(path);
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
    content = temp.execute({support: support, buildInfo: supportBuildInfo, lastUpdated: supportLastUpdated}); // index.md template
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

#if macro
macro function buildInfo():haxe.macro.Expr {
    Sys.setCwd("go2hx");
    var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
    Sys.setCwd("..");
	if (process.exitCode() != 0) {
		var message = process.stderr.readAll().toString();
		throw "Cannot execute `git rev-arse HEAD` " + message;
	}
	final version = process.stdout.readLine();
    final str = "*commit: [" + version.substr(0,7) + '](https://github.com/go2hx/go2hx/commit/$version)*';
    return macro $v{str};
}
#else
macro function buildInfo():haxe.macro.Expr;
#end

#if macro
macro function lastUpdated():haxe.macro.Expr {
   final str = "*last updated: " + Date.now().toString() + "*";
   return macro $v{str};
}
#else
macro function lastUpdated():haxe.macro.Expr;
#end