#if js
import haxe.Json;
import haxe.Resource;
import js.Browser.document;
import js.Browser;
import js.Syntax;
import js.html.Console;
import js.html.Headers;

function main() {
	var results:Array<Result> = Json.parse(Resource.getString("results"));
	document.body.style.overflow = "hidden";

	results.sort((a, b) -> {
		return b.time > a.time ? 1 : 0;
	});

	var sets:Map<String, Dynamic> = [];
	var i = 0;
	var colors = ["#19db6e", "#1d60df", "#8e24aa", "#ff7043"];
	for (result in results) {
		if (!sets.exists(result.name)) {
			sets[result.name] = {
				label: result.name,
				data: [],
				fill: false,
				tension: 0.2,
				borderColor: colors[i++],
			};
		}
		sets[result.name].data.push({
			x: js.lib.Date.fromHaxeDate(Date.fromString(result.time)),
			y: (result.passing / result.total) * 100,
			total: result.total,
		});
	}
	var data = {
		datasets: [for (set in sets.iterator()) set],
	};
	final delay = 1200;
	final delayBetweenPoints = delay / results.length;
	var options = {
		type: 'scatter',
		stacked: false,
		pointRadius: 10,
		pointHoverRadius: 14,
		interaction: {
			intersect: false,
			mode: 'index',
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
		animation: {
			duration: 0,
			x: {
				duration: delayBetweenPoints,
				easing: 'easeInSine',
				from: Syntax.code("NaN"),
				delay: (ctx) -> ctx.index * delayBetweenPoints,
			},
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
			}
		}
	};
	Console.log(data);
	Syntax.code("
        var ctx = document.getElementById('chart');
        var chart = new Chart(ctx,{
            type: 'line',
            data: {0},
            options: {1},
        });
    ", data, options);
}

typedef Result = {
	time:String,
	name:String,
	passing:Int,
	total:Int,
	commit:String,
}
#end
