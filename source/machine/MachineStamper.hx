package machine;
import crafting.Recipe;
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
	var hasTransformed:Bool;
	var processDisplayItem:InventoryItem;
	
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
		
		processDisplayItem = new InventoryItem(0, baseImage.x,baseImage.y);
		processDisplayItem.visible = true;
		imageBackgroundLayer.add(processDisplayItem);
		processDisplayItem.y = baseImage.y+(1 * GC.tileSize);
		processDisplayItem.x = baseImage.x + 10;
		
		currentRecipe = new Recipe();
		currentRecipe.inputType1 = InventoryItem.INV_IRON_BAR;		
		currentRecipe.inputAmount1 = 1;
		currentRecipe.inputType2 = -1;
		currentRecipe.inputAmount2 = 0;
		currentRecipe.outputType = InventoryItem.INV_IRON_CYLINDER;
		currentRecipe.outputAmount = 1;
		
		//FlxG.watch.add(this,"hasStamped","hasStamped");
		//tween = FlxTween.tween(stamper, {  y:stamper.y-12 }, .5, { ease: FlxEase.expoOut, complete: stampDown} );
	}
	override public function loadProcessing(invType:Int,amount:Int):Void
	{
		super.loadProcessing(invType,amount);
		hasStamped = false;	
		hasTransformed = false;
		//set display to input 1 type
		processDisplayItem.setInvType(currentRecipe.inputType1);
		if (moveDirectionX == 1)
		{	//right
			processDisplayItem.x = baseImage.x + 10;
		}
		else
		{	//left			
			processDisplayItem.x = baseImage.x + baseImage.width-10;
		}		
	}
	override public function processingAdvance():Void
	{
		var targetOut:Float;
		var currentTarget:Float;
		if (moveDirectionX == 1)
		{	//right
			targetOut = baseImage.x + baseImage.width-10;
		}
		else
		{	//left
			targetOut = baseImage.x+10;
		}
		if (hasStamped == false)
		{
			currentTarget = middleX;
		} else {
			currentTarget = targetOut;
		}
		
		if (hasStamped && processDisplayItem.x == currentTarget)
		{
			currentProductionCompletion = 100;
		}
		else if (hasStamped || processDisplayItem.x != currentTarget)
		{
			//trace("moving" + hasStamped + ". " + currentTarget + "-" +processDisplayItem.x);
			moveItem(processDisplayItem, FlxG.elapsed, currentTarget, 0);				
		}
		else if (hasStamped == false && stamper.animation.name=="idle")
		{
			//trace("stampdown");
			stamper.animation.play("movedown");				
		} 
		else if (stamper.animation.finished  && hasTransformed == false) 
		{
			//trace("transform + moveup" + hasTransformed);
			hasTransformed = true;
			//transformItem(processDisplayItem);			
			processDisplayItem.setInvType(currentRecipe.outputType);
			stamper.animation.play("moveup");
		}
		else if (stamper.animation.finished) 
		{
			//trace("idle");
			stamper.animation.play("idle");
			hasStamped = true;			
		}
	}
	
	
	override public function addToInventory(item:InventoryItem):Void 
	{
		//hasStamped = false;
		//hasTransformed = false;
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