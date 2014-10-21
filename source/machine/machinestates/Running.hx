package machine.machinestates;
import flixel.util.FlxColor;
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
		
	}
	override public function exit(Owner:Machine)
	{
		//trace("ext Running");		
		Owner.lampPowerOn.color = FlxColor.BLACK;
	}
}