package hud;
import flixel.addons.ui.FlxButtonPlus;
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
	public var gaugebg:FlxSprite;
	public var gaugeArrow:FlxSprite;
	public var powerButton:FlipButton;
	
	public var screentext:FlxText;
	
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
		
		
		lamp1 = createlamp(bg1.width-101,10);
		_elements.add(lamp1);
		
		lamp2 = createlamp(bg1.width-71,10);
		_elements.add(lamp2);
		
		lamp3 = createlamp(bg1.width-41,10);
		_elements.add(lamp3);
		
		var btn1:FlxButton = new FlxButton(10,180, "Close", onClose);
		_elements.add(btn1);
				
		screenbg = new FlxSprite(bg1.width-20-111, 35);
		screenbg.loadGraphic(AssetPaths.mwin_screenlarge__png, false);		
		_elements.add(screenbg);
		
		bootProgressBar = new FlxBar(screenbg.x+10, screenbg.y+10, FlxBar.FILL_LEFT_TO_RIGHT, 90, 16, _machine, "power", 0, 100, true);
		bootProgressBar.createFilledBar(0xff333333, 0x8811EE11, true, 0x8811EE11);
		bootProgressBar.updateFrameData();
		_elements.add(bootProgressBar);
		bootProgressBar.visible = false;
		
		screentext = new FlxText(screenbg.x + 10, screenbg.y + 10, 90, "");
		screentext.setFormat(null, 8, 0xff1d931d,"left");
		_elements.add(screentext);
		
		cogs = new FlxSprite(bg1.width-20-35, screenbg.y+screenbg.height+10);
		cogs.loadGraphic(AssetPaths.mwin_cogs__png, true, 35, 83);		
		cogs.animation.add("stopped", [0], 12, false);
		cogs.animation.add("running", [0,1], 6, true);
		cogs.animation.play("stopped");
		_elements.add(cogs);
		
		gaugebg = new FlxSprite(screenbg.x, screenbg.y + screenbg.height+10);
		gaugebg.loadGraphic(AssetPaths.mwin_gauge_bg__png, false, 55, 22);		
		gaugebg.animation.add("stopped", [0], 1, false);
		gaugebg.animation.add("running", [1], 1, false);
		_elements.add(gaugebg);
		gaugeArrow = new FlxSprite (gaugebg.x-8, gaugebg.y);
		gaugeArrow.loadGraphic(AssetPaths.tiles_item__png, false, 21, 21);
		gaugeArrow.animation.frameIndex = 48;
		_elements.add(gaugeArrow);
		
		createbutton(90, 20, "-", AssetPaths.btn_redpush__png, onFixBreakDown);	
		
		createbutton(90, 60, "fix", AssetPaths.btn_grayplus__png, onFixBreakDown);	
		createbutton(90, 100, "break", AssetPaths.btn_grayminus__png, onBreakDown);	
		
		createbutton(150, 50, "", AssetPaths.btn_arrow_left__png, onTurnOn);	
		createbutton(170, 30, "", AssetPaths.btn_arrow_up__png, onTurnOn);	
		createbutton(190, 50, "", AssetPaths.btn_arrow_right__png, onTurnOn);	
		createbutton(170, 50, "", AssetPaths.btn_arrow_down__png, onTurnOn);	
		
		powerButton = createflipbutton(130, 100, "POWER",AssetPaths.btn_redflip__png, onTurnOn,onTurnOff);	
		
		if (_machine.power == 100)
		{
			initRunning();
		}
		_machine.attachWindow(this);
		
		for (item in _elements.members)		
		{
			item.x += 50;
			item.y += 200;
			FlxTween.tween(item, {  y:item.y-180 }, .3, { ease: FlxEase.expoOut } );
		}
		
		this.setAll("scrollFactor", new FlxPoint(0, 0));
	}
	
	private function initRunning():Void
	{
		gaugeArrow.x = gaugebg.x + FlxRandom.intRanged( 30, 42);
		
	}
	public function moveGauge(on:Bool=false)
	{
		if (on)
		{
			gaugebg.animation.play("running");
		} else {
			gaugebg.animation.play("stopped");
		}
		var max:Float = gaugebg.x+42;
		var min:Float = gaugebg.x+30;
		if (on == false)
		{
			max = min = gaugebg.x-8;
		}
		if (gaugeArrow.x < min)
		{
			gaugeArrow.x += 1;
		}
		else if (gaugeArrow.x > max)
		{
			gaugeArrow.x -= 1;
		}
		else if (max != min) {
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

	private function onTurnOff():Void
	{
		_machine.turnOff();
		
	}
	private function onBreakDown():Void
	{
		_machine.breakDown();
		
	}
	private function onFixBreakDown():Void
	{
		_machine.condition+=5;
		
	}
	private function onClose():Void
	{
		_machine.detachWindow();
		_hud.remove(this);
		this.destroy();
	}
	
	private function createlamp(X:Float,Y:Float):FlxSprite
	{
		var lamp:FlxSprite = new FlxSprite(X, Y);
		lamp.loadGraphic(AssetPaths.tiles_item__png, false, 21, 21);		
		lamp.animation.add("red", [50], 1, false);
		lamp.animation.add("yellow", [51], 1, false);
		lamp.animation.add("green", [52], 1, false);
		lamp.animation.add("black", [53], 1, false);
		lamp.animation.add("flashyellow", [51,53], 3, true);
		return lamp;
	}
	private function createbutton(X:Float,Y:Float,txt:String,graphics:Dynamic,triggerFunk:Dynamic):Void
	{
		var txt:FlxText = new FlxText(X, Y, 0, txt);
		txt.color = FlxColor.BLACK;		
		_elements.add(txt);
		var mBut = new ImageButton(X + (txt.width / 2) - 11, Y + 14, graphics, triggerFunk); 
		_elements.add(mBut);		
	}
	private function createflipbutton(X:Float,Y:Float,txt:String,graphics:Dynamic,triggerFunkOn:Dynamic,triggerFunkOff:Dynamic):FlipButton
	{
		var txt:FlxText = new FlxText(X, Y, 0, txt);
		txt.color = FlxColor.BLACK;		
		_elements.add(txt);
		var mBut:FlipButton = new FlipButton(X + (txt.width / 2) - 11, Y + 14, graphics, triggerFunkOn, triggerFunkOff,(_machine.power > 0)); 
		_elements.add(mBut);
		
		return mBut;
	}
}