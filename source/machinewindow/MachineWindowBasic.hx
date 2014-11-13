package machinewindow ;
import flixel.addons.ui.FlxButtonPlus;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.system.layer.frames.FlxFrame;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import hud.FlipButton;
import hud.HUD;
import hud.HUDTypedText;
import machine.Machine;

/**
 * ...
 * @author 
 */
class MachineWindowBasic extends MachineWindow
{
	
	
	public function new(hud:HUD,machine:Machine) 
	{
		
		super(hud,machine);
		
		
		tweenIn();
		
		
		
	}
	override public function initBackgroundElements() 
	{
		
	}
	override public function update():Void
	{
		super.update();
		
		
	}
	
	
	
}