package machine.machinestates;
import flixel.util.FlxColor;
import hud.MachineWindow;
import util.FlxFSM;
import util.FlxFSM.FlxFSMState;

class PowerOff extends FlxFSMState<Machine>
{
	override public function enter(Owner:Machine, FSM:FlxFSM<Machine>)
	{
		//trace("Enter PowerOff");	
		Owner.power = 0;
		Owner.lampPowerOff.color = FlxColor.RED;
		
	}
	
	override public function update(elapsed:Float, Owner:Machine, FSM:FlxFSM<Machine>)
	{		
		if (Owner.window != null)
		{
			updateWindow(Owner.window);			
		}
	}
	
	override public function exit(Owner:Machine)
	{
		//trace("exit PowerOff");		
		Owner.lampPowerOff.color = FlxColor.BLACK;
	}
	
	function updateWindow(win:MachineWindow)
	{
		win.lamp1.animation.play("black");
		win.lamp2.animation.play("black");
		win.lamp3.animation.play("black");
		win.cogs.animation.play("stopped");
		win.moveGauge(false);
		win.bootProgressBar.visible = false;		
	}
}