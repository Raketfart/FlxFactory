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
			var item:InventoryItem = new InventoryItem(InventoryItem.INV_IRON_RAW);
			this.controller.inventoryGrp.add(item);
			this.addToInventory(item);
			
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