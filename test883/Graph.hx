import js.html.SelectElement;
#if js
import haxe.Json;
import haxe.Resource;
import js.Browser.document;
import js.Browser;
import js.Syntax;
import js.html.Console;
import js.html.Headers;

function main() {
    final test:SelectElement = cast Browser.document.getElementById("test");
    final target:SelectElement = cast Browser.document.getElementById("target");
    test.onchange = () -> {
        run(test.value, target.value);
    };
    target.onchange = () -> {
        run(test.value, target.value);
    }
    run(test.value, target.value);
}

function run(test:String, target:String) {
    if (chart != null) {
        chart.clear();
        chart.destroy();
        chart = null;
    }
    var results:Array<Result> = Reflect.field(Json.parse(Resource.getString("results")), test + "_" + target);
	document.body.style.overflow = "hidden";

	results.sort((a, b) -> {
		return b.time > a.time ? 1 : 0;
	});

	var sets:Map<String, Dynamic> = [];
	var i = 0;
	//var colors = ["#19db6e", "#1d60df", "#8e24aa", "#ff7043"];
	for (result in results) {
		if (!sets.exists(result.name)) {
			sets[result.name] = {
				label: result.name,
				data: [],
				fill: false,
				tension: 0.2,
				//borderColor: colors[i++],
			};
		}
        trace(result.passing, result.total);
		sets[result.name].data.push({
			x: js.lib.Date.fromHaxeDate(Date.fromString(result.time)),
			y: (result.passing / result.total) * 100,
			total: result.total,
            commit: result.commit,
		});
	}
	var data = {
		datasets: [for (set in sets.iterator()) set],
	};
	final delay = 1200;
	final delayBetweenPoints = delay / results.length;
	var options = {
        tooltips: {
            mode: "index",
            intersect: false,
            bodyAlign: "right",
            bodyFontFamily: "Courier"
        },
        hover: {
            mode: "nearest",
            intersect: true
        },
        plugins: {
			tooltip: {
				callbacks: {
					title: item -> (item[0].raw.x : js.lib.Date).toUTCString(),
					footer: item -> "passing: " + [
						for (obj in (item : Array<Dynamic>))
							Math.round((obj.parsed.y * obj.raw.total) / 100)
					],
				}
			},
			legend: {
				labels: {
					font: {
						size: 26,
					}
				}
			}
		},
    scales: {
        x: {
            type: 'timeseries',
            time: {
                unit: "day",
            },
        },
        y: {
            type: 'logarithmic',
            max: 100,
            ticks: {
                callback: (value, index, values) -> '$value%',
            },
        },
    }
	};
	Syntax.code("
        var ctx = document.getElementById('chart');
        var chart = new Chart(ctx,{
            type: 'line',
            responsive: true,
            animation: {
                duration: 0
            },
            data: {0},
            options: {1},
        });
        {2} = chart;
    ", data, options, chart);
}

var chart = null;

typedef Result = {
	time:String,
	name:String,
	passing:Int,
	total:Int,
	commit:String,
}
#end