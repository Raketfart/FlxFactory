package ;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Conveyor extends FlxSprite
{
	public static var idcount:Int = 0;
	public function new(X:Float=0, Y:Float=0) 
    {
        super(X, Y);
		makeGraphic(21, 21,FlxColor.CHARCOAL);
		immovable = true;
		idcount++;
		this.ID = idcount;
	}
	
}