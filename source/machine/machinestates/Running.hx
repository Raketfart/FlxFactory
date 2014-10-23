package machine.machinestates;
import flixel.util.FlxColor;
import hud.MachineWindow;
import util.FlxFSM;
import util.FlxFSM.FlxFSMState;

class Running extends FlxFSMState<Machine>
{
	override public function enter(Owner:Machine, FSM:FlxFSM<Machine>)
	{
		//trace("Enter Running");		
		Owner.lampPowerOn.color = FlxColor.GREEN;
	}
	
	override public function update(elapsed:Float, Owner:Machine, FSM:FlxFSM<Machine>)
	{		
	
		Owner.doWork();
		
		if (Owner.window != null)
		{
			updateWindow(Owner.window);			
		}
		
	}
	override public function exit(Owner:Machine)
	{
		//trace("ext Running");		
		Owner.lampPowerOn.color = FlxColor.BLACK;
	}
	
	function updateWindow(win:MachineWindow)
	{
		win.lamp1.animation.play("green");
		win.lamp2.animation.play("green");
		win.lamp3.animation.play("green");
		win.cogs.animation.play("running");
		win.bootProgressBar.visible = false;
		win.moveGauge();
	}
}