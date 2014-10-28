package hud ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
import hud.HudText;
import machine.Machine;
import openfl.display.BlendMode;


using flixel.util.FlxSpriteUtil;
/**
 * ...
 * @author 
 */
class HUD extends FlxGroup
{
	var _state:PlayState;
	
	var _resetButton:FlxButton;
	var _helperText:FlxText;
	var _cambutton:FlxButton;	
	var htt:HUDTypedText;
	var _debugGrp:FlxGroup;
	var hudtext:HudText;
	//var blendsprite:FlxSprite;
		
	public static var TOOL_DIG = "dig";
	public static var TOOL_DECONSTRUCT = "deconstruct";
	public static var TOOL_BUILD = "build";
	public static var TOOL_CONV_RIGHT = "conv-right";
	public static var TOOL_CONV_LEFT = "conv-left";
	public static var TOOL_CONV_UP = "conv-up";
	public static var TOOL_CONV_DOWN = "conv-down";
	public static var TOOL_MACHINE1 = "machine1";
	public static var TOOL_MACHINE2 = "machine2";
	public static var TOOL_MACHINE3 = "machine3";
	public static var TOOL_MACHINE4 = "machine4";
	
	public static var TOOL_CRATE = "crate";
	public static var TOOL_CONTROL = "control";
	public static var TOOL_WINDOW = "window";
	
	
	
	public var hudbg1:FlxSprite;
	public var hudbg2:FlxSprite;

	
	public function new(State:PlayState) 
	{
		super();
		
		
		
		
		_state = State;
		/*
		blendsprite= new FlxSprite(0,0);
		blendsprite.loadGraphic(AssetPaths.blendoverlay__png,false);
		add(blendsprite);
		blendsprite.scale.set(.55, .55);
		blendsprite.setPosition(-250, -160);
		blendsprite.blend = BlendMode.MULTIPLY;
		blendsprite.visible = false;
		*/
		hudbg1 = new FlxSprite(0, 0);
		add(hudbg1);
		
		hudbg2 = new FlxSprite(0, 0);
		add(hudbg2);
		
		
		_debugGrp = new FlxGroup();
		
		
		var buttonspace:Float = 4;
		var nextpositionX:Float = buttonspace;
		
		_cambutton = new FlxButton(nextpositionX, 6, "CAM", onCam); 		
		add(_cambutton);
		
		nextpositionX = 120;
		
		var debugButton:FlxButton = new FlxButton(nextpositionX, 6, "debug", onToggleDebug); 
		add(debugButton);
		
		var nextpositionY:Float = 6 + debugButton.height;
		
		_resetButton = new FlxButton(nextpositionX, nextpositionY, "Reset", onReset); 
		_debugGrp.add(_resetButton);
		nextpositionY += debugButton.height;
		//nextpositionX += _cambutton.width + buttonspace;
		
		//var _btn1:FlxButton = new FlxButton(nextpositionX, 6, "Generate1", onBtn1);
		//add(_btn1);
		
		//nextpositionX += _cambutton.width + buttonspace;
		
		var _btn2:FlxButton = new FlxButton(nextpositionX,nextpositionY, "MapGen Ore", onBtn2);
		_debugGrp.add(_btn2);
		
		
		
		var _btn2:FlxButton = new FlxButton(nextpositionX,nextpositionY, "More machines", onBtn3);
		_debugGrp.add(_btn2);
		nextpositionY += _btn2.height;
		var _btn2:FlxButton = new FlxButton(nextpositionX,nextpositionY, "More crates", onBtn4);
		_debugGrp.add(_btn2);
		nextpositionY += _btn2.height;
		var _btn2:FlxButton = new FlxButton(nextpositionX,nextpositionY, "Machines On", onBtn5);
		_debugGrp.add(_btn2);
		nextpositionY += _btn2.height;
		var _btn2:FlxButton = new FlxButton(nextpositionX,nextpositionY, "Gamespeed+", onSpeedUp);
		_debugGrp.add(_btn2);
		nextpositionY += _btn2.height;
		var _btn2:FlxButton = new FlxButton(nextpositionX,nextpositionY, "Gamespeed-", onSpeedDown);
		_debugGrp.add(_btn2);
		nextpositionY += _btn2.height;
		var _btn2:FlxButton = new FlxButton(nextpositionX,nextpositionY, "Money+", onMoneyPlus);
		_debugGrp.add(_btn2);
		nextpositionY += _btn2.height;
		var _btn2:FlxButton = new FlxButton(nextpositionX,nextpositionY, "Money-", onMoneyMinus);
		_debugGrp.add(_btn2);
		
		nextpositionX += _cambutton.width + buttonspace;
		//_helperText = new FlxText(nextpositionX , 8, 220, "Click to place tiles, shift-click to remove\nArrow keys / WASD to move");
		
		
		hudbg1.makeGraphic(Std.int(nextpositionX)+100, 30, 0xff000000);
		
		_helperText = new FlxText(4, 35, 220, "Tool: ");
		add(_helperText);
		
		buttonspace = 0;
		nextpositionY = 50;
		
		var _tool1:FlxButton = new FlxButton(4,nextpositionY, "DIG", onTool1);
		add(_tool1);
		nextpositionY += _tool1.height + buttonspace;		
		var _tool2:FlxButton = new FlxButton(4,nextpositionY, "DECONSTRUCT", onTool2);
		add(_tool2);
		nextpositionY += _tool1.height + buttonspace;
		var _tool3:FlxButton = new FlxButton(4,nextpositionY, "BUILD", onTool3);
		add(_tool3);
		nextpositionY += _tool1.height + buttonspace;
		var _tool6:FlxButton = new FlxButton(4,nextpositionY, "Control", onToolControl);
		add(_tool6);
		nextpositionY += _tool1.height + buttonspace;
		var _tool3:FlxButton = new FlxButton(4,nextpositionY, "ConvRight", onToolCE);
		add(_tool3);
		nextpositionY += _tool1.height + buttonspace;
		var _tool3:FlxButton = new FlxButton(4,nextpositionY, "ConvLeft", onToolCW);
		add(_tool3);
		nextpositionY += _tool1.height + buttonspace;
		var _tool3:FlxButton = new FlxButton(4,nextpositionY, "ConvUp", onToolCU);
		add(_tool3);
		nextpositionY += _tool1.height + buttonspace;
		var _tool3:FlxButton = new FlxButton(4,nextpositionY, "ConvDown", onToolCD);
		add(_tool3);
		nextpositionY += _tool1.height + buttonspace;
		var _tool4:FlxButton = new FlxButton(4,nextpositionY, "Machine", onToolMachine1);
		add(_tool4);
		nextpositionY += _tool1.height + buttonspace;
		var _tool4:FlxButton = new FlxButton(4,nextpositionY, "MachineDig", onToolMachine2);
		add(_tool4);
		nextpositionY += _tool1.height + buttonspace;
		var _tool4:FlxButton = new FlxButton(4,nextpositionY, "MachineStamp", onToolMachine3);
		add(_tool4);
		nextpositionY += _tool1.height + buttonspace;
		var _tool4:FlxButton = new FlxButton(4,nextpositionY, "MachineSmelt", onToolMachine4);
		add(_tool4);
		nextpositionY += _tool1.height + buttonspace;
		var _tool5:FlxButton = new FlxButton(4,nextpositionY, "Crate", onToolCrate);
		add(_tool5);
		nextpositionY += _tool1.height + buttonspace;
		
		
		hudbg2.makeGraphic(100, 310, 0xff000000);
		
		hudtext = new HudText();
		add(hudtext);
		
		add(_debugGrp);
		onToggleDebug();
			
		//htt = new HUDTypedText();
		//add(htt);
		
		//_debugGrp.setAll("x", -10);
		
		//GC.currentTool = TOOL_DIG;
		
		this.setAll("scrollFactor", new FlxPoint(0, 0));
		_debugGrp.setAll("scrollFactor", new FlxPoint(0, 0));
		hudtext.setAll("scrollFactor", new FlxPoint(0, 0));
	}
	
	
	override public function update():Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			//htt.visible = false;
		}
		super.update();
	}
	private function onCam():Void
	{
		_state.switchCam();
		if (FlxG.camera.zoom == 1)
		{
			//blendsprite.visible = false;
		}
		else 
		{
			//blendsprite.visible = true;
		}
		
	}
	private function onToggleDebug():Void
	{
		if (_debugGrp.visible == true)
		{
			_debugGrp.visible = false;
			_debugGrp.setAll("x", -200);
		}
		else
		{
			_debugGrp.setAll("x", 120);
			_debugGrp.visible = true;
		}
	}
	
	
	
	private function onReset():Void
	{
		_state.resetGame();
		
	}
	private function onBtn1():Void
	{
		//_state.mapGen1();
	}
	private function onBtn2():Void
	{
		_state.mapGen2();
	}
	private function onBtn3():Void
	{
		_state.machineController.setupTestMachines();
	}
	private function onBtn4():Void
	{
		_state.machineController.setupMoreCrates();
	}
	private function onBtn5():Void
	{
		_state.machineController.turnOnMachines();
	}
	private function onTool1():Void
	{
		GC.currentTool = TOOL_DIG;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onTool2():Void
	{
		GC.currentTool = TOOL_DECONSTRUCT;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onTool3():Void
	{
		GC.currentTool = TOOL_BUILD;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onToolCW():Void
	{
		GC.currentTool = TOOL_CONV_LEFT;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onToolCE():Void
	{
		GC.currentTool = TOOL_CONV_RIGHT;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onToolCU():Void
	{
		GC.currentTool = TOOL_CONV_UP;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onToolCD():Void
	{
		GC.currentTool = TOOL_CONV_DOWN;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onToolMachine1():Void
	{
		GC.currentTool = TOOL_MACHINE1;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onToolMachine2():Void
	{
		GC.currentTool = TOOL_MACHINE2;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onToolMachine3():Void
	{
		GC.currentTool = TOOL_MACHINE3;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onToolMachine4():Void
	{
		GC.currentTool = TOOL_MACHINE4;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	function onToolCrate():Void
	{
		GC.currentTool = TOOL_CRATE;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	function onToolControl():Void
	{
		GC.currentTool = TOOL_CONTROL;
		_state.mouseController.changeTool(GC.currentTool);
		_helperText.text = "Tool: " + GC.currentTool;
	}
	public function showMachineWindow(machine:Machine)
	{
		var mw:MachineWindow = new MachineWindow(this,machine);
		add(mw);
		
		
	}
	function onSpeedUp():Void
	{
		GC.gamespeed += 1;
	}
	function onSpeedDown():Void
	{
		GC.gamespeed -= 1;
	}
	function onMoneyPlus():Void
	{
		Accountant.moneyGain(1000);
	}
	function onMoneyMinus():Void
	{
		Accountant.moneyLose(100);
	}
	
}