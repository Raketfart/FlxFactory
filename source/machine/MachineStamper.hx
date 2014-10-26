package machine;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import hud.MachineWindow;
import inventory.InventoryItem;
import machine.machinestates.BootUp;
import machine.machinestates.PowerOff;
import util.FlxFSM;

/**
 * ...
 * @author 
 */
class MachineStamper extends Machine
{
	var stamper:FlxSprite;
	private var tween:FlxTween;
	
	public function new(Controller:MachineController,tileX:Int = 0, tileY:Int = 0) 
	{		
		
		super(Controller,tileX, tileY,3,2);
		stamper = new FlxSprite(tileX*GC.tileSize+17, tileY*GC.tileSize+13);
		stamper.loadGraphic(AssetPaths.factoryStamper_2__png);
		imageBackLayer.add(stamper);
		/*
		var base:FlxSprite = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		base.loadGraphic(AssetPaths.factory__png);
		imageLayer.add(base);
		*/
		baseImage.loadGraphic(AssetPaths.factoryStamper_1__png);
		
		
		
		tween = FlxTween.tween(stamper, {  y:stamper.y-12 }, .5, { ease: FlxEase.expoOut, complete: stampDown} );
	}
	
	public function stampDown(tween:FlxTween ):Void
	{
		tween = FlxTween.tween(stamper, {  y:stamper.y+12 }, .5, { ease: FlxEase.expoOut, complete: stampUp} );
	}
	public function stampUp(tween:FlxTween ):Void 
	{
		tween = FlxTween.tween(stamper, {  y:stamper.y-12 }, .5, { startDelay: .2, ease: FlxEase.expoOut, complete: stampDown} );
	}
}