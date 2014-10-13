package flixel.plugin;

import flash.display.Graphics;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.text.TempestaSeven;
import flixel.util.FlxColorUtil;
import flixel.util.FlxSpriteUtil;

/**
 * A plugin for easily drawing simple shapes on the visual debug screen.
 * @author Pekka Heikkinen
 */
class VisualDebug extends FlxPlugin
{
	
	/**
	 * The color that is used if the color provided equals -1
	 */
	public static var defaultColor:Int = 0xffffffff;
	
	private static var ShapeStack:Array<Shapes>;
	private static var VisualDebugInstance:VisualDebug;
	
	public function new() 
	{
		super();
		ShapeStack = new Array<Shapes>();
		VisualDebugInstance = this;
		active = false;
	}
	
	private static inline function initialize():Void
	{
		if (VisualDebugInstance == null)
		{
			FlxG.plugins.add(new VisualDebug());
		}
	}
	
	private inline function add(Sh:Shapes):Void
	{
		ShapeStack.push(Sh);
	}
	
	/**
	 * Clean up memory.
	 */
	#if !FLX_NO_DEBUG
	override public function destroy():Void
	{
		ShapeStack = null;
		super.destroy();
	}
	#end
	
	/**
	 * Drawing methods
	 */
	#if !FLX_NO_DEBUG
	override public function drawDebugOnCamera(?Camera:FlxCamera):Void
	{
		if (Camera == null)
		{
			Camera = FlxG.camera;
		}
		
		#if flash
		var gfx:Graphics = FlxSpriteUtil.flashGfx;
		gfx.clear();
		#else
		var gfx:Graphics = Camera._debugLayer.graphics;
		#end
		
		var copy:Array<Shapes> = ShapeStack.copy();
		ShapeStack = new Array<Shapes>();
		
		var s:Shapes = copy.shift();
		while(s != null)
		{
			switch (s)
			{
				case POINT(x, y, size, color, age):
					var screenX:Float = x - Camera.scroll.x;
					var screenY:Float = y - Camera.scroll.y;
					age -= FlxG.elapsed;
					var offset:Float = size/2;
					gfx.beginFill(color, 0.5);
					gfx.lineStyle(1, color);
					gfx.drawRect(screenX - offset, screenY - offset, size, size);
					gfx.endFill();
					if (age > 0) add(POINT(x, y, size, color, age));
				case DOT(x, y, size, color, age):
					var screenX:Float = x - Camera.scroll.x;
					var screenY:Float = y - Camera.scroll.y;
					age -= FlxG.elapsed;
					var offset:Float = size/2;
					gfx.beginFill(color, 0.5);
					gfx.lineStyle(1, color);
					gfx.drawCircle(screenX, screenY, size);
					gfx.endFill();
					if (age > 0) add(POINT(x, y, size, color, age));
				case CROSS(x, y, size, color, age):
					var screenX:Float = Math.ffloor( x - Camera.scroll.x )+0.01;
					var screenY:Float = y - Camera.scroll.y;
					age -= FlxG.elapsed;
					gfx.beginFill(color);
					gfx.lineStyle();
					gfx.drawRect(screenX - size, screenY, size, 1);
					gfx.drawRect(screenX, screenY - size, 1, size);
					gfx.drawRect(screenX + 1, screenY, size, 1);
					gfx.drawRect(screenX, screenY + 1, 1, size);
					gfx.endFill();
					if (age > 0) add(CROSS(x, y, size, color, age));
				case TEXT(x, y, text, age):
					var screenX:Float = x - Camera.scroll.x;
					var screenY:Float = y - Camera.scroll.y;
					age -= FlxG.elapsed;
					gfx.lineStyle();
					TempestaSeven.render(text, gfx, screenX, screenY);
					if (age > 0) add(TEXT(x, y, text, age));
				case RECT(x, y, w, h, color, opacity, age):
					var screenX:Float = Math.ffloor( x - Camera.scroll.x )+0.01;
					var screenY:Float = y - Camera.scroll.y;
					age -= FlxG.elapsed;
					gfx.beginFill(color, opacity);
					gfx.lineStyle(1, color);
					gfx.drawRect(screenX, screenY, w, h);
					gfx.endFill();
					if (age > 0) add(RECT(x, y, w, h, color, opacity, age));
				case LINE(x, y, x2, y2, color, age):
					var screenX:Float = x - Camera.scroll.x;
					var screenY:Float = y - Camera.scroll.y;
					var screenX2:Float = x2 - Camera.scroll.x;
					var screenY2:Float = y2 - Camera.scroll.y;
					age -= FlxG.elapsed;
					if (x != x2 && y != y2)
					{
						gfx.lineStyle(1, color);
						gfx.moveTo(screenX, screenY);
						gfx.lineTo(screenX2, screenY2);
					}
					else
					{
						gfx.lineStyle();
						gfx.beginFill(color);
						if (x == x2)
						{
							gfx.drawRect(screenX, screenY, 1, screenY2 - screenY);
						}
						else
						{
							gfx.drawRect(screenX, screenY, screenX2-screenX, 1);
						}
						gfx.endFill();
					}
					if (age > 0) add(LINE(x, y, x2, y2, color, age));
			}
			s = copy.shift();
		}
		
		#if flash
		Camera.buffer.draw(FlxSpriteUtil.flashGfxSprite);
		#end
	}
	#end
	
	/**
	 * Draw a point on screen
	 * @param	X	The X coordinate in world space
	 * @param	Y	The Y coordinate in world space
	 * @param	Diameter	The size of the shape
	 * @param	Color	Color of the shape. Compatible with FlxColor values
	 * @param	Print	Whether to print the coordinates next to the point
	 * @param	Age		How long in seconds the shape should stay on screen
	 */
	public static inline function drawPoint(X:Float, Y:Float, Diameter:Int = 4, Color:Int = -1, Print:Bool = false, Age:Float = 0):Void
	{
		#if !FLX_NO_DEBUG
		initialize();
		if (FlxG.debugger.visualDebug && !VisualDebugInstance.ignoreDrawDebug)
		{
			if (Color == -1) Color = defaultColor;
			VisualDebugInstance.add(POINT(X, Y, Diameter, FlxColorUtil.RGBAtoRGB(Color), Age));
			if (Print)
			{
				X = Math.ffloor(X);
				Y = Math.ffloor(Y);
				VisualDebugInstance.add(TEXT(X + (Diameter/2)+2, Y - 14, 'X:$X Y:$Y', Age));
			}
		}
		#end
	}
	
	/**
	 * Draw a cross on screen
	 * @param	X	The X coordinate in world space
	 * @param	Y	The Y coordinate in world space
	 * @param	Radius	The size of the shape
	 * @param	Color	Color of the shape. Compatible with FlxColor values.
	 * @param	Print	Whether to print the coordinates next to the cross
	 * @param	Age		How long in seconds the shape should stay on screen
	 */
	public static inline function drawCross(X:Float, Y:Float, Radius:Int = 4, Color:Int = -1, Print:Bool = false, Age:Float = 0):Void
	{
		#if !FLX_NO_DEBUG
		initialize();
		if (FlxG.debugger.visualDebug && !VisualDebugInstance.ignoreDrawDebug)
		{
			if (Color == -1) Color = defaultColor;
			VisualDebugInstance.add(CROSS(X, Y, Radius, FlxColorUtil.RGBAtoRGB(Color), Age));
			if (Print)
			{
				X = Math.ffloor(X);
				Y = Math.ffloor(Y);
				VisualDebugInstance.add(TEXT(X + 3, Y - 12, 'X:$X Y:$Y', Age));
			}
		}
		#end
	}
	
	/**
	 * Prints text on screen
	 * @param	X	The X coordinate in world space
	 * @param	Y	The Y coordinate in world space
	 * @param	Text	The text to print out
	 * @param	Age		How long in seconds the shape should stay on screen
	 */
	public static inline function drawText(X:Float, Y:Float, Text:String, Age:Float = 0):Void
	{
		#if !FLX_NO_DEBUG
		initialize();
		if (FlxG.debugger.visualDebug && !VisualDebugInstance.ignoreDrawDebug)
		{
			VisualDebugInstance.add(TEXT(X, Y, Text, Age));
		}
		#end
	}
	
	/**
	 * Draw a rectangle on screen
	 * @param	X	The X coordinate in world space
	 * @param	Y	The Y coordinate in world space
	 * @param	Width	Width of the rectangle
	 * @param	Height	Height of the rectangle
	 * @param	Color	Color of the shape. Compatible with FlxColor values.
	 * @param	Opacity	The opacity of the fill
	 * @param	Print	Text to print above the rectangle
	 * @param	Age		How long in seconds the shape should stay on screen
	 */
	public static inline function drawRect(X:Float, Y:Float, Width:Float, Height:Float, Color:Int = -1, Opacity:Float = 0.5, Print:String = null, Age:Float = 0):Void
	{
		#if !FLX_NO_DEBUG
		initialize();
		if (FlxG.debugger.visualDebug && !VisualDebugInstance.ignoreDrawDebug)
		{
			if (Color == -1) Color = defaultColor;
			VisualDebugInstance.add(RECT(X, Y, Width, Height, FlxColorUtil.RGBAtoRGB(Color), Opacity, Age));
			
			if (Print != null)
			{
				VisualDebugInstance.add(TEXT(X, Y - 14, Print, Age));
			}
		}
		#end
	}
	
	/**
	 * Draw a line on screen
	 * @param	StartX	Starting X coordinate in world space
	 * @param	StartY	Starting Y coordinate in world space
	 * @param	EndX	Ending X coordinate in world space
	 * @param	EndY	Ending Y coordinate in world space
	 * @param	Color	Color of the line. Compatible with FlxColor values.
	 * @param	Age		How long in seconds the shape should stay on screen
	 */
	public static inline function drawLine(StartX:Float, StartY:Float, EndX:Float, EndY:Float, Color:Int = -1, Age:Float = 0)
	{
		#if !FLX_NO_DEBUG
		initialize();
		if (FlxG.debugger.visualDebug && !VisualDebugInstance.ignoreDrawDebug)
		{
			if (Color == -1) Color = defaultColor;			
			VisualDebugInstance.add(LINE(StartX, StartY, EndX, EndY, FlxColorUtil.RGBAtoRGB(Color), Age));
		}
		#end
	}
	
	public static inline function drawDot(X:Float, Y:Float, Diameter:Int = 2, Color:Int = -1, Print:Bool = false, Age:Float = 0):Void
	{
		#if !FLX_NO_DEBUG
		initialize();
		if (FlxG.debugger.visualDebug && !VisualDebugInstance.ignoreDrawDebug)
		{
			if (Color == -1) Color = defaultColor;
			
			VisualDebugInstance.add(DOT(X, Y, Diameter, FlxColorUtil.RGBAtoRGB(Color), Age));
			
			if (Print)
			{
				X = Math.ffloor(X);
				Y = Math.ffloor(Y);
				VisualDebugInstance.add(TEXT(X + (Diameter/2)+2, Y - 14, 'X:${Math.ffloor(X)} Y:${Math.ffloor(Y)}', Age));
			}
		}
		#end
	}
	
	/**
	 * Draws an animated hilight around object
	 * @param	Object	FlxSprite object to hilight
	 * @param	Length	Length of the hilight edge
	 * @param	Color	Color of the line. Compatible with FlxColor values.
	 */
	public static inline function hilight(Object:FlxObject, Length:Int = 4, Color:Int = -1):Void
	{
		#if !FLX_NO_DEBUG
		initialize();
		if (FlxG.debugger.visualDebug && !VisualDebugInstance.ignoreDrawDebug)
		{
			if (Color == -1) Color = defaultColor;
			Color = FlxColorUtil.RGBAtoRGB(Color);
			
			var x1:Int = Std.int(Object.x);
			var y1:Int = Std.int(Object.y);
			var x2:Int = Std.int(Object.x+Object.width);
			var y2:Int = Std.int(Object.y+Object.height);
			
			var offset:Int = 2 + (Date.now().getSeconds() % 2);
			
			VisualDebugInstance.add(LINE( x1 - offset, y1 - offset, x1 - offset, y1 - offset + Length, Color, 0 ));
			VisualDebugInstance.add(LINE( x1 - offset, y1 - offset, x1 - offset + Length, y1 - offset, Color, 0 ));
			
			VisualDebugInstance.add(LINE( x1 - offset, y2 + offset, x1 - offset, y2 + offset - Length + 1, Color, 0 ));
			VisualDebugInstance.add(LINE( x1 - offset, y2 + offset, x1 - offset + Length, y2 + offset, Color, 0 ));
			
			VisualDebugInstance.add(LINE( x2 + offset, y1 - offset, x2 + offset, y1 - offset + Length, Color, 0 ));
			VisualDebugInstance.add(LINE( x2 + offset, y1 - offset, x2 + offset - Length + 1, y1 - offset, Color, 0 ));
			
			VisualDebugInstance.add(LINE( x2 + offset, y2 + offset+1, x2 + offset, y2 + offset - Length + 1, Color, 0 ));
			VisualDebugInstance.add(LINE( x2 + offset, y2 + offset, x2 + offset - Length + 1, y2 + offset, Color, 0 ));
		}
		#end
	}
	
}

enum Shapes
{
	POINT(x:Float, y:Float, size:Float, color:Int, age:Float);
	CROSS(x:Float, y:Float, size:Float, color:Int, age:Float);
	TEXT(x:Float, y:Float, text:String, age:Float);
	RECT(x:Float, y:Float, w:Float, h:Float, color:Int, opacity:Float, age:Float);
	LINE(x:Float, y:Float, x2:Float, y2:Float, color:Int, age:Float);
	DOT(x:Float, y:Float, size:Float, color:Int, age:Float);
}