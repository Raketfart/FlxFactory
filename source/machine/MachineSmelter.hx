package machine;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import machinewindow.MachineWindow;
import inventory.InventoryItem;
import machine.machinestates.BootUp;
import machine.machinestates.PowerOff;
import util.FlxFSM;

/**
 * ...
 * @author 
 */
class MachineSmelter extends Machine
{
	
	public function new(Controller:MachineController,tileX:Int = 0, tileY:Int = 0) 
	{		
		super(Controller,tileX, tileY,3,2);
		/*
		var base:FlxSprite = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		base.loadGraphic(AssetPaths.factory__png);
		imageLayer.add(base);
		*/
		baseImage.loadGraphic(AssetPaths.factory__png);
		var flames:FlxSprite = new FlxSprite(tileX * GC.tileSize+16, tileY * GC.tileSize+13);
		flames.loadGraphic(AssetPaths.factoryFlames__png, true, 30, 15);
		flames.animation.add("idle", [0], 1, false);
		flames.animation.add("flames", [1,2], 4, true);		
		imageLayer.add(flames);
		flames.animation.play("flames");
		
		
	}
	
	
	
}