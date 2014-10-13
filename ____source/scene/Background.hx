package scene;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import openfl.Assets;

/**
 * ...
 * @author 
 */
class Background extends FlxGroup
{

	public function new() 
	{
		super();
		
		
		var backgroundRepeat1:FlxBackdrop = new FlxBackdrop(Assets.getBitmapData(AssetPaths.background_sky__png), 0, 0, true, false);
		add(backgroundRepeat1);		
		var backgroundRepeat2:FlxBackdrop = new FlxBackdrop(Assets.getBitmapData(AssetPaths.background_clouds__png), .1, .8, true, false);
		add(backgroundRepeat2);
		backgroundRepeat2.y = 130;
		var backgroundRepeat3:FlxBackdrop = new FlxBackdrop(Assets.getBitmapData(AssetPaths.background_mountains__png), .3, .9, true, false);
		add(backgroundRepeat3);
		backgroundRepeat3.y = 120;
		var backgroundRepeat4:FlxBackdrop = new FlxBackdrop(Assets.getBitmapData(AssetPaths.background_grass__png), .5, 1, true, false);
		add(backgroundRepeat4);
		backgroundRepeat4.y = 190;
		
		//black background below backdrop sprites
		var leftoverbgheight =  (50 * GC.tileSize) - (190 + 233);
		var bg:FlxSprite = new FlxSprite(0, 185 + 233);
		bg.makeGraphic(FlxG.width, Std.int(leftoverbgheight), FlxColor.BLACK);
		add(bg);
		bg.scrollFactor.x = 0;
		
	}
	
}