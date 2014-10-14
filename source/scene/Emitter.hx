package scene;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Emitter extends FlxGroup
{

	/* EMITTER */
	private var _emitter:FlxEmitter;
	private var _whitePixel:FlxParticle;	
	/* EMITTER */
	
	public function new() 
	{
		
		super();
		
		
		_emitter = new FlxEmitter(40, 40, 100);
		_emitter.setXSpeed( -50, 50);
		_emitter.setYSpeed( -50, -100);
		_emitter.width = GC.tileSize;
		_emitter.height= GC.tileSize;
		
		_emitter.bounce = 0.1;
		_emitter.gravity = 400;
		add(_emitter);
		
		for (i in 0...(Std.int(_emitter.maxSize / 2))) 
		{
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(4, 4, FlxColor.BROWN);
			_whitePixel.visible = false; 
			_whitePixel.acceleration.y = 400; 		
			_emitter.add(_whitePixel);	
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(2, 2, FlxColor.BLACK);
			_whitePixel.acceleration.y = 400; 						
			_whitePixel.visible = false;
			_emitter.add(_whitePixel);
		}
		
		
		
	}
	public function emit(X:Float,Y:Float):Void
	{
		
		_emitter.x = X;
		_emitter.y = Y;
		//_emitter.start(false, 1, 0.01,10,3);
		_emitter.start(true, 1, 0,10,3);
	}
	
}