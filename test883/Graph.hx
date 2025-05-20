#if js
import js.html.LabelElement;
import js.html.CanvasElement;
import js.html.SelectElement;
import haxe.Json;
import haxe.Resource;
import js.Browser.document;
import js.Browser;
import js.Syntax;
import js.html.Console;
import js.html.Headers;

function main() {
    final build:LabelElement = cast Browser.document.getElementById("build");
    //Browser.alert(buildInfo());
    build.innerText = "last updated: " + buildInfo();
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
			y: result.passing,
			total: result.total,
            commit: result.commit,
            passes: result.passing,
		});
	}
	var data = {
		datasets: [for (set in sets.iterator()) set],
	};
	final delay = 1200;
	final delayBetweenPoints = delay / results.length;
	var options = {
        responsive: true,
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
            zoom: {
                zoom: {
                  mode: "x",
                  wheel: {
                    enabled: true,
                  },
                },
                pan: {
                  enabled: true,
                  mode: "x",
                },
              },
			tooltip: {
                //enabled: false,
				callbacks: {
					title: item -> (item[0].raw.x : js.lib.Date).toUTCString(),
					/*footer: item -> "passing: " + [
						for (obj in (item : Array<Dynamic>))
							Math.round((obj.parsed.y * obj.raw.total) / 100)
					],*/
                    label: item -> item.dataset.label + ":" + item.raw.passes + "/" + item.raw.total,
				}
			},
			legend: {
                onClick: (e, legendItem, legend) -> {
                    var index = legendItem.datasetIndex;
                    var ci:Dynamic = legend.chart;
                    var meta = ci.getDatasetMeta(index);
                    var othersHidden = false;
                    var selectedHidden = ci.data.datasets[index].hidden;
                    (ci.data.datasets : Dynamic).forEach(function(dataset, i) {
                        if (i != index && dataset.hidden) {
                            othersHidden = true;
                        }
                    });
                    (ci.data.datasets : Dynamic).forEach(function(dataset:Dynamic, i) {
                        if (othersHidden) {
                            if (selectedHidden) {
                                dataset.hidden = i != index;
                            }else{
                                dataset.hidden = false;
                            }
                        }else{
                            dataset.hidden = i != index;
                        }
                    });
                    ci.update();
                },
				labels: {
					font: {
						//size: 26,
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
            ticks: {
                font: {
                    //size: 20,
                }
            }
        },
        y: {
            // the data maximum used for determining the ticks is Math.max(dataMax, suggestedMax)
            /*ticks: {
                callback: (value, index, values) -> '$value',
                font: {
                    //size: 20,
                }
            },*/
        },
    }
	};
    var ctx:CanvasElement = null;
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
        {3} = ctx;
    ", data, options, chart, ctx);
    //Console.log(chart);
    ctx.onclick = e -> {
        final points = chart.getElementsAtEventForMode(e, 'nearest', { intersect: true }, true);
        if (points.length == 0)
            return;
        final firstPoint = points[0];
        final label = chart.data.labels[firstPoint.index];
        final value = chart.data.datasets[firstPoint.datasetIndex].data[firstPoint.index];
        Browser.window.open("https://github.com/go2hx/go2hx/commit/" + value.commit, "_blank");
    }
}

var chart:Dynamic = null;

typedef Result = {
	time:String,
	name:String,
	passing:Int,
	total:Int,
	commit:String,
}
#end

#if macro
macro function buildInfo():haxe.macro.Expr {
    final str = Date.now().toString();
    return macro $v{str};
}
#else
macro function buildInfo():haxe.macro.Expr;
#end