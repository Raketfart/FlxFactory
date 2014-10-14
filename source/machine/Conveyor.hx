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
	var graphic:FlxSprite;
	//var base:FlxSprite;
	public function new(Controller:MachineController,tileX:Int=0, tileY:Int=0) 
	{		
		super(Controller,tileX, tileY);
		
		
		/*
		base = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		base.makeGraphic(GC.tileSize, GC.tileSize, FlxColor.BLUE);
		imageLayer.add(base);
		*/
		graphic = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		graphic.loadGraphic(AssetPaths.tiles__png,true,21,21);
		imageLayer.add(graphic);
		
		graphic.animation.add("running", [40,41,42,43,44], 12, true);
		
		graphic.animation.play("running");
		
		this.connectsWest = false;
		this.connectsEast = true;
	}
	override public function update():Void 
	{
		super.update();
		//trace(this.ID + " : inv " + inventoryArr.length);
		
		for (item in inventoryArr) {
			var doMove:Bool = true;
			item.x += .4;
			if (item.x > graphic.x + graphic.width)
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
				item.x -= .4;
			}
		}
	}
	override public function addToInventory(item:InventoryItem):Void 
	{
		super.addToInventory(item);
		item.x = graphic.x;
		item.y = graphic.y;
	}
	
	
}