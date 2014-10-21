package machine.machinestates;
import flixel.util.FlxColor;
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
	}
	override public function exit(Owner:Machine)
	{
		//trace("ext Running");		
		Owner.lampPowerBoot.color = FlxColor.BLACK;
	}
}