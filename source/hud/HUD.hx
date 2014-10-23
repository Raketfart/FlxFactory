package hud ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
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
	//var blendsprite:FlxSprite;
		
	public static var TOOL_DIG = "dig";
	public static var TOOL_DECONSTRUCT = "deconstruct";
	public static var TOOL_BUILD = "build";
	public static var TOOL_CONV_RIGHT = "conv-right";
	public static var TOOL_CONV_LEFT = "conv-left";
	public static var TOOL_MACHINE = "machine";
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
		
		var buttonspace:Float = 4;
		var nextpositionX:Float = buttonspace;
		
		_cambutton = new FlxButton(nextpositionX, 6, "CAM", onCam); 		
		add(_cambutton);
		
		nextpositionX += _cambutton.width + buttonspace;
		
		_resetButton = new FlxButton(nextpositionX, 6, "Reset", onReset); 
		add(_resetButton);
		
		//nextpositionX += _cambutton.width + buttonspace;
		
		//var _btn1:FlxButton = new FlxButton(nextpositionX, 6, "Generate1", onBtn1);
		//add(_btn1);
		
		nextpositionX += _cambutton.width + buttonspace;
		
		var _btn2:FlxButton = new FlxButton(nextpositionX,6, "MapGen Ore", onBtn2);
		add(_btn2);
		
		nextpositionX += _cambutton.width + buttonspace;
		
		var _btn2:FlxButton = new FlxButton(nextpositionX,6, "More machines", onBtn3);
		add(_btn2);
		
		nextpositionX += _cambutton.width + buttonspace;
		var _btn2:FlxButton = new FlxButton(nextpositionX,6, "More crates", onBtn4);
		add(_btn2);
		
		nextpositionX += _cambutton.width + buttonspace;
		//_helperText = new FlxText(nextpositionX , 8, 220, "Click to place tiles, shift-click to remove\nArrow keys / WASD to move");
		
		
		hudbg1.makeGraphic(Std.int(nextpositionX)+100, 30, 0xff000000);
		
		_helperText = new FlxText(4, 40, 220, "Tool: dig");
		add(_helperText);
		
		var _tool1:FlxButton = new FlxButton(4,60, "DIG", onTool1);
		add(_tool1);
		var _tool2:FlxButton = new FlxButton(4,80, "DECONSTRUCT", onTool2);
		add(_tool2);
		var _tool3:FlxButton = new FlxButton(4,100, "BUILD", onTool3);
		add(_tool3);
		var _tool3:FlxButton = new FlxButton(4,120, "ConvRight", onToolCE);
		add(_tool3);
		var _tool3:FlxButton = new FlxButton(4,140, "ConvLeft", onToolCW);
		add(_tool3);
		var _tool4:FlxButton = new FlxButton(4,160, "Machine", onToolMachine);
		add(_tool4);
		var _tool5:FlxButton = new FlxButton(4,180, "Crate", onToolCrate);
		add(_tool5);
		var _tool6:FlxButton = new FlxButton(4,200, "Control", onToolControl);
		add(_tool6);
		hudbg2.makeGraphic(100, 310, 0xff000000);
		
		
		
		
		//htt = new HUDTypedText();
		//add(htt);
		
		GC.currentTool = TOOL_DIG;
		
		this.setAll("scrollFactor", new FlxPoint(0, 0));
		
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
	
	private function onToolMachine():Void
	{
		GC.currentTool = TOOL_MACHINE;
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
}