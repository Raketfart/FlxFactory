package hud;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Simon Larsen
 */

class Ding extends FlxGroup
{
	private var _startX:Float;
	private var _startY:Float;
	private var txt:FlxText;
	private var speedY:Float;
	
	public function new(X:Float, Y:Float, text:String, doScroll:Bool = true) 
	{
		
		super();
		
		txt = new FlxText(X, Y, 100, text);
		add(txt);
		speedY = -200;
		if (doScroll == false)
		{
			txt.scrollFactor.set(0,0);
		}
	}
	override public function update():Void
	{
		var dt:Float = FlxG.elapsed;
		
		txt.y += speedY * dt;
		
		speedY *= .90;
				
		if (speedY > -20) {
			this.kill();
		}
		super.update();
	}
	
}