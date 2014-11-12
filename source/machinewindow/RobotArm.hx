package machinewindow;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author 
 */
class RobotArm extends FlxGroup
{
	var robobase:FlxSprite;
	var roboarm1:FlxSprite;
	var roboarm2:FlxSprite;
	var roboarm3:FlxSprite;
	var robofinger1:FlxSprite;
	var robofinger2:FlxSprite;
	
	public var roboTarget:FlxSprite;
	
	var fingerMin:Float = 2;
	var fingerMax:Float = 10;
	
	var baseYMin:Float = 39;
	var baseYMax:Float = 112;
	
	public var targetObject:FlxSprite;
	
	
	
	public function new(_elements:FlxTypedGroup<FlxSprite>) 
	{
		super();
		
		targetObject = null;
		
		robobase = new FlxSprite(193, 90);
		robobase.loadGraphic(AssetPaths.robotarm__png, false, 40, 29);
		robobase.animation.frameIndex = 3;
		_elements.add(robobase);
		
		roboarm1 = new FlxSprite(robobase.x-0, 90);
		roboarm1.loadGraphic(AssetPaths.robotarm__png, false, 40, 29);
		roboarm1.animation.frameIndex = 0;
		_elements.add(roboarm1);
		roboarm2 = new FlxSprite(robobase.x+10, 90);
		roboarm2.loadGraphic(AssetPaths.robotarm__png, false, 40, 29);
		roboarm2.animation.frameIndex = 1;
		_elements.add(roboarm2);		
		roboarm3 = new FlxSprite(robobase.x+20, 90);
		roboarm3.loadGraphic(AssetPaths.robotarm__png, false, 40, 29);
		roboarm3.animation.frameIndex = 2;
		_elements.add(roboarm3);
		
		
		robofinger1 = new FlxSprite(robobase.x-11, 94);
		robofinger1.loadGraphic(AssetPaths.robotarm_finger__png, false, 17, 3);
		robofinger1.animation.frameIndex = 0;
		_elements.add(robofinger1);
		
		robofinger2 = new FlxSprite(robobase.x-11, 113);
		robofinger2.loadGraphic(AssetPaths.robotarm_finger__png, false, 17, 3);
		robofinger2.animation.frameIndex = 1;
		_elements.add(robofinger2);
		
		roboTarget = new FlxSprite(robobase.x-8, 105);
		roboTarget.loadGraphic(AssetPaths.particles__png, false, 4, 4);
		roboTarget.animation.frameIndex = 7;
		roboTarget.visible = false;
		
		_elements.add(roboTarget);
		
		
	}
	public function doOpen(targetAmount:Float):Bool
	{
		//trace("yes"+(robofinger1.y-roboarm1.y));
		if (robofinger1.y-roboarm1.y > targetAmount)
		{
			onOpen();
			
			return false;
		} else {
			
			return true;
		}
	}
	public function doClose(targetAmount:Float):Bool
	{
		
		if (robofinger1.y-roboarm1.y < targetAmount)
		{
			onClose();
			return false;
		} else {
			return true;
		}
	}
	public function doPickup(object:FlxSprite):Void
	{
		targetObject = object;
	}
	public function doMove(targetPoint:FlxPoint):Bool
	{
		var onTargetX:Bool = false;
		var onTargetY:Bool = false;
		if (roboTarget.x < targetPoint.x +1 && roboTarget.x > targetPoint.x -1)
		{
			onTargetX = true;
		} 
		else 
		{				
			if (roboTarget.x > targetPoint.x)
			{
				onArrowLeft();
			} else if (roboTarget.x < targetPoint.x)
			{
				onArrowRight();
			} 	
		}
		if (roboTarget.y < targetPoint.y +1 && roboTarget.y > targetPoint.y -1)
		{
			onTargetY = true;
		} 
		else 
		{
				
			if (roboTarget.y > targetPoint.y)
			{
				onArrowUp();
			} else if (roboTarget.y < targetPoint.y)
			{
				onArrowDown();
			} 	
		}
		return (onTargetX == true && onTargetY == true);
	}
	
	public function onArrowRight() 
	{	
		//trace("r1 " +(robobase.x-roboarm1.x));
		if (robobase.x - roboarm1.x > -18)
		{
			robofinger1.x += 1;
			robofinger2.x += 1;
			roboarm1.x += 1;
			roboTarget.x += 1;
			if (targetObject != null)
			{
				targetObject.x += 1;
			}
			roboarm2.x += .5;		
			roboarm3.x += .2;	
				
			if (roboarm2.x - roboarm1.x < 8)
			{
				roboarm2.x = roboarm1.x + 8;				
			}
			if (roboarm3.x - roboarm2.x < 5)
			{
				roboarm3.x = roboarm2.x + 5;				
			}
		}
	}
	
	
	public function onArrowLeft() 
	{
		
		if (robobase.x - roboarm1.x < 80)
		{
			robofinger1.x -= 1;
			robofinger2.x -= 1;
			roboarm1.x -= 1;
			roboTarget.x -= 1;
			if (targetObject != null)
			{
				targetObject.x -= 1;
			}
			//trace("pos " + roboTarget.x + " x " + roboTarget.y);
			roboarm2.x -= .5;		
			roboarm3.x -= .2;				
			
			if (roboarm2.x - roboarm1.x > 40)
			{
				roboarm2.x = roboarm1.x + 40;				
			}
			if (roboarm3.x - roboarm2.x > 40)
			{
				roboarm3.x = roboarm2.x + 40;				
			}
		}
	}
	
	public function onArrowUp() 
	{
		if (robobase.y > baseYMin)
		{
			robofinger1.y -= 1;
			robofinger2.y -= 1;
			roboarm1.y -= 1;
			roboTarget.y -= 1;
			roboarm2.y -= 1;
			roboarm3.y -= 1;
			robobase.y -= 1;
			if (targetObject != null)
			{
				targetObject.y -= 1;
			}	
			
		}
	}
	public function onArrowDown() 
	{
		if (robobase.y < baseYMax)
		{
			robofinger1.y += 1;
			robofinger2.y += 1;
			roboarm1.y += 1;
			roboTarget.y += 1;
			roboarm2.y += 1;
			roboarm3.y += 1;
			robobase.y += 1;
			if (targetObject != null)
			{
				targetObject.y += 1;
			}	
		
		}
	}
	public function onOpen() 
	{
		//trace((robofinger1.y-roboarm1.y)  + ":" +fingerMin);
		if (robofinger1.y-roboarm1.y > fingerMin)
		{
			robofinger1.y -= .2;
			robofinger2.y += .2;
		}
	}
	public function onClose() 
	{
		//trace((robofinger1.y-roboarm1.y)  + ":" +fingerMax);
		if (robofinger1.y-roboarm1.y < fingerMax)
		{
			robofinger1.y += .2;
			robofinger2.y -= .2;
		}
	}
	
	
	
}