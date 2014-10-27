package machine;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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
class MachineStamper extends Machine
{
	var stamper:FlxSprite;
	private var tween:FlxTween;
	var hasStampChanged:Bool;
	var hasStamped:Bool;
	var stampX:Float;
	public function new(Controller:MachineController,tileX:Int = 0, tileY:Int = 0) 
	{		
		//ONLY LEFT TO RIGHT!!!!
		
		super(Controller,tileX, tileY,3,2);
		stamper = new FlxSprite(tileX*GC.tileSize+17, tileY*GC.tileSize+13);
		stamper.loadGraphic(AssetPaths.factoryStamper_2__png, true, 28, 14);
		stamper.animation.add("idle", [12], 1, false);
		stamper.animation.add("movedown", [12,11,10,9,8,7,6,5,4,3,2,1,0,0,0,0,0], 30, false);
		stamper.animation.add("moveup", [0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12], 30, false);
		imageLayer.add(stamper);
		stamper.animation.play("idle");
		/*
		var base:FlxSprite = new FlxSprite(tileX*GC.tileSize, tileY*GC.tileSize);
		base.loadGraphic(AssetPaths.factory__png);
		imageLayer.add(base);
		*/
		baseImage.loadGraphic(AssetPaths.factoryStamper_1__png);
		hasStamped = false;
		hasStampChanged = false;
		stampX = tileX * GC.tileSize+31;
		
		//tween = FlxTween.tween(stamper, {  y:stamper.y-12 }, .5, { ease: FlxEase.expoOut, complete: stampDown} );
	}
	override public function doProcessing():Void
	{
		//no super!!!!!!!
		
		for (item in inventoryArr) {
			var doMove:Bool = true;
			var orgX:Float = item.x;
			var orgY:Float = item.y;
			
			if (hasStamped || item.x < stampX)
			{
				item.x += .4;
			} else if (hasStamped == false && stamper.animation.name=="idle")
			{
				stamper.animation.play("movedown");				
			} else if (stamper.animation.finished  && hasStampChanged == false) {
				//item.setInvType(InventoryItem.INV_STEEL_CYLINDER);
				transformItem(item);
				hasStampChanged = true;
				stamper.animation.play("moveup");
			} else if (stamper.animation.finished) {
				stamper.animation.play("idle");
				//item.setframe(InventoryItem.INV_STEEL_CYLINDER);
				hasStamped = true;
			}
			//currentProductionCompletion += productionSpeed * FlxG.elapsed;
			//if (currentProductionCompletion > 100)
			//{
				
			//}
			if (item.x > baseImage.x + baseImage.width) // move to next module
			{				
				
				if (connections.length > 0)
				{
					for (otheritem in connections[0].inventoryArr)
					{
						if (item.overlaps(otheritem))
						{
							doMove = false;
						}
					}
					if (doMove && connections[0].willAddToInventory(item))
					{
						var item = getFromInventory();
						connections[0].addToInventory(item);
						
						//item.visible = true;
						lampOn();
						currentProductionCompletion = 0;
						
					} else {
						doMove = false;
					}
				} else {
					doMove = false;
				}
				
			} else { // move in this module
				
				for (otheritem in inventoryArr)
				{
					if (item != otheritem)
					{
						if (item.overlaps(otheritem))
						{
							doMove = false;
						}
					}
				}
				if (connections.length > 0)
				{
					for (otheritem in connections[0].inventoryArr)
					{
						if (item.overlaps(otheritem))
						{
							doMove = false;
						}
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
	
	override public function addToInventory(item:InventoryItem):Void 
	{
		hasStamped = false;
		hasStampChanged = false;
		super.addToInventory(item);
	}
	
	/*
	public function stampDown(tween:FlxTween ):Void
	{
		tween = FlxTween.tween(stamper, {  y:stamper.y+12 }, .5, { ease: FlxEase.expoOut, complete: stampUp} );
	}
	public function stampUp(tween:FlxTween ):Void 
	{
		tween = FlxTween.tween(stamper, {  y:stamper.y-12 }, .5, { startDelay: .2, ease: FlxEase.expoOut, complete: stampDown} );
	}*/
}