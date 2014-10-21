package hud;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
import machine.Machine;

/**
 * ...
 * @author 
 */
class MachineWindow extends FlxGroup
{
	var _machine:Machine;
	var _hud:HUD;
	var bg1:FlxSprite;
	
	public function new(hud:HUD,machine:Machine) 
	{
		_machine = machine;
		_hud = hud;
		
		super();
		
		bg1 = new FlxSprite(200, 200);
		bg1.makeGraphic(100, 200, 0xff000000);
		add(bg1);
		
		var btn1:FlxButton = new FlxButton(210,210, "Turn on", onTurnOn);
		add(btn1);
		var btn1:FlxButton = new FlxButton(210,240, "Close", onClose);
		add(btn1);
		
		this.setAll("scrollFactor", new FlxPoint(0, 0));
	}
	override public function update():Void
	{
		super.update();
		if (FlxG.keys.justPressed.SPACE)
		{
			_machine.turnOn();
			//_hud.remove(this);
			this.destroy();
		}
		
	}
	private function onTurnOn():Void
	{
		_machine.turnOn();
	}
	private function onClose():Void
	{
		_hud.remove(this);
		this.destroy();
	}
}