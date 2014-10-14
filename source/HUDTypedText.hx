package ;
import flixel.addons.text.FlxTypeText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

/**
 * ...
 * @author 
 */
class HUDTypedText extends FlxGroup
{
	var _typeText:FlxTypeText;
	var _status:FlxTypeText;

	override public function new():Void
	{
		super();
		
		//FlxG.cameras.bgColor = 0xff131c1b;
		
		var square:FlxSprite = new FlxSprite(10, 40);
		square.makeGraphic(FlxG.width - 20, 200, 0xff333333);
		
		_typeText = new FlxTypeText(15, 40, FlxG.width - 30, "Hello, and welcome to ROBOTRONIC", 16, true);
		
		_typeText.delay = 0.1;
		_typeText.showCursor = true;
		_typeText.cursorBlinkSpeed = 1.0;
		_typeText.prefix = "C:/ROBOTRONIC/ ";		
		_typeText.setTypingVariation(0.75, true);
		_typeText.useDefaultSound = true;
		_typeText.color = 0x8811EE11;
		_typeText.skipKeys = ["SPACE"];
		
		_status = new FlxTypeText(15, 190, FlxG.width - 20, "None", 16);
		_status.color = 0x8800AA00;
		_status.prefix = "Status: ";
		
		var effect:FlxSprite = new FlxSprite(10, 40);
		var bitmapdata:BitmapData = new BitmapData(FlxG.width - 20, 200, true, 0x88114411);
		var scanline:BitmapData = new BitmapData(FlxG.width - 20, 1, true, 0x88001100);
		
		for (i in 0...bitmapdata.height)
		{
			if (i % 2 == 0)
			{
				bitmapdata.draw(scanline, new Matrix(1, 0, 0, 1, 0, i));
			}
		}
		
		// round corners		
		var cX:Array<Int> = [5, 3, 2, 2, 1];
		var cY:Array<Int> = [1, 2, 2, 3, 5];
		var w:Int = bitmapdata.width;
		var h:Int = bitmapdata.height;
		
		for (i in 0...5)
		{
			bitmapdata.fillRect(new Rectangle(0, 0, cX[i], cY[i]), 0xff131c1b);
			bitmapdata.fillRect(new Rectangle(w-cX[i], 0, cX[i], cY[i]), 0xff131c1b);
			bitmapdata.fillRect(new Rectangle(0, h-cY[i], cX[i], cY[i]), 0xff131c1b);
			bitmapdata.fillRect(new Rectangle(w-cX[i], h-cY[i], cX[i], cY[i]), 0xff131c1b);
		}
		
		effect.loadGraphic(bitmapdata);
		
		add(square);
		add(_typeText);
		add(_status);
		add(effect);
		
		_typeText.start(0.02, false, false, null, null, onComplete, ["SPACE TO CLOSE"]);
		
	}
	private function onComplete(Text:String):Void
	{
		_status.resetText(Text);
		_status.start(null, true);
	}
	
}