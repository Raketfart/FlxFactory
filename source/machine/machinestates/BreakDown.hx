package machine.machinestates;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import machinewindow.MachineWindow;
import fsm.FlxFSM;
import fsm.FlxFSM.FlxFSMState;


class BreakDown extends FlxFSMState<Machine>
{
	//private var 
	override public function enter(Owner:Machine, FSM:FlxFSM<Machine>)
	{
		//trace("Enter Running");		
		Owner.lampPowerOn.color = FlxColor.RED;
		FlxSpriteUtil.flicker(Owner.lampPowerOn, 0, 0.04);
		GC.state.emitter.emitSmokeBlack((Owner.tilePos.tileX+Std.int(Owner.tileWidth/2))*GC.tileSize,Owner.tilePos.tileY*GC.tileSize);
	}
	
	override public function update(elapsed:Float, Owner:Machine, FSM:FlxFSM<Machine>)
	{		
	
		
		if (Owner.condition > 10)
		{			
			FSM.state = new BootUp();			
		}
		
		if (Owner.window != null)
		{
			updateWindow(Owner.window,Owner);			
		}
		
	}
	override public function exit(Owner:Machine)
	{
		//trace("ext Running");		
		Owner.lampPowerOn.color = FlxColor.BLACK;
		FlxSpriteUtil.stopFlickering(Owner.lampPowerOn);
		GC.state.emitter.stopSmokeBlack();
	}
	
	function updateWindow(win:MachineWindow, Owner:Machine )
	{		
		win.lamp1.animation.play("red");
		win.lamp2.animation.play("red");
		win.lamp3.animation.play("red");
		win.cogs.animation.play("stopped");
		win.bootProgressBar.visible = false;
		win.moveGauge(false);
		win.screentext.text = "CONDITION CRITICAL: " + Owner.condition + "%";
	}
}