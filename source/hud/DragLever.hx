package hud;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class DragLever extends FlxGroup
{
	var sliderbg:FlxSprite;
	var sliderhandle:FlxSprite;
	public var firstValue:Float = 0;
	public var lastValue:Float = 100;
	public var multiplier:Float = 1;
	public var currentValue:Float = 0;
	
	var maxY:Float = 2;
	var minY:Float = 31;
	var pixelsPerPercent:Float;
	
	public var handleBaseY:Int;
	
	var dragging:Bool = false;
	var draggingY:Float = 0;
	var draggingStartValue:Float = 0;
	
	public function new(_elements:FlxTypedGroup<FlxSprite>, x:Int, y:Int, firstVal:Float = 0, lastVal:Float = 100, currentVal:Float = 100 ) 
	{
		super();
		
		pixelsPerPercent = (minY - maxY) / 100;
		
		firstValue = firstVal;
		lastValue = lastVal;
		currentValue = currentVal;
		multiplier = (lastValue-firstValue) / 100;
				
		
		handleBaseY = y;		
		sliderbg = new FlxSprite(x, handleBaseY, AssetPaths.slider_bg__png);
		_elements.add(sliderbg);
		
		sliderhandle = new FlxSprite(x, handleBaseY+minY, AssetPaths.slider_handle__png);
		_elements.add(sliderhandle);
				
		sliderhandle.y = handleBaseY +minY - (((currentValue-firstValue) / multiplier)*pixelsPerPercent);
		
		trace("currentVal" + currentVal + sliderhandle.y);
	}
	
	override public function update():Void
	{
		//trace("currentValue " + currentValue);
		handleBaseY = Std.int(sliderbg.y); //update after tween and window move
		
		if (this.sliderbg.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), true))
		{
			if (FlxG.mouse.justPressed)
			{
				dragging = true;
				draggingY = FlxG.mouse.y;
				draggingStartValue = sliderhandle.y;				
			}				
		}		
		if (dragging && FlxG.mouse.justReleased)
		{
			dragging = false;			
		} else if (dragging)
		{			
			sliderhandle.y = draggingStartValue - (draggingY - FlxG.mouse.y);
			if (sliderhandle.y > handleBaseY + minY) 				
			{
				sliderhandle.y = handleBaseY + minY; 
			}
			if (sliderhandle.y < handleBaseY + maxY) { 
				sliderhandle.y = handleBaseY + maxY; 
			}
			
			currentValue = 100- Std.int((sliderhandle.y-(handleBaseY+maxY)) / pixelsPerPercent);
		}
		//sliderhandle.y = handleBaseY +minY - (((currentValue-firstValue) / multiplier)*pixelsPerPercent);
	}
	
}