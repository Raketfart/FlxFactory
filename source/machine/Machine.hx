package machine;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import inventory.InventoryItem;

/**
 * ...
 * @author 
 */
class Machine extends Module
{
	var productCounter:Float;
	var lastOutput:Int=0;
	var lamp:FlxSprite;
	var lampCount:Float = 0;
	public var productionSpeed:Float = 1;
	
	public function new(Controller:MachineController,tileX:Int = 0, tileY:Int = 0) 
	{		
		super(Controller,tileX, tileY,3,2);
		productCounter = 0;
		/*
		var base:FlxSprite = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		base.makeGraphic(GC.tileSize*TileWidth, GC.tileSize*TileHeight, FlxColor.GRAY);
		imageLayer.add(base);*/
		var base:FlxSprite = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		base.loadGraphic(AssetPaths.factory__png);
		imageLayer.add(base);
		
		lamp = new FlxSprite(base.x+4, base.y+5);
		lamp.makeGraphic(2, 2, FlxColor.RED);
		imageLayer.add(lamp);
		
		this.connectsOutLeft = true;
		this.connectsOutRight = true;
		this.connectsInLeft = true;
		this.connectsInRight = true;
	}
	override public function update():Void 
	{
		super.update();
		if (inventoryArr.length > 0)
		{
			
			inventoryArr[0].x = lamp.x + 10;
			inventoryArr[0].y = lamp.y + 10;
			productCounter+=productionSpeed;
			if (productCounter > 60)
			{
				//trace("PRODUCT COUNT DONE");
				
				
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
						productCounter = 0;
					} else {
						doMove = false;
						inventoryArr[0].x = lamp.x + 10;
						inventoryArr[0].y = lamp.y + 10;
					}
				}
				lastOutput+= 1;
				
			}
			
		}
		if (lampCount > 0)
		{
			lampCount --;
		} else {
			lampOff();
		}
	}
	override public function addToInventory(item:InventoryItem):Void 
	{
		if (GC.debugdraw == false)
		{
			item.visible = false;
		}
		super.addToInventory(item);
	}
	override public function willAddToInventory(item:InventoryItem):Bool
	{
		if (inventoryArr.length > 0 )
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	public function lampOn():Void
	{
		lampCount = 10;
		lamp.visible = true;
	}
	public function lampOff():Void
	{
		lamp.visible = false;
	}
	
}