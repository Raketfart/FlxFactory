package machine.machinestates;
import flixel.util.FlxColor;
import inventory.InventoryItem;
import machinewindow.MachineWindow;
import fsm.FlxFSM;
import fsm.FlxFSM.FlxFSMState;


class Running extends FlxFSMState<Machine>
{
	override public function enter(Owner:Machine, FSM:FlxFSM<Machine>)
	{
		//trace("Enter Running");		
		Owner.lampPowerOn.color = FlxColor.GREEN;
	}
	
	override public function update(elapsed:Float, Owner:Machine, FSM:FlxFSM<Machine>)
	{		
		//Owner.doMoveOutput();
		
		Owner.doProcessing();
		
		if (Owner.condition <= 0)
		{
			Owner.condition = 0;
			Owner.power = 0;
			FSM.state = new BreakDown();	
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
	}
	
	function updateWindow(win:MachineWindow, Owner:Machine)
	{
		Owner.productionSpeed = win.dragLever.currentValue;
		
		win.lamp1.animation.play("green");
		win.lamp2.animation.play("green");
		win.lamp3.animation.play("green");
		win.cogs.animation.play("running");
		win.bootProgressBar.visible = false;
		win.moveGauge(true);
		win.screentext.text = "CONDITION: " + Owner.condition + "%\n";
		win.screentext.text += "SPEED: " + Owner.productionSpeed + "\n";
		if (Owner.currentRecipe != null)
		{
			win.screentext.text += "OUTPUT: " + InventoryItem.invToString(Owner.currentRecipe.outputType) + "\n";
			
			win.screentext.text += "Req1: " + InventoryItem.invToString(Owner.currentRecipe.inputType1) + "\n";
			win.screentext.text += "Req2: " + InventoryItem.invToString(Owner.currentRecipe.inputType2) + "\n";
		}
	}
}