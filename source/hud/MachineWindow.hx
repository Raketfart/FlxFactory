package hud;
import flixel.addons.ui.FlxButtonPlus;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.system.layer.frames.FlxFrame;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import hud.HUDTypedText;
import machine.Machine;

/**
 * ...
 * @author 
 */
class MachineWindow extends FlxGroup
{
	var _machine:Machine;
	var _hud:HUD;
	public var bg1:FlxSprite;
	public var lamp1:FlxSprite;
	public var lamp2:FlxSprite;
	public var lamp3:FlxSprite;
	public var cogs:FlxSprite;
	public var bootProgressBar:FlxBar;
	
	var _elements : FlxTypedGroup<FlxSprite>;	
	var screenbg:FlxSprite;
	var gaugebg:FlxSprite;
	public var gaugeArrow:FlxSprite;
	
	public function new(hud:HUD,machine:Machine) 
	{
		_machine = machine;
		_hud = hud;
				
		super();
		
		_elements = new FlxTypedGroup();
		add(_elements);
		
		bg1 = new FlxSprite(0, 0);
		bg1.loadGraphic(AssetPaths.mwin_bg__png, false);		
		_elements.add(bg1);
		
		/*
		var lamp1:FlxSprite = new FlxSprite(210, 50);
		lamp1.loadGraphic(AssetPaths.tiles__png, false, 21, 21);		
		lamp1.animation.frameIndex = 50;		
		add(lamp1);
		*/
		lamp1 = new FlxSprite(bg1.width-101, 10);
		lamp1.loadGraphic(AssetPaths.tiles__png, false, 21, 21);		
		lamp1.animation.add("red", [50], 1, false);
		lamp1.animation.add("yellow", [51], 1, false);
		lamp1.animation.add("green", [52], 1, false);
		lamp1.animation.add("black", [53], 1, false);
		lamp1.animation.add("flashyellow", [51,53], 3, true);
		_elements.add(lamp1);
		
		lamp2 = new FlxSprite(bg1.width-71, 10);
		lamp2.loadGraphic(AssetPaths.tiles__png, false, 21, 21);		
		lamp2.animation.add("red", [50], 1, false);
		lamp2.animation.add("yellow", [51], 1, false);
		lamp2.animation.add("green", [52], 1, false);
		lamp2.animation.add("black", [53], 1, false);
		lamp2.animation.add("flashyellow", [51,53], 3, true);
		_elements.add(lamp2);
		
		lamp3 = new FlxSprite(bg1.width-41, 10);
		lamp3.loadGraphic(AssetPaths.tiles__png, false, 21, 21);		
		lamp3.animation.add("red", [50], 1, false);
		lamp3.animation.add("yellow", [51], 1, false);
		lamp3.animation.add("green", [52], 1, false);
		lamp3.animation.add("black", [53], 1, false);
		lamp3.animation.add("flashyellow", [51,53], 3, true);
		_elements.add(lamp3);
		
		var btn1:FlxButton = new FlxButton(10,150, "Turn on", onTurnOn);
		_elements.add(btn1);
		var btn1:FlxButton = new FlxButton(10,180, "Close", onClose);
		_elements.add(btn1);
		
		var on:FlxSprite = new FlxSprite (60, 30);
		var off:FlxSprite = new FlxSprite (60, 55);
		on.loadGraphic(AssetPaths.tiles__png, false, 21, 21);
		on.animation.frameIndex = 46;
		off.loadGraphic(AssetPaths.tiles__png, false, 21, 21);
		off.animation.frameIndex = 47;
		_elements.add(on);
		_elements.add(off);
		
		screenbg = new FlxSprite(bg1.width-20-111, 35);
		screenbg.loadGraphic(AssetPaths.mwin_screenlarge__png, false);		
		_elements.add(screenbg);
		
		bootProgressBar = new FlxBar(screenbg.x+10, screenbg.y+10, FlxBar.FILL_LEFT_TO_RIGHT, 90, 16, _machine, "power", 0, 100, true);
		bootProgressBar.createFilledBar(0xff333333, 0x8811EE11, true, 0x8811EE11);
		bootProgressBar.updateFrameData();
		_elements.add(bootProgressBar);
		bootProgressBar.visible = false;
		
		cogs = new FlxSprite(bg1.width-20-35, screenbg.y+screenbg.height+10);
		cogs.loadGraphic(AssetPaths.mwin_cogs__png, true, 35, 83);		
		cogs.animation.add("stopped", [0], 12, false);
		cogs.animation.add("running", [0,1], 6, true);
		cogs.animation.play("stopped");
		_elements.add(cogs);
		
		gaugebg = new FlxSprite(screenbg.x, screenbg.y + screenbg.height+10);
		gaugebg.loadGraphic(AssetPaths.mwin_gauge_bg__png, false);		
		_elements.add(gaugebg);
		gaugeArrow = new FlxSprite (gaugebg.x-8, gaugebg.y);
		gaugeArrow.loadGraphic(AssetPaths.tiles__png, false, 21, 21);
		gaugeArrow.animation.frameIndex = 48;
		_elements.add(gaugeArrow);
		
		//var htt:HUDTypedText = new HUDTypedText();
		//add(htt);
		
		_machine.attachWindow(this);
		
		for (item in _elements.members)		
		{
			item.x += 50;
			item.y += 200;
			FlxTween.tween(item, {  y:item.y-180 }, .3, { ease: FlxEase.expoOut } );
		}
		
		this.setAll("scrollFactor", new FlxPoint(0, 0));
	}
	
	public function moveGauge()
	{
		var max:Float = gaugebg.x+42;
		var min:Float = gaugebg.x+30;
		
		if (gaugeArrow.x < min)
		{
			gaugeArrow.x += 1;
		}
		else if (gaugeArrow.x > max)
		{
			gaugeArrow.x -= 1;
		}
		else {
			gaugeArrow.x += FlxRandom.intRanged( -1, 1);
		}
	}
  
	override public function update():Void
	{
		super.update();
		//this.move(.1*FlxG.elapsed, 0);
		if (FlxG.keys.justPressed.SPACE)
		{
			_machine.turnOn();
			//_hud.remove(this);
			//this.destroy();
		}
		
	}
	private function onTurnOn():Void
	{
		_machine.turnOn();
		
	}
	private function onClose():Void
	{
		_machine.detachWindow();
		_hud.remove(this);
		this.destroy();
	}
	
	
}