package hud;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

/**
 * ...
 * @author Simon Larsen
 */

class HudText extends FlxGroup
{
	private var _bg:FlxSprite;
	private var _shownMoney:Float;
	public var textMoney:FlxText;
	public var textTime:FlxText;
	public var textStockCap:FlxText;
	public var testStatusText:FlxText;

	public function new() 
	{
		super();
		create();
	}
	
	public function create() 
	{
		_shownMoney = Accountant.money;

		var dynX= 250;
		var dynY = 6;		
		
		textMoney = new FlxText(dynX, dynY, 120, "0");
		//textMoney.setFormat(null, 16, 0xd8eba2, "right", 0x131c1b);		
		add(textMoney);
		
		dynX += 50;
		
		textTime = new FlxText(dynX, dynY, 90, "x");
		textTime.setFormat(null, 8, 0xd8eba2, "left", 0x131c1b);		
		add(textTime);
				
		dynX += 100;
		
		textStockCap = new FlxText(dynX, dynY, 150, "-");
		textStockCap.setFormat(null, 8, 0x999999, "left", 0);		
		add(textStockCap);
			
		dynX += 100;
		
		testStatusText = new FlxText(dynX, dynY, 120, "-");
		testStatusText.setFormat(null, 8, 0x999999, "left", 0);		
		add(testStatusText);
		
				
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (Accountant.money > _shownMoney) {
			if ((Accountant.money - _shownMoney) / 10 > 2 )
			{
				_shownMoney += 10;
			} else {
				_shownMoney += 1;
			}
		} else if (Accountant.money < _shownMoney) {
			if ((_shownMoney - Accountant.money) / 10 > 2 )
			{
				_shownMoney -= 10;
			} else {
				_shownMoney -= 1;
			}			
		}
		textMoney.text = "" + _shownMoney;
		textTime.text = "M" + Accountant.monthCount + " W" + Accountant.weekCount + " D" + Accountant.dayCount + " H" + Accountant.hourCount + "";
		
		textStockCap.text = "Capacity: " + (Accountant.stockCurrent) +"/"+ Accountant.stockCapacity;			
	}
	
	
	
}

