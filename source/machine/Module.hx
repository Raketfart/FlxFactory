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
	public var controller:MachineController;
	public var tileRect:TileRect;
	
	private var imageLayer:FlxGroup;
	private var debugLayer:FlxGroup;
	
	public var connectsOutRight:Bool = false;
	public var connectsOutLeft:Bool = false;
	public var connectsOutUp:Bool = false;
	public var connectsOutDown:Bool = false;
	public var connectsInRight:Bool = false;
	public var connectsInLeft:Bool = false;	
	public var connectsInUp:Bool = false;
	public var connectsInDown:Bool = false;
	
		
	public function new(Controller:MachineController, tileX:Int = 0, tileY:Int = 0, TileWidth:Int = 1, TileHeight:Int = 1) 
	{		
		super();
		controller = Controller;
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
		if (connectsOutRight)
		{
			refreshConnectionsRight();
		}
		if (connectsOutLeft)
		{
			refreshConnectionsLeft();
		}
		if (connectsOutUp)
		{
			refreshConnectionsUp();
		}
	}
	
	public function refreshConnectionsRight():Void 
	{				
		var thisTileX:Int = tilePos.tileX;
		var connTileX:Int = thisTileX +tileWidth;		
		for (iy in 0...tileHeight) {			
			var module:Module = controller.getModuleAt(connTileX, (tilePos.tileY + iy));
			if (module != null)
			{
				if (module.connectsInLeft && this.connectsOutRight)
				{
					connections.push(module);
					debugDraw( ((connTileX - 1) * GC.tileSize) + 16 , ((tilePos.tileY + iy) * GC.tileSize) + 9 );				
				}
			}
		}		
	}
	public function refreshConnectionsLeft():Void 
	{
		var thisTileX:Int = tilePos.tileX;
		var connTileX:Int = thisTileX -1;
		for (iy in 0...tileHeight) {
			var module:Module = controller.getModuleAt(connTileX, (tilePos.tileY + iy));
			if (module != null)
			{
				if (module.connectsInRight && this.connectsOutLeft)
				{
					connections.push(module);
					debugDraw( ((thisTileX) * GC.tileSize) + 4 , ((tilePos.tileY + iy) * GC.tileSize) + 9 );
				}
			}
		}	
	}
	public function refreshConnectionsUp():Void 
	{
		var thisTileY:Int = tilePos.tileY;
		var connTileY:Int = thisTileY -1;
		for (ix in 0...tileWidth) {
			var module:Module = controller.getModuleAt((tilePos.tileX + ix), connTileY );
			if (module != null)
			{
				if (module.connectsInDown && this.connectsOutUp)
				{
					connections.push(module);
					debugDraw( ((tilePos.tileX+ix) * GC.tileSize) + 9 , (tilePos.tileY * GC.tileSize) + 4 );
				}
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
		if (GC.debugdraw)
		{
			var dot:FlxSprite = new FlxSprite(drawX, drawY);
			dot.makeGraphic(4, 4, FlxColor.GOLDEN);
			debugLayer.add(dot);
		}
		
	}
	
}