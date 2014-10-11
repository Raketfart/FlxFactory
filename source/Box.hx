package ;
import flixel.FlxSprite;

/**
 * ...
 * @author 
 */
class Box extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0) 
    {
        super(X, Y);
		makeGraphic(10, 10);
		drag.x = 200;
		drag.y = 200;
		acceleration.y = 420;
		maxVelocity.set(120, 200);
		
	}
	
}