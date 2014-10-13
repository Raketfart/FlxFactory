package machine;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Machine extends Module
{
	var productCounter:Int;
	var lamp:FlxSprite;
	var lampCount:Int = 0;
	
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
		add(base);
		
		lamp = new FlxSprite(base.x+4, base.y+5);
		lamp.makeGraphic(2, 2, FlxColor.RED);
		imageLayer.add(lamp);
		
		this.connectsWest = true;
		this.connectsEast = true;
	}
	override public function update():Void 
	{
		super.update();
		productCounter++;
		if (productCounter > 60)
		{
			//trace("PRODUCT COUNT DONE");
			productCounter = 0;
			if (inventoryArr.length > 0)
			{
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