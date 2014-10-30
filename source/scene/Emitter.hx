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
	private var _emitterSmokeWhite:FlxEmitter;
	private var _emitterSmokeBlack:FlxEmitter;
	private var _whitePixel:FlxParticle;	
	/* EMITTER */
	
	public function new(CollideGrp:FlxGroup = null ) 
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
		if (CollideGrp != null)
		{
			CollideGrp.add(_emitterDirt);
		}
		for (i in 0...(Std.int(_emitterDirt.maxSize / 2))) 
		{			
			_whitePixel = new FlxParticle();
			_whitePixel.loadGraphic(AssetPaths.particles__png, false, 4, 4);
			_whitePixel.animation.add("d", [0], 1, false);
			_whitePixel.animation.play("d");
			_whitePixel.visible = false; 
			_whitePixel.acceleration.y = 400; 		
			_emitterDirt.add(_whitePixel);	
			_whitePixel = new FlxParticle();
			_whitePixel.loadGraphic(AssetPaths.particles__png, false, 4, 4);
			_whitePixel.animation.add("d", [1], 1, false);
			_whitePixel.animation.play("d");
			_whitePixel.acceleration.y = 400; 						
			_whitePixel.visible = false;
			_emitterDirt.add(_whitePixel);
		}
		//_emitterDirt.maxRotation = 0;
		//_emitterDirt.minRotation  = 0;
		
		/* smoke */
		_emitterSmokeWhite = new FlxEmitter(40, 40, 100);
		_emitterSmokeWhite.setXSpeed( -50, 50);
		_emitterSmokeWhite.setYSpeed( -50, -100);
		_emitterSmokeWhite.width = GC.tileSize;
		_emitterSmokeWhite.height= GC.tileSize;
		
		_emitterSmokeWhite.bounce = 0.1;
		_emitterSmokeWhite.gravity = -100;
		add(_emitterSmokeWhite);
		
		for (i in 0...(Std.int(_emitterSmokeWhite.maxSize / 2))) 
		{			
			_whitePixel = new FlxParticle();
			_whitePixel.loadGraphic(AssetPaths.particles__png, false, 4, 4);
			_whitePixel.animation.add("d", [5], 1, false);
			_whitePixel.animation.play("d");
			_whitePixel.visible = false; 
			_whitePixel.acceleration.y = 10; 		
			_whitePixel.acceleration.x = -100; 		
			_emitterSmokeWhite.add(_whitePixel);	
			_whitePixel = new FlxParticle();
			_whitePixel.loadGraphic(AssetPaths.particles__png, false, 4, 4);
			_whitePixel.animation.add("d", [6], 1, false);
			_whitePixel.animation.play("d");
			_whitePixel.acceleration.y = 10; 						
			_whitePixel.acceleration.x = -100; 									
			_whitePixel.visible = false;
			_emitterSmokeWhite.add(_whitePixel);
		}
		
		_emitterSmokeBlack = new FlxEmitter(40, 40, 100);
		_emitterSmokeBlack.setXSpeed( -50, 50);
		_emitterSmokeBlack.setYSpeed( -50, -100);
		_emitterSmokeBlack.width = GC.tileSize;
		_emitterSmokeBlack.height= GC.tileSize;		
		_emitterSmokeBlack.bounce = 0.1;
		_emitterSmokeBlack.gravity = -100;
		add(_emitterSmokeBlack);
		
		for (i in 0...(Std.int(_emitterSmokeBlack.maxSize / 2))) 
		{			
			_whitePixel = new FlxParticle();
			_whitePixel.loadGraphic(AssetPaths.particles__png, false, 4, 4);
			_whitePixel.animation.frameIndex = 7;			
			_whitePixel.visible = false; 
			_whitePixel.acceleration.y = 10; 		
			_whitePixel.acceleration.x = -100; 		
			_emitterSmokeBlack.add(_whitePixel);	
			_whitePixel = new FlxParticle();
			_whitePixel.loadGraphic(AssetPaths.particles__png, false, 4, 4);
			_whitePixel.animation.frameIndex = 8;	
			_whitePixel.acceleration.y = 10; 						
			_whitePixel.acceleration.x = -100; 									
			_whitePixel.visible = false;
			_emitterSmokeBlack.add(_whitePixel);
		}
		
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
		
		_emitterSmokeWhite.x = X;
		_emitterSmokeWhite.y = Y;
		//_emitter.start(false, 1, 0.01,10,3);
		_emitterSmokeWhite.start(true, 0.5, 0,10,0.5);
	}
	public function emitSmokeBlack(X:Float,Y:Float):Void
	{		
		_emitterSmokeBlack.x = X;
		_emitterSmokeBlack.y = Y;
		//_emitter.start(false, 1, 0.01,10,3);
		_emitterSmokeBlack.start(false, 0.3, 0.05,0,.4);
	}
	public function stopSmokeBlack():Void
	{		
		_emitterSmokeBlack.start(false, 0.1, 0.05,1,.2);		
	}
}