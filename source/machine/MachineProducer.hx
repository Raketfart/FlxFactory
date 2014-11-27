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
		productionSpeed = 100;
		
		
	}
	
	
	override public function doProcessing():Void
	{
		var ran:Int = FlxRandom.intRanged(0, 5);
		var type:Int = InventoryItem.INV_IRON_RAW; 
		
		/*switch (ran) 
		{
			case 0:					
				type=InventoryItem.INV_IRON_RAW;
			case 1:
				type=InventoryItem.INV_COAL_RAW;
			case 2:
				type=InventoryItem.INV_COPPER_BAR;
			case 3:
				type=InventoryItem.INV_COPPER_CYLINDER;
			case 4:
				type=InventoryItem.INV_CRATE;
			default:
				type=InventoryItem.INV_PART_IRON_HEAD;
		}
		//trace(ran + " t"+type);
		*/
		if (slotOutput.willAccept(type))
		{
			slotOutput.addItem(type);	
			condition -= 1;
		}
		/*
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
			item.y = baseImage.y + 21+7;
			
		}	*/
		super.doProcessing();
	}
	
	
	
	
}