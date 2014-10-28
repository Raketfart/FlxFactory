package hud;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

/**
 * ...
 * @author Simon Larsen
 */

class Ding extends FlxGroup
{
	private var _startX:Float;
	private var _startY:Float;
	private var txt:FlxText;
	
	public function new(X:Float, Y:Float, text:String) 
	{
		
		super();
		
		txt = new FlxText(X, Y, 100, text);
		add(txt);
		txt.velocity.y = -90;
	}
	override public function update():Void
	{
		txt.velocity.y += 2;
		if (txt.velocity.y > 40) {
			this.kill();
		}
		super.update();
	}
	
}