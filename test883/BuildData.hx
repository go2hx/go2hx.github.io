import sys.io.File;
import haxe.Json;

final tests = [
    "go_easy", "go_medium", "go_hard",
    "yaegi_easy", "yaegi_medium", "yaegi_hard",
    "std_all",
];

final targets = [
    "hl",     // 1
    "jvm",    // 1
    "interp", // 1
    //"cppia", // 2 TODO
    "js",     // 1
    "php",    // 1
];

function main() {
    final results:Dynamic = sys.FileSystem.exists("test883/results.json") ? Json.parse(sys.io.File.getContent("test883/results.json")) : {};
    final time = Date.now().toString();
    var checkedCommit = false;
    Sys.setCwd("go2hx");
    final commit = getCommit();
    for (test in tests) {
        final parts = test.split("_");
        final total = test == "std_all" ? 0 : Json.parse(File.getContent('tests/$test.json')).length;
        for (target in targets) {
            final name = test + "_" + target;
            final subResults:Array<Result> = Reflect.hasField(results, name) ? Reflect.field(results,name) : [];
            var hasSameCommit = -1;
            for (result in subResults) {
                if (result.commit == commit) {
                    hasSameCommit = subResults.indexOf(result);
                    break;
                }
            }
            var data:Result = null;
            if (test != "std_all") {
                final path = 'tests/$name.json';
                final passing= sys.FileSystem.exists(path) ? Json.parse(File.getContent(path)).length : 0;
                //trace(name, passing, total);
                data = {
                    time: time,
                    name: name,
                    commit: commit,
                    passing: passing,
                    total: total,
                };
            }else{
                final stdLogsPath = "tests/stdlogs/";
                for (path in sys.FileSystem.readDirectory(stdLogsPath)) {
                    if (haxe.io.Path.extension(path) != "json")
                        continue;
                    var funcName = haxe.io.Path.withoutDirectory(haxe.io.Path.withoutExtension(path));
                    if (!StringTools.endsWith(funcName, "_" + target))
                        continue;
                    funcName = funcName.substr(0, funcName.length - ("_" + target).length);
                    //trace(name);
                    final data:{passes:Array<String>, runs:Array<String>, fails:Array<String>} = haxe.Json.parse(sys.io.File.getContent(stdLogsPath + path));
                    subResults.push({
                        time: time,
                        name: funcName,
                        commit: commit,
                        passing: data.passes.length,
                        total: data.runs.length,
                    });
                    Reflect.setField(results, name, subResults);
                }
                continue;
            }
            if (hasSameCommit != -1) {
                if (!checkedCommit) {
                    Sys.println("same commit found: " + hasSameCommit);
                    Sys.exit(0);
                }
                checkedCommit = true;
                // testing
                subResults[hasSameCommit] = data;
                //Sys.exit(0);
            }else{
                subResults.push(data);
                Reflect.setField(results, name, subResults);
            }
        }
    }
    Sys.setCwd("..");
    sys.io.File.saveContent("test883/results.json", Json.stringify(results, null, "    "));
}

function getCommit():String {
    var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
	if (process.exitCode() != 0) {
		var message = process.stderr.readAll().toString();
		trace("Cannot execute `git rev-arse HEAD`. " + message);
		return "";
	}
	final version = process.stdout.readLine();
	process.close();
    return version;
}

typedef Result = {
    time:String,
    name:String,
    passing:Int,
    total:Int,
    commit:String,
}


