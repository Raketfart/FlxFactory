package machine;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import inventory.InventoryItem;

/**
 * ...
 * @author 
 */
class ConveyorLeft extends Module
{
	
	var productCounter:Int;
	var graphic:FlxSprite;
	//var base:FlxSprite;
	public function new(Controller:MachineController,tileX:Int=0, tileY:Int=0) 
	{		
		super(Controller,tileX, tileY);
		
		graphic = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		graphic.loadGraphic(AssetPaths.tiles__png,true,21,21);
		imageLayer.add(graphic);
		
		graphic.animation.add("running", [40,41,42,43,44], 12, true);
		
		graphic.animation.play("running");
		
		graphic.setFacingFlip(FlxObject.LEFT, true, false);
		graphic.facing = FlxObject.LEFT;
		
		this.connectsOutLeft = true;
		this.connectsOutRight = false;
		
		this.connectsInLeft = false;
		this.connectsInRight = true;
		
		this.connectsInDown = true;
		
	}
	override public function update():Void 
	{
		super.update();
		//trace(this.ID + " : inv " + inventoryArr.length);
		
		for (item in inventoryArr) {
			var doMove:Bool = true;
			var orgX:Float = item.x;
			var orgY:Float = item.y;
		
			if (item.y > this.graphic.y )
			{
				item.y -= .4;
			} else {
				item.x -= .4;
			}
			if (item.x < graphic.x) // move to next module
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
					if (doMove && connections[0].willAddToInventory(item))
					{
						var item = getFromInventory();
						connections[0].addToInventory(item);
					} else {
						doMove = false;
					}
				} else {
					doMove = false;
				}
				
			} else { // move in this module
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
				item.y = orgY;
				item.x = orgX;
			}
		}
	}
	override public function addToInventory(item:InventoryItem):Void 
	{
		super.addToInventory(item);
		if (GC.debugdraw)
		{
			item.color = FlxColor.BLUE;
		}
		//item.x = graphic.x+graphic.width;
		//item.y = graphic.y;
	}
	
	
}