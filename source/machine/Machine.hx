package machine;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Machine extends Module
{
	var productCounter:Int;
	public function new(tileX:Int=0, tileY:Int=0) 
	{		
		super(tileX, tileY);
		productCounter = 0;
		makeGraphic(GC.tileSize,GC.tileSize,FlxColor.CHARCOAL);
		
	}
	override public function update():Void 
	{
		super.update();
		productCounter++;
		if (productCounter > 300)
		{
			trace("PRODUCT COUNT DONE");
			productCounter = 0;
		}
	}
	
}