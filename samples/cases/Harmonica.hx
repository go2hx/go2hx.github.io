package cases;

import hxd.Key;
import h2d.Text;
import h2d.Graphics;
import harmonica.Harmonica;

class Example extends hxd.App {

	var spring:Spring = null;
	var circle:Graphics = null;

    inline static final radius = 80;
    inline static final multi = 1.0;

    function drawCircle() {
        circle.beginFill(0xFFFFFF);
		circle.drawCircle(0,0,radius, 7);
		circle.endFill();
    }

    override function init() {
        circle = new Graphics(s2d);
        onResize();
		normalSpring();
    }
	var xVelocity = 0.0;
	var yVelocity = 0.0;
	var held = false;
	var forcePull = false;
	var flying = false;
	var maxSpeed = 0.0;

	function normalSpring() {
		spring = Harmonica.newSpring(Harmonica.fPS(60), 6.0 * multi, 0.5 * multi);
	}

	override function update(dt:Float) {
		var window = hxd.Window.getInstance();
		final dis = hxd.Math.distance(Math.abs(circle.x - window.mouseX), Math.abs(circle.y - window.mouseY));

		if (Math.abs(dis) < radius * 4) {
			if (flying && Math.abs(xVelocity) < 600 * multi && Math.abs(yVelocity) < 600 * multi) {
				normalSpring();
				flying = false;
			}
		}

		if (Key.isDown(Key.MOUSE_LEFT)) {
			if (dis < 100) {
				if (!held && !flying) {
					// setup new sprint for being held
					spring = Harmonica.newSpring(Harmonica.fPS(60), 20 * multi, 0.5 * multi);
					forcePull = false;
					held = true;
				}
			}else{
				// force pull
				if (!forcePull && !held) {
					spring = Harmonica.newSpring(Harmonica.fPS(60), 10 * multi, 0.5 * multi);
					forcePull = true;
					held = false;
					flying = false;
				}
			}
		}else{
			if (held && !forcePull) {
				// throw!
				spring = Harmonica.newSpring(Harmonica.fPS(60), 2.8 * multi, 0.2 * multi);
				held = false;
				flying = true;
				xVelocity *= 2;
				yVelocity *= 2;
			}
			if (forcePull) {
				spring = Harmonica.newSpring(Harmonica.fPS(60), 2.8 * multi, 0.2 * multi);
			}
			forcePull = false;
		}
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
		circle.rotation += Math.min(xVelocity, 2_000) / 1000 / 8;
		// skewing
		circle.scaleY = (1 - 0.5 * (Math.min(yVelocity, 2_000) / 4000)) * multi;
		circle.scaleX = (1 + 0.25 * (Math.min(xVelocity, 2_000) / 4000)) * multi;

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
	}
	 // if we the window has been resized
	 override function onResize() {
		if(circle == null) 
			return;
	
		// center our object
		circle.x = Std.int(s2d.width / 2);
		circle.y = Std.int(s2d.height / 2);

        circle.clear();
        drawCircle();
        
	  }
}

function main() {
	final canvas = js.Browser.document.createCanvasElement();
	canvas.id = "webgl";
	canvas.style.setProperty("width", "100%");
	canvas.style.setProperty("height", "100%");
	js.Browser.document.body.append(canvas);

	new Example();
}