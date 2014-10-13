package ;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.util.FlxColor;
import flixel.util.FlxRect;
import flixel.util.FlxSpriteUtil;

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
		
		camZoom = 1;
		
		camfollowBounds = new FlxRect(100, 280, 500, 400);
		camfollowBoundsBorder = new FlxSprite();
		add(camfollowBoundsBorder);
		drawCamFollowBounds();
		
		camfollow = new FlxSprite(camfollowBounds.left, camfollowBounds.top);
		camfollow.makeGraphic(2, 2, FlxColor.BLUE);
		add(camfollow);
		
		
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
		FlxG.scaleMode = new FixedScaleMode();
		trace("w1 " + FlxG.worldBounds.toString());
		
		if (camZoom == 1)
		{
			camZoom = 2;
			FlxG.camera.zoom = camZoom;
			FlxG.camera.setSize(500, 300);
			
			camfollowBounds = new FlxRect(50, 120, 600, 500);
			drawCamFollowBounds();
			restrictCamFollow();
			
			FlxG.camera.follow(_state.player, FlxCamera.STYLE_PLATFORMER, 1);
		}
		else {
			//trace("zoom out");
			camZoom = 1;
			FlxG.camera.zoom = camZoom;
			FlxG.camera.setSize(1000, 600);
			
			camfollowBounds = new FlxRect(100, 280, 500, 400);
			drawCamFollowBounds();
			restrictCamFollow();
			
			FlxG.camera.follow(camfollow, FlxCamera.STYLE_NO_DEAD_ZONE,1);
		}
		trace("w2 " + FlxG.worldBounds.toString());
		
		//FlxG.camera.setBounds(-500, -500, 2000, 1500, true);
		//FlxG.camera.follow(camfollow, FlxCamera.STYLE_NO_DEAD_ZONE,1);
			
	}
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