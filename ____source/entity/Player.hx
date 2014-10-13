package entity ;

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
		loadGraphic(AssetPaths.characterpixel__png, true,21,21);
		
		setSize(11, 18);
		offset.set(5, 2);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);

		animation.add("idle", [0], 6, false);
		animation.add("run", [1, 9, 10], 6, false);
		animation.add("jump", [7,8], 6, false);
		animation.add("jumpdown", [2], 6, false);
		animation.add("duck", [3], 6, false);
		
		
		//drag.x = drag.y = 1600;
		
		drag.x = 640;
		acceleration.y = 420;
		maxVelocity.set(120, 200);
		
	}
	
	override public function update(elapsed:Float):Void
	{
		/*
			movement();*/
			super.update(elapsed);
			
	}
	
	public function updateMovementControls():Void
	{
		// MOVEMENT
		acceleration.x = 0;
		
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			flipX = true;
			acceleration.x -= drag.x;
		}
		else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			flipX = false;
			acceleration.x += drag.x;
		}
		if (FlxG.keys.anyJustPressed(["UP", "W"]) && velocity.y == 0)
		{
			y -= 1;
			velocity.y = -200;
		}
		
		// ANIMATION
		if (velocity.y != 0)
		{
			animation.play("jump");
		}
		else if (velocity.x == 0)
		{
			animation.play("idle");
		}
		else
		{
			animation.play("run");
		}
	}
	
}