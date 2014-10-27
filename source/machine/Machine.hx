package machine;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import hud.MachineWindow;
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
	public var baseImage:FlxSprite;
	
	public var lampPowerOff:FlxSprite;	
	public var lampPowerBoot:FlxSprite;
	public var lampPowerOn:FlxSprite;
	
	public var power:Float = 0;
	public var bootSpeed:Float = 80;
		
	public var productionSpeed:Float = 100;
	public var currentProductionCompletion:Float = 0;
	public var currentSpeedPercent:Float = 0.1;
		
	public var fsm:FlxFSM<Machine>;
	
	public var window:MachineWindow;
	
	public function new(Controller:MachineController,tileX:Int = 0, tileY:Int = 0,TileWidth:Int = 1, TileHeight:Int = 1) 
	{		
		super(Controller,tileX, tileY,TileWidth,TileHeight);
		
		baseImage = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		//base.loadGraphic(AssetPaths.factory__png);
		imageLayer.add(baseImage);
		
		
		lampOutput = new FlxSprite(baseImage.x+14, baseImage.y+30);
		lampOutput.makeGraphic(2, 2, FlxColor.RED);
		imageLayer.add(lampOutput);
		
		lampPowerOff = new FlxSprite(baseImage.x+20, baseImage.y+35);
		lampPowerOff.makeGraphic(2, 2, FlxColor.WHITE);
		lampPowerOff.color = FlxColor.BLACK;
		imageLayer.add(lampPowerOff);
		
		lampPowerBoot = new FlxSprite(baseImage.x+26, baseImage.y+35);
		lampPowerBoot.makeGraphic(2, 2, FlxColor.WHITE);
		lampPowerBoot.color = FlxColor.BLACK;
		imageLayer.add(lampPowerBoot);
		
		lampPowerOn = new FlxSprite(baseImage.x+32, baseImage.y+35);
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
			//item.visible = false;
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
	
	public function doProcessing():Void
	{
	
		if (inventoryArr.length > 0)
		{
			
			inventoryArr[0].x = baseImage.x + 30;
			inventoryArr[0].y = baseImage.y + 20;
			
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
					if (connections[lastOutput].tilePos.tileX < this.tilePos.tileX) //left of machine
					{
						inventoryArr[0].x = (connections[lastOutput].tilePos.tileX+connections[lastOutput].tileWidth) * GC.tileSize;
						inventoryArr[0].y = connections[lastOutput].tilePos.tileY * GC.tileSize;
					} else {
						inventoryArr[0].x = connections[lastOutput].tilePos.tileX * GC.tileSize;
						inventoryArr[0].y = connections[lastOutput].tilePos.tileY * GC.tileSize;
					}
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
						transformItem(item);
						//item.visible = true;
						connections[lastOutput].addToInventory(item);
						lampOn();
						currentProductionCompletion = 0;
					} else {
						doMove = false;
						inventoryArr[0].x = baseImage.x + 30;
						inventoryArr[0].y = baseImage.y + 20;
			
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
	public function turnOff():Void
	{
		fsm.state = new PowerOff();
	}
	public function attachWindow(Window:MachineWindow):Void
	{
		window = Window;
	}
	public function detachWindow():Void
	{
		window = null;
	}
	public function transformItem(item:InventoryItem):Void
	{
		if (item.invType == InventoryItem.INV_IRON_RAW)
		{			
			item.setInvType(InventoryItem.INV_IRON_BAR);
		} 
		else if (item.invType == InventoryItem.INV_IRON_BAR)
		{			
			item.setInvType(InventoryItem.INV_IRON_CYLINDER);
		}
		else if (item.invType == InventoryItem.INV_COPPER_RAW)
		{			
			item.setInvType(InventoryItem.INV_COPPER_BAR);
		}
		else if (item.invType == InventoryItem.INV_COPPER_BAR)
		{			
			item.setInvType(InventoryItem.INV_COPPER_CYLINDER);
		}		
		else 
		{			
			item.setInvType(InventoryItem.INV_CRATE);
		}

	}
	
}