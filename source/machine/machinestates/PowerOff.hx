package machine.machinestates;
import flixel.util.FlxColor;
import util.FlxFSM;
import util.FlxFSM.FlxFSMState;

class PowerOff extends FlxFSMState<Machine>
{
	override public function enter(Owner:Machine, FSM:FlxFSM<Machine>)
	{
		//trace("Enter PowerOff");		
		Owner.lampPowerOff.color = FlxColor.RED;
	}
	
	override public function update(elapsed:Float, Owner:Machine, FSM:FlxFSM<Machine>)
	{		
	
	}
	override public function exit(Owner:Machine)
	{
		//trace("exit PowerOff");		
		Owner.lampPowerOff.color = FlxColor.BLACK;
	}
}