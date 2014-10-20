package scene;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.system.layer.frames.FlxFrame;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class Emitter extends FlxGroup
{

	/* EMITTER */
	private var _emitterDirt:FlxEmitter;
	private var _emitterSmoke:FlxEmitter;
	private var _whitePixel:FlxParticle;	
	/* EMITTER */
	
	public function new() 
	{
		
		super();
		
		
		_emitterDirt = new FlxEmitter(40, 40, 100);
		_emitterDirt.setXSpeed( -50, 50);
		_emitterDirt.setYSpeed( -50, -100);
		_emitterDirt.width = GC.tileSize;
		_emitterDirt.height= GC.tileSize;
		
		_emitterDirt.bounce = 0.1;
		_emitterDirt.gravity = 400;
		add(_emitterDirt);
		
		for (i in 0...(Std.int(_emitterDirt.maxSize / 2))) 
		{			
			_whitePixel = new FlxParticle();
			_whitePixel.loadGraphic(AssetPaths.tinytiles__png, false, 4, 4);
			_whitePixel.animation.add("d", [0], 1, false);
			_whitePixel.animation.play("d");
			_whitePixel.visible = false; 
			_whitePixel.acceleration.y = 400; 		
			_emitterDirt.add(_whitePixel);	
			_whitePixel = new FlxParticle();
			_whitePixel.loadGraphic(AssetPaths.tinytiles__png, false, 4, 4);
			_whitePixel.animation.add("d", [1], 1, false);
			_whitePixel.animation.play("d");
			_whitePixel.acceleration.y = 400; 						
			_whitePixel.visible = false;
			_emitterDirt.add(_whitePixel);
		}
		//_emitterDirt.maxRotation = 0;
		//_emitterDirt.minRotation  = 0;
		
		/* smoke */
		_emitterSmoke = new FlxEmitter(40, 40, 100);
		_emitterSmoke.setXSpeed( -50, 50);
		_emitterSmoke.setYSpeed( -50, -100);
		_emitterSmoke.width = GC.tileSize;
		_emitterSmoke.height= GC.tileSize;
		
		_emitterSmoke.bounce = 0.1;
		_emitterSmoke.gravity = -100;
		add(_emitterSmoke);
		
		for (i in 0...(Std.int(_emitterSmoke.maxSize / 2))) 
		{			
			_whitePixel = new FlxParticle();
			_whitePixel.loadGraphic(AssetPaths.tinytiles__png, false, 4, 4);
			_whitePixel.animation.add("d", [5], 1, false);
			_whitePixel.animation.play("d");
			_whitePixel.visible = false; 
			_whitePixel.acceleration.y = 10; 		
			_whitePixel.acceleration.x = -100; 		
			_emitterSmoke.add(_whitePixel);	
			_whitePixel = new FlxParticle();
			_whitePixel.loadGraphic(AssetPaths.tinytiles__png, false, 4, 4);
			_whitePixel.animation.add("d", [6], 1, false);
			_whitePixel.animation.play("d");
			_whitePixel.acceleration.y = 10; 						
			_whitePixel.acceleration.x = -100; 									
			_whitePixel.visible = false;
			_emitterSmoke.add(_whitePixel);
		}
		//_emitterSmoke.maxRotation = 0;
		//_emitterSmoke.minRotation  = 0;
		
	}
	public function emit(X:Float,Y:Float):Void
	{
		
		_emitterDirt.x = X;
		_emitterDirt.y = Y;
		//_emitter.start(false, 1, 0.01,10,3);
		_emitterDirt.start(true, 1, 0,10,3);
	}
	public function emitSmoke(X:Float,Y:Float):Void
	{
		
		_emitterSmoke.x = X;
		_emitterSmoke.y = Y;
		//_emitter.start(false, 1, 0.01,10,3);
		_emitterSmoke.start(true, 0.5, 0,10,0.5);
	}
}