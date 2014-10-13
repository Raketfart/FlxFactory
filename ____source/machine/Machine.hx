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
	
	public function new(tileX:Int=0, tileY:Int=0) 
	{		
		super(tileX, tileY);
		productCounter = 0;
		
		var base:FlxSprite = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		base.makeGraphic(GC.tileSize, GC.tileSize, FlxColor.BLUE);
		add(base);
		
		lamp = new FlxSprite(base.x+4, base.y+5);
		lamp.makeGraphic(2, 2, FlxColor.RED);
		add(lamp);
		
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
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