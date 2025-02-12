package cases;

import hxd.Key;
import h2d.Text;
import h2d.Graphics;
import github_dot_com.charmbracelet.harmonica.Harmonica;
//import github_dot_com.lucasb_dash_eyer._godash_colorful.T__godash_colorful;

class App extends hxd.App {

	var spring:Spring = null;
	var circle:Graphics = null;

	var fps:Text = null;

	var radius = 50 * 2;

    override function init() {
		fps = new Text(hxd.res.DefaultFont.get(), s2d);
		fps.scaleX = fps.scaleY = 3;
        circle = new Graphics(s2d);
		circle.beginFill(0xFFFFFF);
		circle.drawCircle(0,0,radius, 7);
		trace(s2d.width);
		trace(s2d.height);
		circle.endFill();
		//circle.smooth = true;

		normal();

		
    }
	var xVelocity = 0.0;
	var yVelocity = 0.0;
	var held = false;
	var forcePull = false;
	var flying = false;
	var maxSpeed = 0.0;

	function normal() {
		spring = Harmonica.newSpring(Harmonica.fPS(60), 6.0, 0.5);
	}

	function jitter() {
		circle.x += -10 + Std.random(20);
		circle.y += -10 + Std.random(20);
	}

	override function update(dt:Float) {
		fps.text = "fps: " + Math.ceil(Math.min(engine.fps, 60));
		var window = hxd.Window.getInstance();
		if (!window.isFocused) {
			xVelocity = 0;
			yVelocity = 0;
			return;
		}
		final dis = hxd.Math.distance(Math.abs(circle.x - window.mouseX), Math.abs(circle.y - window.mouseY));

		if (Math.abs(dis) < radius * 4) {
			if (flying && Math.abs(xVelocity) < 600 && Math.abs(yVelocity) < 600) {
				normal();
				flying = false;
			}
		}

		if (Key.isDown(Key.MOUSE_LEFT)) {
			if (dis < 100) {
				if (!held && !flying) {
					// setup new sprint for being held
					spring = Harmonica.newSpring(Harmonica.fPS(60), 20, 0.5);
					forcePull = false;
					held = true;
				}
			}else{
				// force pull
				if (!forcePull && !held) {
					spring = Harmonica.newSpring(Harmonica.fPS(60), 10, 0.5);
					forcePull = true;
					held = false;
					flying = false;
				}
			}
		}else{
			if (held && !forcePull) {
				// throw!
				spring = Harmonica.newSpring(Harmonica.fPS(60), 2.8, 0.2);
				held = false;
				flying = true;
				xVelocity *= 2;
				yVelocity *= 2;
			}
			if (forcePull) {
				spring = Harmonica.newSpring(Harmonica.fPS(60), 2.8, 0.2);
			}
			forcePull = false;
		}
		//if (forcePull)
		//	fps.text += "\nhold to force pull!";
		if (held) {
			fps.text += "\nrelease to throw!";
		}
		fps.text += "\n max speed: " + Std.int(maxSpeed);
		if (maxSpeed < Math.abs(xVelocity))
			maxSpeed = Math.abs(xVelocity);
		if (maxSpeed < Math.abs(yVelocity))
			maxSpeed = Math.abs(yVelocity);
		
		final data = spring.update(circle.x, xVelocity, window.mouseX);
		// tuple (x,velocityX)
		circle.x = data.left;
		xVelocity = data.right;
		final data = spring.update(circle.y, yVelocity, window.mouseY);
		// tuple (y,velocityY)
		circle.y = data.left;
		yVelocity = data.right;
		// rotate when xVelocity changes
		circle.rotation += xVelocity / 1000 / 8;
		// skewing
		circle.scaleY = 1 - 0.5 * (Math.min(yVelocity, 2_000) / 4000);
		circle.scaleX = 1 + 0.25 * (Math.min(xVelocity, 2_000) / 4000);

		// make it so that the circle is always on screen
		if (circle.x > window.width + radius * 2) {
			circle.x = -radius * 2;
			//xVelocity *= 1.2;
		}
		if (circle.x < -radius * 2) {
			circle.x = window.width + radius * 2;
			//xVelocity *= 1.2;
		}
		if (circle.y > window.height + radius * 2) {
			circle.y = -radius * 2;
			//yVelocity *= 1.2;
		}
		if (circle.y < -radius * 2) {
			circle.y = window.height + radius * 2;
			//yVelocity *= 1.2;
		}
		// add a jitter effect to make it seem like it's radioactive
		if (flying && !held && !forcePull)
			jitter();
		// kill velocity if too high
		/*if (Math.abs(xVelocity) > 50_000) {
			xVelocity *= 0.7;
		}
		if (Math.abs(yVelocity) > 50_000) {
			yVelocity *= 0.7;
		}*/
	}
	 // if we the window has been resized
	 override function onResize() {
		if(circle == null) 
			return;
	
		// center our object
		circle.x = Std.int(s2d.width / 2);
		circle.y = Std.int(s2d.height / 2);
	  }
}

function main() {
	final canvas = js.Browser.document.createCanvasElement();
	canvas.id = "webgl";
	canvas.style.setProperty("width", "100%");
	canvas.style.setProperty("height", "100%");
	js.Browser.document.body.appendChild(canvas);
	new App();
}