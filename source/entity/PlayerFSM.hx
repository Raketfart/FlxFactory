package entity ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.util.FlxFSM;

/**
 * ...
 * @author 
 */
class PlayerFSM extends FlxSprite
{
	public var fsm:FlxFSM<FlxSprite>;
	
	public function new(X:Float = 0, Y:Float = 0)
	{
		super(X, Y);
		
		loadGraphic(AssetPaths.characterpixel__png, true,21,21);
		
		setSize(11, 18);
		offset.set(5, 2);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		animation.add("standing", [0], 6);
		animation.add("walking", [1,9,10], 6);
		animation.add("jumping", [7,8],6);
		animation.add("pound", [3],6);
		animation.add("landing", [3,0,3,0], 6, false);
		
		//acceleration.y = 400;
		maxVelocity.y = 1;
		maxVelocity.x = 1;
		
		fsm = new FlxFSM<FlxSprite>(this, new Idle());
	}

	override public function update(elapsed:Float):Void
	{
		//trace("state " + fsm.stateClass + " : " + fsm.name + " : " + fsm.type + " : " + fsm.owner);
		
		fsm.update(FlxG.elapsed);
		super.update(elapsed);
	}

	override public function destroy():Void
	{
		super.destroy();
	}
}

class Idle extends FlxFSMState<FlxSprite>
{
	override public function enter(Owner:FlxSprite, FSM:FlxFSM<FlxSprite>)
	{
		Owner.animation.play("standing");
	}
	
	override public function update(elapsed:Float, Owner:FlxSprite, FSM:FlxFSM<FlxSprite>)
	{
		Owner.acceleration.x = 0;
		
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{			
			Owner.animation.play("walking");
			Owner.acceleration.x = FlxG.keys.pressed.LEFT ? -300 : 300;
		}
		else
		{
			Owner.velocity.x *= 0.9;
			Owner.animation.play("standing");
		}
		
		if (FlxG.keys.pressed.UP)
		{
			FSM.state = new Jump();
			return;
		}
	}
}

class Jump extends FlxFSMState<FlxSprite>
{
	var doubleJumpCounter:Int;
	
	override public function enter(Owner:FlxSprite, FSM:FlxFSM<FlxSprite>)
	{
		Owner.animation.play("jumping");
		Owner.velocity.y = -200;
		doubleJumpCounter = 0;
	}
	
	override public function update(elapsed:Float,Owner:FlxSprite, FSM:FlxFSM<FlxSprite>)
	{
		Owner.acceleration.x = 0;
		
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
			Owner.acceleration.x = FlxG.keys.pressed.LEFT ? -300 : 300;
		}
		
		if (FlxG.keys.justPressed.UP && doubleJumpCounter == 0)
		{
			Owner.velocity.y = -100;
			doubleJumpCounter++;
		}
		
		if (FlxG.keys.justPressed.DOWN)
		{
			FSM.state = new GroundPound();
			return;
		}
		
		if (Owner.isTouching(FlxObject.DOWN))
		{
			FSM.state = new Idle();
			return;
		}
	}
}

class GroundPound extends FlxFSMState<FlxSprite>
{
	private var ticks:Float;
	override public function enter(Owner:FlxSprite, FSM:FlxFSM<FlxSprite>)
	{
		Owner.animation.play("pound");
		Owner.velocity.x = 0;
		ticks = 0;
	}
	
	override public function update(elapsed:Float,Owner:FlxSprite, FSM:FlxFSM<FlxSprite>)
	{
		ticks++;
		if (ticks < 15)
		{
			Owner.velocity.y = 0;
		}
		else
		{
			Owner.velocity.y = 300;
		}
		if (Owner.isTouching(FlxObject.DOWN))
		{
			FSM.state = new GroundPoundFinish();
			return;
		}
	}
}

class GroundPoundFinish extends FlxFSMState<FlxSprite>
{
	override public function enter(Owner:FlxSprite, FSM:FlxFSM<FlxSprite>)
	{
		Owner.animation.play("landing");
	}
	
	override public function update(elapsed:Float,Owner:FlxSprite, FSM:FlxFSM<FlxSprite>)
	{
		if (Owner.animation.finished)
		{
			FSM.state = new Idle();
		}
	}
}

