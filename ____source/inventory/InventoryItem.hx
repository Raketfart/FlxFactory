package inventory ;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class InventoryItem extends FlxSprite
{
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(Std.int(GC.tileSize/3),Std.int(GC.tileSize/3),FlxColor.BROWN);
		
		offset.x = width / 2;
		offset.y = height/ 2;
	}
	
}