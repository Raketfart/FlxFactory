package machine;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Conveyor extends Module
{
	var productCounter:Int;
	public function new(tileX:Int=0, tileY:Int=0) 
	{		
		super(tileX, tileY);
		
		makeGraphic(GC.tileSize,GC.tileSize,FlxColor.BLUE);
		
	}
	override public function update():Void 
	{
		super.update();
		
	}
	
}