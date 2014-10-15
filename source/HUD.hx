package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxPoint;
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
	var blendsprite:FlxSprite;
		
	public static var TOOL_DIG = "dig";
	public static var TOOL_DECONSTRUCT = "deconstruct";
	public static var TOOL_BUILD = "build";
	
	public var hudbg:FlxSprite;
	
	public function new(State:PlayState) 
	{
		super();
		
		_state = State;
		
		blendsprite= new FlxSprite(0,0);
		blendsprite.loadGraphic(AssetPaths.blendoverlay__png,false);
		add(blendsprite);
		blendsprite.scale.set(.55, .55);
		blendsprite.setPosition(-250, -160);
		blendsprite.blend = BlendMode.MULTIPLY;
		blendsprite.visible = false;
		
		hudbg = new FlxSprite(0, 0);
		add(hudbg);
		
		var hudbg2:FlxSprite = new FlxSprite(0, 0);
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
		
		//_helperText = new FlxText(nextpositionX , 8, 220, "Click to place tiles, shift-click to remove\nArrow keys / WASD to move");
		
		
		hudbg.makeGraphic(Std.int(nextpositionX)+100, 30, 0xff000000);
		
		_helperText = new FlxText(4, 40, 220, "Tool: dig");
		add(_helperText);
		
		var _tool1:FlxButton = new FlxButton(4,70, "DIG", onTool1);
		add(_tool1);
		var _tool2:FlxButton = new FlxButton(4,100, "DECONSTRUCT", onTool2);
		add(_tool2);
		var _tool3:FlxButton = new FlxButton(4,130, "BUILD", onTool3);
		add(_tool3);
		hudbg2.makeGraphic(100, 200, 0xff000000);
		
		
		
		
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
			blendsprite.visible = false;
		}
		else 
		{
			blendsprite.visible = true;
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
	
	private function onTool1():Void
	{
		GC.currentTool = TOOL_DIG;
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onTool2():Void
	{
		GC.currentTool = TOOL_DECONSTRUCT;
		_helperText.text = "Tool: " + GC.currentTool;
	}
	private function onTool3():Void
	{
		GC.currentTool = TOOL_BUILD;
		_helperText.text = "Tool: " + GC.currentTool;
	}
}