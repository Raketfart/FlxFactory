package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
using flixel.util.FlxSpriteUtil;
import flixel.util.FlxDestroyUtil;
/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	var _btnPlay:FlxButton;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//FlxG.camera.zoom = 2;
		FlxG.scaleMode = new FixedScaleMode();
		//FlxG.camera.zoom = 1;
		_btnPlay = new FlxButton(0, 0, "Play", clickPlay);
		add(_btnPlay);
		
		_btnPlay.screenCenter();
		
		super.create();
		
		FlxG.switchState(new PlayState());
	}
	
	private function clickPlay():Void
	{
		FlxG.switchState(new PlayState());
	}
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
		_btnPlay = FlxDestroyUtil.destroy(_btnPlay);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			
			FlxG.switchState(new PlayState());
		}
		super.update();
	}	
}