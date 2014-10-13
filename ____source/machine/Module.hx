package machine;

import flixel.group.FlxGroup;
import inventory.InventoryItem;
import util.TilePos;
import flixel.FlxSprite;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

/**
 * ...
 * @author 
 */
class Module extends FlxGroup
{
	public var tilePos:TilePos;
	public var connections:Array<Module>;
	public var inventoryArr:Array<InventoryItem>;		
	public static var idcounter:Int = 0;
	
	public function new(tileX:Int=0, tileY:Int=0) 
	{		
		super();
		tilePos = new TilePos(tileX,tileY);
		
		idcounter++;
		this.ID = idcounter;
		
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