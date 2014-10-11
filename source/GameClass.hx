package;
 
import flash.events.Event;
import flash.Lib;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxCamera;
	
class GameClass extends FlxGame
{
	private var _ratio:Float;
	
	inline static private var GAME_WIDTH:Int = 320;
	inline static private var GAME_HEIGHT:Int = 240;
	
	/**
	 * Sets up our FlxGame class and loads into the MenuState.
	 */
	public function new()
	{
		
		
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		
		var ratioX:Float = stageWidth / GAME_WIDTH;
		var ratioY:Float = stageHeight / GAME_HEIGHT;
		
		_ratio = Math.min(ratioX, ratioY);
		
		var fps:Int = 60;
		
		//super(Math.ceil(stageWidth / _ratio), Math.ceil(stageHeight / _ratio), MenuState, _ratio, fps, fps);
		//super(Math.ceil(stageWidth), Math.ceil(stageHeight), MenuState, _ratio, fps, fps);
		super(Math.ceil(stageWidth), Math.ceil(stageHeight), PlayState, _ratio, fps, fps);
		
		// Center game on screen.
		
		//x = 0.5 * ( stageWidth - GAME_WIDTH * _ratio);
		//y = 0.5 * ( stageHeight - GAME_HEIGHT * _ratio);
		
		
		
	}
	
	/**
	 * Override the base onResize function to center and stretch the game to fit the screen.
	 */
	override public function onResize(_):Void
	{
		// Set the FlxCamera's default zoom to one that will fill the screen but maintain the proper ratio.
		
		FlxCamera.defaultZoom = Math.min( Lib.current.stage.stageWidth / FlxG.width, Lib.current.stage.stageHeight / FlxG.height );
		
		// Set the main camera to the above default zoom, which is achieved by setting to zero.
		// Note that this would not work if we used our own camera, or multiple cameras!
		
		FlxG.camera.zoom = 0;
		
		// Lastly, center the game on the screen.
		trace("resize stagew " + Lib.current.stage.stageWidth);
		trace("resize stagew " + FlxG.width);
		x = ( Lib.current.stage.stageWidth - ( FlxG.width * FlxG.camera.zoom ) ) / 2;
		y = ( Lib.current.stage.stageHeight - ( FlxG.height * FlxG.camera.zoom ) ) / 2;
		
		super.onResize(_);
	}
}