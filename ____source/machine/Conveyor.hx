package machine;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import inventory.InventoryItem;

/**
 * ...
 * @author 
 */
class Conveyor extends Module
{
	
	var productCounter:Int;
	var base:FlxSprite;
	public function new(tileX:Int=0, tileY:Int=0) 
	{		
		super(tileX, tileY);
		
		
		
		base = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		base.makeGraphic(GC.tileSize, GC.tileSize, FlxColor.BLUE);
		add(base);
		
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		//trace(this.ID + " : inv " + inventoryArr.length);
		
		for (item in inventoryArr) {
			var doMove:Bool = true;
			item.x += 1;
			if (item.x > base.x + base.width)
			{				
				if (connections.length > 0)
				{
					for (otheritem in connections[0].inventoryArr)
					{
						if (item.overlaps(otheritem))
						{
							doMove = false;
						}
					}
					if (doMove)
					{
						var item = getFromInventory();
						connections[0].addToInventory(item);
					}
				} else {
					doMove = false;
				}
				
			} else {
				for (otheritem in inventoryArr)
				{
					if (item != otheritem)
					{
						if (item.overlaps(otheritem))
						{
							doMove = false;
						}
					}
				}
				if (connections.length > 0)
				{
					for (otheritem in connections[0].inventoryArr)
					{
						if (item.overlaps(otheritem))
						{
							doMove = false;
						}
					}
				}
				
				
			}
			if (!doMove)
			{
				item.x -= 1;
			}
		}
	}
	override public function addToInventory(item:InventoryItem):Void 
	{
		super.addToInventory(item);
		item.x = base.x;
		item.y = base.y;
	}
	
	
}