package ;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxRect;
import machine.*;
import inventory.InventoryItem;
/**
 * ...
 * @author 
 */
class MachineController extends FlxGroup
{
	public var moduleGrp:FlxGroup;
	public var inventoryGrp:FlxGroup;	
	public var moduleArr:Array<Module>;

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
		
		
		var mod:Module = new Machine(this,25, 13,3,2);
		moduleGrp.add(mod);
		moduleArr.push(mod);
		
		var mod2:Module = new ConveyorEast(this,28, 14);
		moduleGrp.add(mod2);
		moduleArr.push(mod2);
		
		//mod.connections.push(mod2);
		
		var mod3:Module = new ConveyorEast(this,29, 14);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		
		var mod4:Machine = new Machine(this,33, 13,3,2);
		moduleGrp.add(mod4);
		moduleArr.push(mod4);
		mod4.productionSpeed = .5;
		
		//mod2.connections.push(mod3);
		
		//loading module types
		var loadedMod:Module = Type.createInstance(Type.resolveClass("machine.Machine"), [this,50,13,3,2]);
		moduleGrp.add(loadedMod);
		moduleArr.push(loadedMod);
		
		var mod:Module = new Machine(this,25, 8,3,2);
		moduleGrp.add(mod);
		moduleArr.push(mod);

		var mod:Module = new Machine(this,33, 8,3,2);
		moduleGrp.add(mod);
		moduleArr.push(mod);
		
		for (m in moduleArr)
		{
			m.refreshConnectionsEast();
			m.refreshConnectionsWest();
		}
		
	}
	public function addCrate()
	{
		var crate:InventoryItem = new InventoryItem();
		inventoryGrp.add(crate);
		moduleArr[0].addToInventory(crate);
		
	}
	public function addMachine()
	{
		var mod:Module = new ConveyorEast(this,Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
		moduleGrp.add(mod);
		moduleArr.push(mod);
		//mod.refreshConnectionsEast();
		
		// refresh all connections
		for (m in moduleArr)
		{
			//m.refreshConnectionsEast();
			m.refreshConnections();
			/*
			//trace(m.tilePos.tileX + " vs " + (Std.int(FlxG.mouse.x / GC.tileSize) - 1));
			if (m.tilePos.tileX == Std.int(FlxG.mouse.x / GC.tileSize) - 1 && m.tilePos.tileY == Std.int(FlxG.mouse.y / GC.tileSize))
			{
				m.connections.push(mod);				
			}
			*/
		}
		
	}
	public function addConvE()
	{
		var mod:Module = new ConveyorEast(this,Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
		moduleGrp.add(mod);
		moduleArr.push(mod);
		
		for (m in moduleArr)
		{
			m.refreshConnections();
		}
		
	}
	public function addConvW()
	{
		var mod:Module = new ConveyorWest(this,Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
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
}