package machine;
import fsm.FlxFSM;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import inventory.MachineSlot;
import inventory.SlotContainer;
import machinewindow.MachineWindow;
import inventory.InventoryItem;
import machine.machinestates.*;
import Lambda;

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
	//var hasTransformed:Bool;
	
	
	private var slotInput1:MachineSlot;
	private var slotInput2:MachineSlot;
	private var slotProcess:MachineSlot;
	private var slotOutput:MachineSlot;
	
	public var outputTestItem:InventoryItem;		
	//public var outputItem1:InventoryItem;
	
	//public var slotContainer:SlotContainer;
	
	public function new(Controller:MachineController,tileX:Int = 0, tileY:Int = 0,TileWidth:Int = 1, TileHeight:Int = 1) 
	{		
		super(Controller,tileX, tileY,TileWidth,TileHeight);
		
		//hasTransformed = false;
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
		
		slotInput1 = new MachineSlot();
		slotInput2 = new MachineSlot();
		slotProcess = new MachineSlot();
		slotOutput = new MachineSlot();
		
		
		fsm = new FlxFSM<Machine>(this, new PowerOff());
		
		//slotContainer = new SlotContainer(2, 2,baseImage.x+10, baseImage.y+10);
		//add(slotContainer);
		
		//slotContainer.addItem(new InventoryItem(InventoryItem.INV_COPPER_BAR, 0, 0));
		//slotContainer.addItem(new InventoryItem(InventoryItem.INV_CRATE, 0, 0));
		//slotContainer.addItem(new InventoryItem(FlxRandom.intRanged(0,9), 0, 0));
		//slotContainer.removeItem(new InventoryItem(FlxRandom.intRanged(0,9), 0, 0));
		
		//FlxG.watch.add(this,"slotInput1.invType","inp1 type");
		FlxG.watch.add(this,"slotInput1.itemCount","inp1 count");
		//FlxG.watch.add(this,"slotInput2.invType","inp2 type");
		FlxG.watch.add(this,"slotInput2.itemCount","inp2 count");
		FlxG.watch.add(this,"slotProcess.itemCount","proc count");
		FlxG.watch.add(this,"slotOutput.itemCount","out count");
		FlxG.watch.add(this,"currentProductionCompletion","prodcomp");
		
		outputTestItem = new InventoryItem(0, 0, 0);
		outputTestItem.visible = false;
		add(outputTestItem);
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
		//slotContainer.addItem(new InventoryItem(item.invType, 0, 0));
		
		//inventoryInputArr.push(item);		
		//trace("add");
		if (slotInput1.willAccept(item.invType))
		{
			slotInput1.addItem(item.invType);
		} 
		else if (slotInput2.willAccept(item.invType))
		{
			slotInput2.addItem(item.invType);
		} 
		this.controller.inventoryGrp.remove(item);
		item.destroy();
		//super.addToInventory(item);
	}
	//TODO: Maybe delete this?  only used by machineproducer
	/*
	public function addToOutput(item:InventoryItem):Void 
	{
		outputItem0 = item;
		super.addToInventory(item);
	}
	*/
	override public function willAddToInventory(item:InventoryItem):Bool
	{
		if (power < 100)
		{
			return false;
		}
		if (slotInput1.willAccept(item.invType))
		{
			return true;
		} 
		else if (slotInput2.willAccept(item.invType))
		{
			return true;
		} 
		else
		{
			return false;
		}
	}
	override public function getFromInventory():InventoryItem 
	{
		var item = super.getFromInventory();
		//slotContainer.removeItem(item);
		
		
		//inventoryOutputArr.remove(item);		
		return item;
		
	
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
		
		if (slotProcess.itemCount > 0 && currentProductionCompletion < 100 && power == 100)
		{				
			currentProductionCompletion += productionSpeed * FlxG.elapsed;								
		} 	
		else if (currentProductionCompletion >= 100 && slotProcess.itemCount > 0)
		{
			//hasTransformed = true;
			//doTransform(item);	
			productionFinished();
			//inventoryInputArr.remove(item);		
			//inventoryOutputArr.push(item);	
			
			
			
		}
		if (slotProcess.itemCount == 0)
		{			
			//take items for next product
			//TODO: this logic should be recipe based
			if (slotInput1.itemCount > 0 && slotInput2.itemCount > 0)
			{				
				slotInput1.removeItem();
				slotInput2.removeItem();
				slotProcess.addItem(0);
				currentProductionCompletion = 0;
			}
		}
		if (slotOutput.itemCount > 0)
		{
			outputSlotToItem();
		}
		
	}
	
	//take from output slot and move to connections
	function outputSlotToItem():Void
	{
		var connCount:Int = connections.length;
		var connCurrent:Int = -1;
		//trace("connections count " + connCount);
		if (connCount == 1)
		{
			connCurrent = 0;
		} 
		else if (connCount == 2)
		{
			if (lastOutput == 0)
			{
				connCurrent = 1;
			} else {
				connCurrent = 0;
			}
			lastOutput = connCurrent;
		}
		
		if (connCurrent > -1)
		{
			if (moveDirectionX == 1) //right
			{
				outputTestItem.x = baseImage.x + baseImage.width;				
			} else { //left
				outputTestItem.x = baseImage.x;
			}				
			outputTestItem.y = connections[connCurrent].tilePos.tileY * GC.tileSize + 0;
			outputTestItem.invType = slotOutput.invType;
			if (connections[connCurrent].willAddToInventory(outputTestItem) &&
				!doesItemOverlap(outputTestItem, connections[connCurrent].inventoryArr))
			{
				//trace("connCurrent " + connCurrent+ ". item0 " + outputItem0 + ". y " + connections[connCurrent].tilePos.tileY*GC.tileSize + "." );
				var item:InventoryItem = new InventoryItem(slotOutput.removeItem());
				
				if (moveDirectionX == 1) //right
				{
					item.x = baseImage.x + baseImage.width;
					//item.x = connections[connCurrent].tilePos.tileX * GC.tileSize - 15;
				} else { //left
					item.x = baseImage.x;
					//item.x = this.tilePos.tileX * GC.tileSize + 15;
				}				
				item.y = connections[connCurrent].tilePos.tileY*GC.tileSize + 0;
				this.controller.inventoryGrp.add(item);
				connections[connCurrent].addToInventory(item);
				lampOn();
				
			}
				//inventoryArr.push(item);
				//outputItem0 = item;
				/*
			} 
			else if (connCurrent == 1 && outputItem1 == null)
			{
				trace("connCurrent " + connCurrent+ ". item1 " + outputItem1 + ". y " + connections[connCurrent].tilePos.tileY*GC.tileSize + "." );
				
				var item:InventoryItem = new InventoryItem(slotOutput.removeItem());
				if (moveDirectionX == 1) //right
				{
					item.x = connections[connCurrent].tilePos.tileX * GC.tileSize - 15;
				} else { //left
					item.x = this.tilePos.tileX * GC.tileSize + 15;
				}
				item.y = connections[connCurrent].tilePos.tileY*GC.tileSize + 0;
				this.controller.inventoryGrp.add(item);
				inventoryArr.push(item);
				outputItem1 = item;
			}*/
			
		}
		
	}
	
	//move from process to output slot
	function productionFinished():Void
	{		
		//trace("slotProcess " + slotProcess.invType + "/" + slotProcess.itemCount);
		//trace("slotOutput " + slotOutput.invType + "/" + slotOutput.itemCount);
		if (slotOutput.willAccept(slotProcess.invType))
		{
			slotOutput.addItem(slotProcess.removeItem());	
			condition -= 1;
		}
	}
	
	public function doMoveOutput():Void
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
		currentTarget = targetOut;
		/*
		if (hasTransformed == false)
		{
			currentTarget = middleX;
		} else {
			currentTarget = targetOut;
		}
		*/
		//move output
		
		//for (item in inventoryArr) 7
		/*
		if (outputItem0 != null)
		{				
			moveOutputItem(outputItem0,0,currentTarget);			
		}
		if (outputItem1 != null)
		{			
			moveOutputItem(outputItem1,1,currentTarget);						
		}
		
		*/
		if (lampOutputCount > 0)
		{
			lampOutputCount --;
		} else {
			lampOff();
		}
		
	}
	/*
	function moveOutputItem(item:InventoryItem,whichOutput:Int,currentTarget:Float) 
	{
			var doMove:Bool = true;
			var orgX:Float = item.x;
			var orgY:Float = item.y;
			if (item.x != currentTarget)			
			{
				moveItem(item, FlxG.elapsed, currentTarget, 0);					
			}			
			if (item.x == currentTarget) // move to next module
			{								
				if (connections.length > 0)
				{
					if (doesItemOverlap(item, connections[whichOutput].inventoryArr))
					{
						doMove = false;						
					}
					
					if (doMove && connections[whichOutput].willAddToInventory(item))
					{
						//var item = getFromInventory();
						connections[whichOutput].addToInventory(item);
						lampOn();
						
						if (whichOutput == 0)
						{
							outputItem0 = null;
						} else {
							outputItem1 = null;
						}
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
					if (doesItemOverlap(item, connections[whichOutput].inventoryArr))
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
	*/
	
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
		fsm.state = new BreakDown();
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