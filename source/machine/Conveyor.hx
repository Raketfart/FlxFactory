package machine;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
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
		
		graphic = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		graphic.loadGraphic(AssetPaths.tiles_item__png,true,21,21);
		imageLayer.add(graphic);
		
		graphic.animation.add("running", [40,41,42,43,44], 12, true);
		graphic.animation.play("running");
		
		graphic.setFacingFlip(FlxObject.LEFT, true, false);
		graphic.setFacingFlip(FlxObject.RIGHT, false, false);
		graphic.facing = FlxObject.RIGHT;
		
		moveDirectionX = 1;			
			this.connectsOutLeft = false;
			this.connectsOutRight = true;		
			this.connectsInLeft = true;
			this.connectsInRight = false;	
		
		this.connectsInDown = true;
		this.connectsInUp = true;
		
	}
	public function setDirectionX(direction:Int)
	{
		if (direction == 1) //right
		{
			moveDirectionX = 1;			
			this.connectsOutLeft = false;
			this.connectsOutRight = true;		
			this.connectsInLeft = true;
			this.connectsInRight = false;
			graphic.facing = FlxObject.RIGHT;
			
		} else {
			moveDirectionX = -1;			
			this.connectsOutLeft = true;
			this.connectsOutRight = false;		
			this.connectsInLeft = false;
			this.connectsInRight = true;	
			graphic.facing = FlxObject.LEFT;
			
		}
		moveDirectionY = 0;
		//this.connectsInDown = false;
		//this.connectsInUp = false;
	}
	override public function update():Void 
	{
		super.update();
		//trace(this.ID + " : inv " + inventoryArr.length);
		
		var targetOut:Float;		
		if (moveDirectionX == 1)
		{	//right
			targetOut = graphic.x + graphic.width;
		}
		else
		{	//left
			targetOut = graphic.x;
		}
		
		for (item in inventoryArr) {
			var doMove:Bool = true;
			var orgX:Float = item.x;
			var orgY:Float = item.y;
		
			
			if (item.x != targetOut)			
			{
				moveItem(item, FlxG.elapsed, targetOut, 0);					
			}
			
			if (item.x == targetOut) // move to next module
			{				
				if (connections.length > 0)
				{
					if (doesItemOverlap(item, connections[0].inventoryArr))
					{
						doMove = false;						
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
				if (doesItemOverlap(item, inventoryArr))
				{
					doMove = false;					
				}	
				
				if (connections.length > 0)
				{
					if (doesItemOverlap(item, inventoryArr))
					{
						doMove = false;					
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