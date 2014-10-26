package ;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
import machine.*;
import inventory.InventoryItem;
import scene.TileType;
/**
 * ...
 * @author 
 */
class MachineController extends FlxGroup
{
	public var moduleGrp:FlxGroup;
	public var inventoryGrp:FlxGroup;	
	public var moduleArr:Array<Module>;
	private var leftTile:Int = 4;
	private var topTile:Int = 13;
	
	public function new() 
	{
		super();
		
		moduleArr = new Array<Module>();
		moduleGrp = new FlxGroup();
		add(moduleGrp);
		inventoryGrp = new FlxGroup();
		add(inventoryGrp);
		
	}
	
	public function setupTestMachines():Void
	{
		//DIGGER
		var mod:Module = new MachineProducer(this,leftTile+18, topTile);
		moduleGrp.add(mod);
		moduleArr.push(mod);
		var mod3:Module = new ConveyorRight(this,leftTile+20, topTile+1);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var mod3:Module = new ConveyorRight(this,leftTile+21, topTile+1);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var mod3:Module = new ConveyorRight(this,leftTile+22, topTile+1);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var mod:Module = new MachineProcessor(this,leftTile+23, topTile);
		moduleGrp.add(mod);
		moduleArr.push(mod);
		var mod3:Module = new ConveyorRight(this,leftTile+26, topTile+1);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var modup:Module = new ConveyorUp(this,leftTile+27, topTile+1);
		moduleGrp.add(modup);
		moduleArr.push(modup);
		var modup:Module = new ConveyorUp(this,leftTile+27, topTile);
		moduleGrp.add(modup);
		moduleArr.push(modup);
		var modup:Module = new ConveyorUp(this,leftTile+27, topTile-1);
		moduleGrp.add(modup);
		moduleArr.push(modup);
		
		//Reg machine
		var mod:Module = new MachineProcessor(this,leftTile, topTile);
		moduleGrp.add(mod);
		moduleArr.push(mod);
		
		var mod4:Machine = new MachineProcessor(this,leftTile+8, topTile);
		moduleGrp.add(mod4);
		moduleArr.push(mod4);
		mod4.productionSpeed = 10;
		
		var mod2:Module = new ConveyorRight(this,leftTile+3, topTile+1);
		moduleGrp.add(mod2);
		moduleArr.push(mod2);

		var mod3:Module = new ConveyorRight(this,leftTile+4, topTile+1);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var mod3:Module = new ConveyorRight(this,leftTile+5, topTile+1);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var mod3:Module = new ConveyorRight(this,leftTile+6, topTile+1);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var mod3:Module = new ConveyorRight(this,leftTile+7, topTile+1);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var mod3:Module = new ConveyorLeft(this,leftTile+7, topTile);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var mod3:Module = new ConveyorLeft(this,leftTile+6, topTile);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var mod3:Module = new ConveyorLeft(this,leftTile+5, topTile);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var mod3:Module = new ConveyorLeft(this,leftTile+4, topTile);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		var mod3:Module = new ConveyorLeft(this,leftTile+3, topTile);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		
		leftTile = leftTile +12;
		if (leftTile > 50)
		{
			leftTile = 10;
			topTile += 4;
		}
		//mod2.connections.push(mod3);
		
		//loading module types
		//var loadedMod:Module = Type.createInstance(Type.resolveClass("machine.Machine"), [this,50,13]);
		//moduleGrp.add(loadedMod);
		//moduleArr.push(loadedMod);
		

		
		for (m in moduleArr)
		{
			m.refreshConnections();
		}
		
	}
	public function setupMoreCrates():Void
	{
		for (m in moduleArr)
		{
			if (Std.is(m, Machine))
			{
				var crate:InventoryItem = new InventoryItem();
				inventoryGrp.add(crate);
				m.addToInventory(crate);							
			}
		}
	}
	/*
	public function addCrate()
	{
		var crate:InventoryItem = new InventoryItem();
		inventoryGrp.add(crate);
		moduleArr[0].addToInventory(crate);
		
		
	}
	*/
	public function addConvE()
	{
		var mod:Module = new ConveyorRight(this,Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
		moduleGrp.add(mod);
		moduleArr.push(mod);
		
		for (m in moduleArr)
		{
			m.refreshConnections();
		}
		
	}
	public function addConvW()
	{
		var mod:Module = new ConveyorLeft(this,Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
		moduleGrp.add(mod);
		moduleArr.push(mod);
		
		for (m in moduleArr)
		{
			m.refreshConnections();
		}
		
	}
	public function addConvU()
	{
		var mod:Module = new ConveyorUp(this,Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
		moduleGrp.add(mod);
		moduleArr.push(mod);
		
		for (m in moduleArr)
		{
			m.refreshConnections();
		}
		
	}
	public function addConvD()
	{
		var mod:Module = new ConveyorDown(this,Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
		moduleGrp.add(mod);
		moduleArr.push(mod);
		
		for (m in moduleArr)
		{
			m.refreshConnections();
		}
		
	}
	public function canAddModule(width:Int, height:Int ,collMap:FlxTilemap):Bool
	{
		var startX:Int = Std.int(FlxG.mouse.x / GC.tileSize);
		var startY:Int = Std.int(FlxG.mouse.y / GC.tileSize);
		for (iy in startY...(startY + height))
		{
			for (ix in startX...(startX + width))
			{
				var tiletype:Int = collMap.getTile(ix, iy);				
				
				var m:Module = getModuleAt(ix,iy);
				if (m != null || tiletype != TileType.TYPE_EMPTY)
				{
					return false;
				}
			}
		}
		return true;
	}
	public function addMachine():Void
	{
		var mod:Module = new MachineProcessor(this,Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
		moduleGrp.add(mod);
		moduleArr.push(mod);
		
		for (m in moduleArr)
		{
			m.refreshConnections();
		}
		
	}
	public function getModuleAt(TileX:Int,TileY:Int):Module
	{
		for (m in moduleArr)
		{
			if (m.tileRect.containsTile(TileX, TileY))
			{
				//trace("m contains " + TileX + "x" + TileY);
				return m;
			}
		}
		return null;
	}
	
	public function addCrateToModule():Void
	{
		var module:Module = getModuleAt(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
		if (module != null)
		{
			var crate:InventoryItem = new InventoryItem();
			inventoryGrp.add(crate);
			module.addToInventory(crate);
			/*
			if (Std.is(module, Machine))
			{
				var machine:Machine = cast module;
				machine.turnOn();
			}
			*/
		}
	}
	
	public function removeModule():Void
	{
		var m:Module = getModuleAt(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
		moduleArr.remove(m);
		m.destroy();
		for (m in moduleArr)
		{
			m.refreshConnections();
		}
	}
}