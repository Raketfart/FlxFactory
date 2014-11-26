package machine;
import crafting.Recipe;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import machinewindow.MachineWindow;
import inventory.InventoryItem;

/**
 * ...
 * @author 
 */
class MachineProcessor extends Machine
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
		
		currentRecipe = new Recipe();
		currentRecipe.inputType1 = InventoryItem.INV_IRON_CYLINDER;		
		currentRecipe.inputAmount1 = 2;
		currentRecipe.inputType2 = InventoryItem.INV_IRON_BAR;
		currentRecipe.inputAmount2 = 1;
		currentRecipe.outputType = InventoryItem.INV_PART_IRON_BODY;
		currentRecipe.outputAmount = 1;
	}
	
	
	
}