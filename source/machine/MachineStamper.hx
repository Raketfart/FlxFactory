package machine;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import machinewindow.MachineWindow;
import inventory.InventoryItem;

/**
 * ...
 * @author 
 */
class MachineStamper extends Machine
{
	var stamper:FlxSprite;
	private var tween:FlxTween;	
	var hasStamped:Bool;
	
	
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
		hasTransformed = false;
		middleX = tileX * GC.tileSize+31;
		
		//moveSpeed = 24;
		moveDirectionX = 1;
		moveDirectionY = 0;
		this.connectsOutLeft = false;
		this.connectsOutRight = true;		
		this.connectsInLeft = true;
		this.connectsInRight = false;		
		this.connectsInDown = false;
		this.connectsInUp = false;
		
		//tween = FlxTween.tween(stamper, {  y:stamper.y-12 }, .5, { ease: FlxEase.expoOut, complete: stampDown} );
	}
	override public function doProcessing():Void
	{
		//no super!!!!!!!
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
		if (hasStamped == false)
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
			
			if (hasStamped || item.x != currentTarget)
			{
				moveItem(item, FlxG.elapsed, currentTarget, 0);				
			} 			
			else if (hasStamped == false && stamper.animation.name=="idle")
			{
				stamper.animation.play("movedown");				
			} 
			else if (stamper.animation.finished  && hasTransformed == false) 
			{
				transformItem(item);
				hasTransformed = true;
				stamper.animation.play("moveup");
			}
			else if (stamper.animation.finished) 
			{
				stamper.animation.play("idle");
				hasStamped = true;
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
						
						//item.visible = true;
						lampOn();
						currentProductionCompletion = 0;
						
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
	
	override public function addToInventory(item:InventoryItem):Void 
	{
		hasStamped = false;
		hasTransformed = false;
		super.addToInventory(item);
		if (GC.debugdraw)
		{
			item.color = FlxColor.RED;
		}
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