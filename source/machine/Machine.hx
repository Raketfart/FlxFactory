package machine;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import inventory.InventoryItem;
import machine.machinestates.BootUp;
import machine.machinestates.PowerOff;
import util.FlxFSM;

/**
 * ...
 * @author 
 */
class Machine extends Module
{
	//var productCounter:Float;
	var lastOutput:Int=0;
	
	var lampOutput:FlxSprite;
	var lampOutputCount:Float = 0;
	
	public var lampPowerOff:FlxSprite;	
	public var lampPowerBoot:FlxSprite;
	public var lampPowerOn:FlxSprite;
	
	public var power:Float = 0;
	public var bootSpeed:Float = 20;
		
	public var productionSpeed:Float = 25;
	public var currentProductionCompletion:Float = 0;
	public var currentSpeedPercent:Float = 0.1;
		
	public var fsm:FlxFSM<Machine>;
	
	public function new(Controller:MachineController,tileX:Int = 0, tileY:Int = 0) 
	{		
		super(Controller,tileX, tileY,3,2);
		
		/*
		var base:FlxSprite = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		base.makeGraphic(GC.tileSize*TileWidth, GC.tileSize*TileHeight, FlxColor.GRAY);
		imageLayer.add(base);*/
		var base:FlxSprite = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		base.loadGraphic(AssetPaths.factory__png);
		imageLayer.add(base);
		
		lampOutput = new FlxSprite(base.x+14, base.y+10);
		lampOutput.makeGraphic(2, 2, FlxColor.RED);
		imageLayer.add(lampOutput);
		
		lampPowerOff = new FlxSprite(base.x+20, base.y+15);
		lampPowerOff.makeGraphic(2, 2, FlxColor.WHITE);
		lampPowerOff.color = FlxColor.BLACK;
		imageLayer.add(lampPowerOff);
		
		lampPowerBoot = new FlxSprite(base.x+26, base.y+15);
		lampPowerBoot.makeGraphic(2, 2, FlxColor.WHITE);
		lampPowerBoot.color = FlxColor.BLACK;
		imageLayer.add(lampPowerBoot);
		
		lampPowerOn = new FlxSprite(base.x+32, base.y+15);
		lampPowerOn.makeGraphic(2, 2, FlxColor.WHITE);
		lampPowerOn.color = FlxColor.BLACK;
		imageLayer.add(lampPowerOn);
		
		this.connectsOutLeft = true;
		this.connectsOutRight = true;
		this.connectsInLeft = true;
		this.connectsInRight = true;
		
		fsm = new FlxFSM<Machine>(this, new PowerOff());
		
	}
	override public function update():Void 
	{
		super.update();
		
		fsm.update(FlxG.elapsed);
		
		
	}
	override public function addToInventory(item:InventoryItem):Void 
	{
		if (GC.debugdraw == false)
		{
			item.visible = false;
		}
		super.addToInventory(item);
	}
	override public function willAddToInventory(item:InventoryItem):Bool
	{
		if (inventoryArr.length > 0 )
		{
			return false;
		}
		else
		{
			return true;
		}
	}
	
	public function doWork():Void
	{
	
		if (inventoryArr.length > 0)
		{
			
			inventoryArr[0].x = lampOutput.x + 10;
			inventoryArr[0].y = lampOutput.y + 10;
			
			currentProductionCompletion += productionSpeed * FlxG.elapsed;
			//trace("compl " + currentProductionCompletion);
			if (currentProductionCompletion > 100)
			{
				
				var doMove:Bool = true;
				
				if (lastOutput >= connections.length)
				{
					lastOutput = 0;
				}
				
				if (connections.length > 0)
				{
					inventoryArr[0].x = connections[lastOutput].tilePos.tileX * GC.tileSize;
					inventoryArr[0].y = connections[lastOutput].tilePos.tileY * GC.tileSize;
					
					for (otheritem in connections[lastOutput].inventoryArr)
					{
						if (inventoryArr[0].overlaps(otheritem))
						{
							doMove = false;
						}
					}
					
					if (doMove && connections[lastOutput].willAddToInventory(inventoryArr[0]))
					{
						var item = getFromInventory();
						item.visible = true;
						connections[lastOutput].addToInventory(item);
						lampOn();
						currentProductionCompletion = 0;
					} else {
						doMove = false;
						inventoryArr[0].x = lampOutput.x + 10;
						inventoryArr[0].y = lampOutput.y + 10;
					}
				}
				lastOutput+= 1;
				
			}
			
		}
		if (lampOutputCount > 0)
		{
			lampOutputCount --;
		} else {
			lampOff();
		}
	}
	
	
	public function lampOn():Void
	{
		lampOutputCount = 10;
		lampOutput.visible = true;
	}
	public function lampOff():Void
	{
		lampOutput.visible = false;
	}
	public function turnOn():Void
	{
		fsm.state = new BootUp();
	}
	
	
}