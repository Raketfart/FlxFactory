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
		for (item in inventoryArr) {
			
			var nextX:Float = item.x + .1;
			if (nextX-item.width > x + width)
			{
				if (connections.length > 0)
				{
					var item = getFromInventory();
					connections[0].addToInventory(item);
				} 
				
			} else {
				item.x = nextX;
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