package machinewindow ;
import flixel.addons.ui.FlxButtonPlus;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.system.layer.frames.FlxFrame;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import hud.FlipButton;
import hud.HUD;
import hud.HUDTypedText;
import machine.Machine;

/**
 * ...
 * @author 
 */
class MachineWindowProcessor extends MachineWindow
{
	var robotArm:RobotArm;
	var roboHead:FlxSprite;
	var roboEye:FlxSprite;
	
	var robotOrders:Array<RobotOrder>;
	var robotWelder:FlxSprite;
	var _emitterSmokeWhite:FlxEmitter;
	var _whitePixel:FlxParticle;
	var _emitterSparks:FlxEmitter;
	
	
	public function new(hud:HUD,machine:Machine) 
	{
		
		super(hud,machine);
		
		var arrowsX = 150;
		var arrowsY = bg1.height - 80;
		createbutton(arrowsX, arrowsY+20, "", AssetPaths.btn_arrow_left__png, onArrowLeft);	
		createbutton(arrowsX+20, arrowsY, "", AssetPaths.btn_arrow_up__png, onArrowUp);	
		createbutton(arrowsX+40, arrowsY+20, "", AssetPaths.btn_arrow_right__png, onArrowRight);	
		createbutton(arrowsX+20, arrowsY+20, "", AssetPaths.btn_arrow_down__png, onArrowDown);	
		
		bg1.loadGraphic(AssetPaths.mwin_bg_hole__png, false);	
		
		
		
		tweenIn();
		
		robotOrders = new Array<RobotOrder>();
		
		
	}
	override public function initBackgroundElements() 
	{
		var screenbg2:FlxSprite = new FlxSprite(20, 10);
		screenbg2.loadGraphic(AssetPaths.mwin_screenextralarge__png, false);		
		_elements.add(screenbg2);
		
		roboHead = new FlxSprite(80,50);
		roboHead.loadGraphic(AssetPaths.parts_head__png, false);
		_elements.add(roboHead);
		
		roboEye = new FlxSprite(150,30);
		roboEye.loadGraphic(AssetPaths.parts_eye__png, false);
		_elements.add(roboEye);
		
		robotArm = new RobotArm(_elements);
		
		robotWelder = new FlxSprite(60,74);
		robotWelder.loadGraphic(AssetPaths.robotarm_welder__png, false);
		_elements.add(robotWelder);
		
		_emitterSmokeWhite = new FlxEmitter(40, 40, 100);
		
		_emitterSmokeWhite.setXSpeed( -40, 40);
		_emitterSmokeWhite.setYSpeed( -10, -100);
		_emitterSmokeWhite.width = 4;
		_emitterSmokeWhite.height= 4;
		
		_emitterSmokeWhite.bounce = 0.1;
		_emitterSmokeWhite.gravity = -100;
		add(_emitterSmokeWhite);
		
		for (i in 0...(Std.int(_emitterSmokeWhite.maxSize / 2))) 
		{			
			_whitePixel = new FlxParticle();
			_whitePixel.scrollFactor.x = _whitePixel.scrollFactor.y = 0;
			_whitePixel.loadGraphic(AssetPaths.particles__png, false, 4, 4);
			_whitePixel.animation.add("d", [5], 1, false);
			_whitePixel.animation.play("d");
			_whitePixel.visible = false; 
			_whitePixel.acceleration.y = 10; 		
			_whitePixel.acceleration.x = -100; 		
			_emitterSmokeWhite.add(_whitePixel);	
			_whitePixel = new FlxParticle();
			_whitePixel.scrollFactor.x = _whitePixel.scrollFactor.y = 0;
			_whitePixel.loadGraphic(AssetPaths.particles__png, false, 4, 4);
			_whitePixel.animation.add("d", [6], 1, false);
			_whitePixel.animation.play("d");
			_whitePixel.visible = false;
			_emitterSmokeWhite.add(_whitePixel);
		}
		
		_emitterSparks = new FlxEmitter(40, 40, 100);		
		_emitterSparks.setXSpeed( -100, 100);
		_emitterSparks.setYSpeed( -100, 100);
		_emitterSparks.width = 4;
		_emitterSparks.height= 4;		
		_emitterSparks.bounce = 0.1;
		_emitterSparks.gravity = 50;
		add(_emitterSparks);
		
		for (i in 0...(Std.int(_emitterSparks.maxSize / 2))) 
		{			
			_whitePixel = new FlxParticle();
			_whitePixel.scrollFactor.x = _whitePixel.scrollFactor.y = 0;
			_whitePixel.loadGraphic(AssetPaths.particles__png, false, 4, 4);
			_whitePixel.animation.frameIndex = 10;
			_whitePixel.visible = false; 
			_whitePixel.acceleration.y = 10; 		
			_whitePixel.acceleration.x = -100; 		
			_emitterSparks.add(_whitePixel);	
			_whitePixel = new FlxParticle();
			_whitePixel.scrollFactor.x = _whitePixel.scrollFactor.y = 0;
			_whitePixel.loadGraphic(AssetPaths.particles__png, false, 4, 4);
			_whitePixel.animation.frameIndex = 9;
			_whitePixel.visible = false;
			_emitterSparks.add(_whitePixel);
		}
	}
	override public function update():Void
	{
		super.update();
		
		
		if (robotOrders.length > 0)
		{
			//trace(robotOrders[0]);
			if (robotOrders[0].ordertype == "move")
			{
				var onTarget:Bool = robotArm.doMove(robotOrders[0].targetPos);
				if (onTarget)
				{
					robotOrders.splice(0, 1);
				}
			} 
			else if (robotOrders[0].ordertype == "open")
			{
				var onTarget:Bool = robotArm.doOpen(robotOrders[0].amount);
				if (onTarget)
				{
					robotOrders.splice(0, 1);
				}
			}
			else if (robotOrders[0].ordertype == "close")
			{
				var onTarget:Bool = robotArm.doClose(robotOrders[0].amount);
				if (onTarget)
				{
					robotOrders.splice(0, 1);
				}
			}
			else if (robotOrders[0].ordertype == "pickup")
			{
				robotArm.doPickup(roboEye);
				robotOrders.splice(0, 1);
				
			}
		}
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			onArrowLeft();
		}
		else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			onArrowRight();
		}
		if (FlxG.keys.anyPressed(["UP", "W"]) )
		{
			onArrowUp();
		}
		if (FlxG.keys.anyPressed(["DOWN", "S"]) )
		{
			onArrowDown();
		}
		if (FlxG.keys.anyPressed(["E"]) )
		{
			robotArm.onOpen();
		}
		if (FlxG.keys.anyPressed(["C"]) )
		{
			robotArm.onClose();
		}
		if (FlxG.keys.anyPressed(["X"]) )
		{
			robotWelder.x +=1;
		}
		if (FlxG.keys.anyPressed(["Z"]) )
		{
			robotWelder.x -=1;
		}
		if (FlxG.keys.anyJustPressed(["B"]) )
		{
			_emitterSmokeWhite.x = robotWelder.x+8;
			_emitterSmokeWhite.y = robotWelder.y-2;
			_emitterSmokeWhite.start(false, 0.3, 0.02, 60, 0.4);
			_emitterSparks.x = robotWelder.x+8;
			_emitterSparks.y = robotWelder.y-2;
			_emitterSparks.start(false, 0.3, 0.05,25,0.4);
		}
		if (FlxG.keys.anyJustPressed(["R"]))
		{
			
			robotOrders.push(new RobotOrder("move", new FlxPoint(robotArm.roboTarget.x+20, robotArm.roboTarget.y),0));
			robotOrders.push(new RobotOrder("move", new FlxPoint(roboEye.x+(roboEye.width/2)+20, robotArm.roboTarget.y),0));
			robotOrders.push(new RobotOrder("move", new FlxPoint(roboEye.x+(roboEye.width/2)+20, roboEye.y+(roboEye.height/2)),0));
			robotOrders.push(new RobotOrder("open", null,2));
			robotOrders.push(new RobotOrder("move", new FlxPoint(roboEye.x+(roboEye.width/2), roboEye.y+(roboEye.height/2)),0));
			robotOrders.push(new RobotOrder("close", null,5));
			robotOrders.push(new RobotOrder("pickup"));
			robotOrders.push(new RobotOrder("move", new FlxPoint(roboEye.x+(roboEye.width/2)+20, roboEye.y+(roboEye.height/2)),0));
			robotOrders.push(new RobotOrder("move", new FlxPoint(roboEye.x+(roboEye.width/2)+20, 95),0));
			robotOrders.push(new RobotOrder("move", new FlxPoint(170, 95),0));
			
		}
	}
	function onArrowRight() 
	{
		robotArm.onArrowRight();
	}
	
	function onArrowUp() 
	{
		robotArm.onArrowUp();		
	}
	
	function onArrowLeft() 
	{
		robotArm.onArrowLeft();
	}	
	function onArrowDown() 
	{
		robotArm.onArrowDown();
	}
	
	
}