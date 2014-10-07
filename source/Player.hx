package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import openfl.geom.ColorTransform;

/**
 * ...
 * @author ...
 */
class Player extends FlxSprite
{
	public var speed:Float = 200;

	public function new(X:Float=0, Y:Float=0) 
    {
        super(X, Y);
		//makeGraphic(16, 16, FlxColor.GRAY);
		loadGraphic(AssetPaths.workerTile_19x17__png, true, 19,17);
		
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		animation.add("lr", [2,3], 6, false);
		//animation.add("u", [6, 7, 6, 8], 6, false);
		//animation.add("d", [0, 1, 0, 2], 6, false);
		
		
		drag.x = drag.y = 1600;
	}
	
	override public function update():Void
	{
		
			movement();
			super.update();
	}
	
	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);
		if (_up && _down)
			 _up = _down = false;
		if (_left && _right)
			 _left = _right = false;
			 
		if ( _up || _down || _left || _right)
		{
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
					
				facing = FlxObject.UP;	
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				
				facing = FlxObject.DOWN;	
			}
			else if (_left)
			{
				mA = 180; 
				facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				mA = 0;
				facing = FlxObject.RIGHT;
			}	
			
			FlxAngle.rotatePoint(speed, 0, 0, 0, mA, velocity);
			
			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) // if the player is moving (velocity is not 0 for either axis), we need to change the animation to match their facing
			{
				switch(facing)
				{
					case FlxObject.LEFT, FlxObject.RIGHT:
						animation.play("lr");
					case FlxObject.UP:
						animation.play("lr");
						//animation.play("u");
					case FlxObject.DOWN:
						animation.play("lr");
						//animation.play("d");
				}
			}
		} 
		
	}
	
	public function switchState(stat:Int)
	{
		var ct:ColorTransform = new ColorTransform(.5, 1, 1);
		
		this.colorTransform = ct;
	}
	
}