package machine;

import classes.TileRect;
import flixel.group.FlxGroup;
import flixel.util.FlxRect;
import inventory.InventoryItem;
import classes.TilePos;
import flixel.FlxSprite;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;

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
	public var tileWidth:Int;
	public var tileHeight:Int;
	private var _controller:MachineController;
	public var tileRect:TileRect;
	
	private var imageLayer:FlxGroup;
	private var debugLayer:FlxGroup;
	
	public var connectsEast:Bool;
	public var connectsWest:Bool;
	
		
	public function new(Controller:MachineController, tileX:Int = 0, tileY:Int = 0, TileWidth:Int = 1, TileHeight:Int = 1) 
	{		
		super();
		_controller = Controller;
		tilePos = new TilePos(tileX,tileY);
		
		
		tileWidth = TileWidth;
		tileHeight = TileHeight;
		
		idcounter++;
		this.ID = idcounter;
		
		connections = new Array<Module>();
		inventoryArr = new Array<InventoryItem>();
		
		tileRect = new TileRect(tileX, tileY, TileWidth, TileHeight);
		
		imageLayer = new FlxGroup();
		add(imageLayer);
		debugLayer = new FlxGroup();
		add(debugLayer);
		
	}
	public function willAddToInventory(item:InventoryItem):Bool
	{
		return true;
	}	
	public function addToInventory(item:InventoryItem):Void 
	{
		inventoryArr.push(item);				
	}
	public function getFromInventory():InventoryItem 
	{
		if (inventoryArr.length > 0) 
		{
			return inventoryArr.shift();
		}
		return null;
	}
	
	public function refreshConnections():Void
	{
		debugClear();
		connections = new Array<Module>();
		if (connectsEast)
		{
			refreshConnectionsEast();
		}
		if (connectsWest)
		{
			refreshConnectionsWest();
		}
	}
	
	public function refreshConnectionsEast():Void 
	{				
		var thisTileX:Int = tilePos.tileX;
		var connTileX:Int = thisTileX +tileWidth;		
		for (iy in 0...tileHeight) {			
			var module:Module = _controller.getModuleAt(connTileX, (tilePos.tileY + iy));
			if (module != null)
			{
				
				connections.push(module);
				debugDraw( ((connTileX - 1) * GC.tileSize) + 16 , ((tilePos.tileY + iy) * GC.tileSize) + 9 );				
			}
		}		
	}
	public function refreshConnectionsWest():Void 
	{
		var thisTileX:Int = tilePos.tileX;
		var connTileX:Int = thisTileX -1;
		for (iy in 0...tileHeight) {
			var module:Module = _controller.getModuleAt(connTileX, (tilePos.tileY + iy));
			if (module != null)
			{
				connections.push(module);
				debugDraw( ((thisTileX) * GC.tileSize) + 4 , ((tilePos.tileY + iy) * GC.tileSize) + 9 );
			}
		}	
	}
	private function debugClear()
	{
		remove(debugLayer);
		debugLayer = null;
		debugLayer = new FlxGroup();
		add(debugLayer);
	}
	private function debugDraw(drawX,drawY)
	{
		var dot:FlxSprite = new FlxSprite(drawX, drawY);
		dot.makeGraphic(4, 4, FlxColor.GOLDEN);
		debugLayer.add(dot);
	}
	
}