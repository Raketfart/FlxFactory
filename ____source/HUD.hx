package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxPoint;

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
		
	
	public var hudbg:FlxSprite;
	
	public function new(State:PlayState) 
	{
		super();
		
		_state = State;
		hudbg = new FlxSprite(0, 0);		
		add(hudbg);
		//hudbg.scrollFactor = new FlxPoint(0, 0);
		
		var buttonspace:Float = 4;
		var nextpositionX:Float = buttonspace;
		
		_cambutton = new FlxButton(nextpositionX, 6, "CAM", onCam); 		
		add(_cambutton);
		
		nextpositionX += _cambutton.width + buttonspace;
		
		_resetButton = new FlxButton(nextpositionX, 6, "Reset", onReset); 
		add(_resetButton);
		
		nextpositionX += _cambutton.width + buttonspace;
		
		var _btn1:FlxButton = new FlxButton(nextpositionX, 6, "Generate1", onBtn1);
		add(_btn1);
		
		nextpositionX += _cambutton.width + buttonspace;
		
		var _btn2:FlxButton = new FlxButton(nextpositionX,6, "Generate2", onBtn2);
		add(_btn2);
		
		nextpositionX += _cambutton.width + buttonspace;
		
		_helperText = new FlxText(nextpositionX , 8, 220, "Click to place tiles, shift-click to remove\nArrow keys / WASD to move");
		add(_helperText);
		
		nextpositionX += _helperText.width + buttonspace;
		hudbg.makeGraphic(Std.int(nextpositionX), 30, 0xffFF00FF);
		
		//this.setAll("scrollFactor", new FlxPoint(0, 0));
		
	}
	
	private function onCam():Void
	{
		_state.switchCam();
		
	}
	
	private function onReset():Void
	{
		_state.resetGame();
		
	}
	private function onBtn1():Void
	{
		_state.mapGen1();
	}
	private function onBtn2():Void
	{
		_state.mapGen2();
	}
	
}