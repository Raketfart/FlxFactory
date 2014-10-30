package machine.machinestates;
import flixel.util.FlxColor;
import hud.MachineWindow;
import util.FlxFSM;
import util.FlxFSM.FlxFSMState;

class BootUp extends FlxFSMState<Machine>
{
	override public function enter(Owner:Machine, FSM:FlxFSM<Machine>)
	{
		//trace("Enter BootUp");				
		Owner.lampPowerBoot.color = FlxColor.YELLOW;		
	}
	
	override public function update(elapsed:Float, Owner:Machine, FSM:FlxFSM<Machine>)
	{		
		
		Owner.power += Owner.bootSpeed * elapsed;
		if (Owner.power > 100)
		{
			Owner.power = 100;
			FSM.state = new Running();			
		}
		
		if (Owner.window != null)
		{
			updateWindow(Owner.window,Owner.power);			
		}
	}
	override public function exit(Owner:Machine)
	{
		//trace("ext Running");		
		Owner.lampPowerBoot.color = FlxColor.BLACK;
		
	}
	
	function updateWindow(win:MachineWindow,power:Float)
	{		
		if (power < 40)
		{
			win.lamp1.animation.play("flashyellow");
			win.lamp2.animation.play("black");
			win.lamp3.animation.play("black");
		} else if (power < 70)
		{
			win.lamp1.animation.play("green");
			win.lamp2.animation.play("flashyellow");
			win.lamp3.animation.play("black");
		} else
		{
			win.lamp1.animation.play("green");
			win.lamp2.animation.play("green");
			win.lamp3.animation.play("flashyellow");
		} 
		
		win.cogs.animation.play("stopped");
		win.bootProgressBar.visible = true;
		win.moveGauge(false);
		win.screentext.text = "";
	}
	
}