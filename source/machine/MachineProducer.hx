package machine;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxRandom;
import machinewindow.MachineWindow;
import inventory.InventoryItem;

/**
 * ...
 * @author 
 */
class MachineProducer extends Machine
{
	
	public function new(Controller:MachineController,tileX:Int = 0, tileY:Int = 0) 
	{	
		
		super(Controller,tileX, tileY,2,2);
		
		baseImage.loadGraphic(AssetPaths.factoryDrill__png);
		productionSpeed = 10000;
		
		
	}
	
	
	override public function doProcessing():Void
	{
		if (inventoryArr.length <= 0)
		{
			var item:InventoryItem;
			var ran:Int = FlxRandom.intRanged(0, 5);
			switch (ran) 
			{
				case 0:					
					item = new InventoryItem(InventoryItem.INV_IRON_RAW);
				case 1:
					item = new InventoryItem(InventoryItem.INV_COAL_RAW);
				case 2:
					item = new InventoryItem(InventoryItem.INV_COPPER_BAR);
				case 3:
					item = new InventoryItem(InventoryItem.INV_COPPER_CYLINDER);
				case 4:
					item = new InventoryItem(InventoryItem.INV_CRATE);
				default:
					item = new InventoryItem(InventoryItem.INV_PART_IRON_HEAD);
			}
			
			this.controller.inventoryGrp.add(item);
			this.addToOutput(item);
			
			item.x = baseImage.x + 21;
			item.y = baseImage.y + 21;
			
		}	
		super.doProcessing();
	}
	override public function doTransform(item:InventoryItem)
	{
		//dont transform
	}
	
	
	
}