package machine;

import classes.TilePos;
import flixel.FlxSprite;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class Module extends FlxSprite
{
	public var tilePos:TilePos;
	public var connections:Array<Module>;
	public var inventoryArr:Array<InventoryItem>;		
	public static var idcounter:Int = 0;
	
	public function new(tileX:Int=0, tileY:Int=0) 
	{		
		super(tileX*GC.tileSize, tileY*GC.tileSize);
		tilePos = new TilePos(tileX,tileY);
		
		idcounter++;
		this.ID = idcounter;
		immovable = true;
		
		connections = new Array<Module>();
		inventoryArr = new Array<InventoryItem>();
	}
	
	public function addToInventory(item:InventoryItem):Void 
	{
		inventoryArr.push(item);
		//crate.tilePos = this.tilePos;
		
		//crate.hasMoved = true;
		
	}
	public function getFromInventory():InventoryItem 
	{
		if (inventoryArr.length > 0) 
		{
			return inventoryArr.shift();
		}
		return null;
	}
	
	
}