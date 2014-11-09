package machine;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import machinewindow.MachineWindow;
import inventory.InventoryItem;
import machine.machinestates.BootUp;
import machine.machinestates.BreakDown;
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
	public var condition:Float = 100;
	
	public var productionSpeed:Float = 100;
	public var currentProductionCompletion:Float = 0;
	public var currentSpeedPercent:Float = 0.1;
		
	public var fsm:FlxFSM<Machine>;
	
	public var window:MachineWindow;
	
	var middleX:Float;
	var hasTransformed:Bool;
	
	public function new(Controller:MachineController,tileX:Int = 0, tileY:Int = 0,TileWidth:Int = 1, TileHeight:Int = 1) 
	{		
		super(Controller,tileX, tileY,TileWidth,TileHeight);
		
		hasTransformed = false;
		middleX = tileX * GC.tileSize+31;
		
		baseImage = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		//base.loadGraphic(AssetPaths.factory__png);
		imageLayer.add(baseImage);
		baseImage.setFacingFlip(FlxObject.LEFT, true, false);
		baseImage.setFacingFlip(FlxObject.RIGHT, false, false);
		baseImage.facing = FlxObject.RIGHT;
		
		
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
		
		moveDirectionX = 1;
		moveDirectionY = 0;
		this.connectsOutLeft = false;
		this.connectsOutRight = true;		
		this.connectsInLeft = true;
		this.connectsInRight = false;		
		this.connectsInDown = false;
		this.connectsInUp = false;
		
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
	public function setDirectionX(direction:Int)
	{
		if (direction == 1) //right
		{
			moveDirectionX = 1;			
			this.connectsOutLeft = false;
			this.connectsOutRight = true;		
			this.connectsInLeft = true;
			this.connectsInRight = false;		
			baseImage.facing = FlxObject.RIGHT;
		} else {
			moveDirectionX = -1;			
			this.connectsOutLeft = true;
			this.connectsOutRight = false;		
			this.connectsInLeft = false;
			this.connectsInRight = true;
			baseImage.facing = FlxObject.LEFT;
		}
		moveDirectionY = 0;
		this.connectsInDown = false;
		this.connectsInUp = false;
	}
	public function doProcessing():Void
	{
		var targetOut:Float;
		var currentTarget:Float;
		if (moveDirectionX == 1)
		{	//right
			targetOut = baseImage.x + baseImage.width;
		}
		else
		{	//left
			targetOut = baseImage.x;
		}
		if (hasTransformed == false)
		{
			currentTarget = middleX;
		} else {
			currentTarget = targetOut;
		}
		
		for (item in inventoryArr) 
		{					
			
			var doMove:Bool = true;
			var orgX:Float = item.x;
			var orgY:Float = item.y;
			if (item.x != currentTarget)			
			{
				moveItem(item, FlxG.elapsed, currentTarget, 0);					
			}
			else if (currentProductionCompletion < 100)
			{				
				currentProductionCompletion += productionSpeed * FlxG.elapsed;								
			} 			
			else if (hasTransformed == false && currentProductionCompletion >= 100)
			{
				hasTransformed = true;
				doTransform(item);			
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
						currentProductionCompletion = 0;
						hasTransformed = false;
						//item.visible = true;
						lampOn();
						
						//wear and tear
						condition-=1;
						
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
					if (doesItemOverlap(item, connections[0].inventoryArr))
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
	public function breakDown() 
	{
		condition = 0;
		//fsm.state = new BreakDown();
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
		else if (item.invType == InventoryItem.INV_IRON_CYLINDER)
		{			
			item.setInvType(InventoryItem.INV_PART_IRON_HEAD);
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
	public function doTransform(item:InventoryItem)
	{
		transformItem(item);	
	}
	
	
	
}