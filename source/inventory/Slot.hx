package inventory;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author 
 */
class Slot extends FlxGroup
{

	public var id:String;		
	public var item:InventoryItem;
	
	public var x:Float;
	public var y:Float;
	
	var txt:FlxText;
	var bg:FlxSprite;
	
	public function new(Id:String,X:Float,Y:Float) 
	{
		super();
		id = Id;
		x = X;
		y = Y;
		
		bg = new FlxSprite(x, y);
		bg.makeGraphic(GC.tileSize*2, GC.tileSize*2, 0x33333333);
		FlxSpriteUtil.drawRect(bg, 0, 0, GC.tileSize*2 - 1, GC.tileSize*2 - 1, 0x33333333, { thickness: 1, color: FlxColor.WHITE });
		add(bg);
		
		txt = new FlxText(x, y, 50, id);
		add(txt);
		
		
		
	}
	public function rePositionItem():Void
	{
		if (item != null)
		{
			item.y = y + GC.tileSize;
		}
	}
	public function addItem(Item:InventoryItem):Void
	{
		item = Item;
		item.x = x+GC.tileSize;
		item.y = y+GC.tileSize;
		add(item);
		item.scrollFactor.set(0, 0);
	}
	
	public function removeItem():Void
	{
		remove(item);
		item = null;		
	}
	public function hasItem():Bool
	{
		if (item == null)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
}