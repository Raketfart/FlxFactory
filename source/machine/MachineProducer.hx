package machine;
import flixel.FlxG;
import flixel.FlxSprite;
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
class MachineProducer extends Machine
{
	
	public function new(Controller:MachineController,tileX:Int = 0, tileY:Int = 0) 
	{	
		
		super(Controller,tileX, tileY,2,2);
		
		baseImage.loadGraphic(AssetPaths.factoryDrill__png);
		
		
		this.connectsOutLeft = true;
		this.connectsOutRight = true;
		this.connectsInLeft = false;
		this.connectsInRight = false;
		
	}
	
	
	override public function doProcessing():Void
	{
		if (inventoryArr.length <= 0)
		{
			var crate:InventoryItem = new InventoryItem();
			this.controller.inventoryGrp.add(crate);
			this.addToInventory(crate);
		}	
		if (inventoryArr.length > 0)
		{
			
			inventoryArr[0].x = lampOutput.x + 10;
			inventoryArr[0].y = lampOutput.y + 10;
			
			currentProductionCompletion += productionSpeed * FlxG.elapsed;
			//trace("compl " + currentProductionCompletion);
			if (currentProductionCompletion > 100)
			{
				
				var doMove:Bool = true;
				
				if (lastOutput >= connections.length)
				{
					lastOutput = 0;
				}
				
				if (connections.length > 0)
				{
					inventoryArr[0].x = connections[lastOutput].tilePos.tileX * GC.tileSize;
					inventoryArr[0].y = connections[lastOutput].tilePos.tileY * GC.tileSize;
					
					for (otheritem in connections[lastOutput].inventoryArr)
					{
						if (inventoryArr[0].overlaps(otheritem))
						{
							doMove = false;
						}
					}
					
					if (doMove && connections[lastOutput].willAddToInventory(inventoryArr[0]))
					{
						
						var item = getFromInventory();
						item.visible = true;
						connections[lastOutput].addToInventory(item);
						lampOn();
						currentProductionCompletion = 0;
					} else {
						doMove = false;
						inventoryArr[0].x = lampOutput.x + 10;
						inventoryArr[0].y = lampOutput.y + 10;
					}
				}
				lastOutput+= 1;
				
			}
			
		}
		if (lampOutputCount > 0)
		{
			lampOutputCount --;
		} else {
			lampOff();
		}
	}
	
	
	
	
}