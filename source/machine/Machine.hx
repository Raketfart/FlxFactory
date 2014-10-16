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
	var lamp:FlxSprite;
	var lampCount:Float = 0;
	public var productionSpeed:Float = 1;
	
	public function new(Controller:MachineController,tileX:Int = 0, tileY:Int = 0, TileWidth:Int = 1, TileHeight:Int = 1) 
	{		
		super(Controller,tileX, tileY,TileWidth,TileHeight);
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
		
		this.connectsWest = true;
		this.connectsEast = true;
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
				productCounter = 0;
			
				var item = getFromInventory();
				connections[0].addToInventory(item);
				lampOn();
				
			}
		}
		if (lampCount > 0)
		{
			lampCount --;
		} else {
			lampOff();
		}
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