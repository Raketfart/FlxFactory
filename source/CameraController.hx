package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.scaleModes.StageSizeScaleMode;
import flixel.util.FlxColor;
import flixel.util.FlxRect;
import flixel.util.FlxSpriteUtil;
import openfl.display.BlendMode;

/**
 * ...
 * @author 
 */
class CameraController extends FlxGroup
{
	var _state:PlayState;
	
	
	public var camZoom:Int;
	public var camfollow:FlxSprite;
	public var camfollowBounds:FlxRect;
	var camfollowBoundsBorder:FlxSprite;
	
	
	
	public function new(State:PlayState) 
	{
		super();
		
		_state = State;
		
		camfollowBounds = new FlxRect(300, 280, FlxG.worldBounds.width-600, FlxG.worldBounds.height-300);
		camfollowBoundsBorder = new FlxSprite();
		add(camfollowBoundsBorder);
		drawCamFollowBounds();
		
		camfollow = new FlxSprite(camfollowBounds.left, camfollowBounds.top);
		camfollow.makeGraphic(2, 2, FlxColor.BLUE);
		add(camfollow);
		
		camfollow.visible = false;
		camfollowBoundsBorder.visible = false;
		
		
		
		switchCam();
		
	}
	
	override public function update():Void 
	{
		FlxG.camera.scroll.x = camfollow.x-(FlxG.width/2)/camZoom;
		FlxG.camera.scroll.y = camfollow.y-(FlxG.height/2)/camZoom;
		if (camZoom == 2)
		{
			camfollow.x = _state.player.x;
			camfollow.y = _state.player.y;
		}
	}
	
	private function drawCamFollowBounds():Void
	{		
		camfollowBoundsBorder.x = camfollowBounds.left;
		camfollowBoundsBorder.y = camfollowBounds.top;
		camfollowBoundsBorder.makeGraphic(Std.int(camfollowBounds.width), Std.int(camfollowBounds.height), FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(camfollowBoundsBorder, 0, 0, camfollowBounds.width - 1, camfollowBounds.height - 1, FlxColor.TRANSPARENT, { thickness: 1, color: FlxColor.RED } );		
	}
	
	public function updateCameraControls():Void
	{
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			if (camfollow.x > camfollowBounds.left)
			{
				camfollow.x -= 10;
			}
		}
		else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			if (camfollow.x < camfollowBounds.left+camfollowBounds.width)
			{
				camfollow.x += 10;
			}
		}
		if (FlxG.keys.anyPressed(["UP", "W"]) )
		{
			if (camfollow.y > camfollowBounds.top)
			{
				camfollow.y -= 10;
			}
		}
		if (FlxG.keys.anyPressed(["DOWN", "S"]) )
		{
			if (camfollow.y < camfollowBounds.top+camfollowBounds.height)
			{
				camfollow.y += 10;
			}
		}
	}
	public function switchCam()
	{
		FlxG.scaleMode = new StageSizeScaleMode();
		FlxG.cameras.reset();
		
		if (camZoom == 1)
		{
			camZoom = 2;
			//FlxG.camera.width = 500;
			//FlxG.camera.height = 300;
			FlxG.camera.zoom = 2;
			//FlxG.camera.follow(_state.player, FlxCamera.STYLE_PLATFORMER, null, 0);
			
		} else {
			//FlxG.camera.width = 1000;
			//FlxG.camera.height = 600;
			camZoom = 1;
			FlxG.camera.zoom = 1;
			//FlxG.camera.follow(camfollow, FlxCamera.STYLE_LOCKON, null, 0);
			//camfollowBounds = new FlxRect(300, 280, FlxG.worldBounds.width-600, FlxG.worldBounds.height-300);
			restrictCamFollow();
		}
	}
	/*
	public function switchCam_old()
	{
		FlxG.scaleMode = new FixedScaleMode();
		//trace("w1 " + FlxG.worldBounds.toString());
		
		if (camZoom == 1)
		{
			camZoom = 2;
			FlxG.camera.zoom = camZoom;
			//FlxCamera.defaultZoom = camZoom;
			//FlxG.camera.setSize(500, 300);
			//FlxG.camera.zoom = 0;
			//FlxG.cameras.reset();
			FlxG.camera.zoom = 2;
			FlxG.camera.width = 500;
			FlxG.camera.height = 300;
			FlxG.camera.follow(_state.player, FlxCamera.STYLE_PLATFORMER, null, 0);
			
			camfollowBounds = new FlxRect(50, 120, 600, 500);
			drawCamFollowBounds();
			restrictCamFollow();
			
			//FlxG.camera.follow(_state.player, FlxCamera.STYLE_PLATFORMER, 1);
		}
		else {
			
			//trace("zoom out");
			camZoom = 1;
			
			FlxCamera.defaultZoom = camZoom;
			FlxG.camera.zoom = 0;
			FlxG.cameras.reset();
			FlxG.camera.setSize(1000, 600);
			
			//FlxG.camera.zoom = camZoom;
			
			//FlxG.camera.bounds = new FlxRect(0, 0, 1000, 600);
			//FlxG.cameras.reset();
			
			camfollowBounds = new FlxRect(100, 280, 500, 400);
			drawCamFollowBounds();
			restrictCamFollow();
			
			FlxG.camera.follow(camfollow, FlxCamera.STYLE_NO_DEAD_ZONE,1);
			
			
			camZoom = 1;
			//FlxG.camera.follow(camfollow, FlxCamera.STYLE_NO_DEAD_ZONE, 1);
			FlxG.camera.zoom = 1;
			//FlxG.camera.width = Std.int(FlxG.camera.width *2);
			//FlxG.camera.height = Std.int(FlxG.camera.height *2);
			FlxG.camera.follow(camfollow, FlxCamera.STYLE_LOCKON, null, 0);
			
			camfollowBounds = new FlxRect(100, 280, 500, 400);
			drawCamFollowBounds();
			restrictCamFollow();
			trace("zoom out does not work");
			
		}
		//trace("w2 " + FlxG.worldBounds.toString());
		//trace("w2 " + FlxG.width);
		
		//FlxG.camera.setBounds(-500, -500, 2000, 1500, true);
		//FlxG.camera.follow(camfollow, FlxCamera.STYLE_NO_DEAD_ZONE,1);
			
	}*/
	
	private function restrictCamFollow()
	{
		if (camfollow.x < camfollowBounds.left)
			{
				
				camfollow.x = camfollowBounds.left;
			} 
			else if (camfollow.x > camfollowBounds.left+camfollowBounds.width)
			{
				
				camfollow.x = camfollowBounds.left+camfollowBounds.width;
			}
			if (camfollow.y < camfollowBounds.top)
			{
				
				camfollow.y = camfollowBounds.top;
			} 
			else if (camfollow.y > camfollowBounds.top+camfollowBounds.height)
			{
				
				camfollow.y = camfollowBounds.top+camfollowBounds.height;
			}
	}
	
	
}