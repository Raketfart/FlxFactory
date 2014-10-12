package machine;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Conveyor extends Module
{
	
	var productCounter:Int;
	public function new(tileX:Int=0, tileY:Int=0) 
	{		
		super(tileX, tileY);
		
		makeGraphic(GC.tileSize,GC.tileSize,FlxColor.BLUE);
		
	}
	override public function update():Void 
	{
		super.update();
		//trace(this.ID + " : inv " + inventoryArr.length);
		
		for (item in inventoryArr) {
			var doMove:Bool = true;
			item.x += 1;
			if (item.x > x + width)
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
		item.x = this.x;
		item.y = this.y;
	}
	
	
}