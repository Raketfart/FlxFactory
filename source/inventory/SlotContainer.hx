package inventory;
import flixel.FlxG;
import flixel.group.FlxGroup;

/**
 * ...
 * @author 
 */
class SlotContainer extends FlxGroup
{

	var _slots:Array<Slot>;
	var _paddingVertically:Int = 5;
	var _paddingHorizontally:Int = 5; 
	var _numberOfSlots:Int;
	var _numberOfColumns:Int;
	var x:Float;
	var y:Float;
	
	public function new(NumberOfSlots:Int, NumberOfColumns:Int,X:Float,Y:Float) 
	{
		super();
		
		_numberOfSlots = NumberOfSlots;
		_numberOfColumns = NumberOfColumns;
		x = X;
		y = Y;
		
		_slots = [];
		var tempSlot:Slot;					
		var currentColumn:Int = 0;			
		var currentRow:Int = 0;			
		var currentSlots:Int = 0;
		var slotWidth:Int = GC.tileSize*2;
		
		for (i in 0..._numberOfSlots)
		{
			var newId:String = "i" + Std.int(i + 1);
			var slotx:Float = x + (_paddingHorizontally + slotWidth) * currentColumn;
			var sloty:Float = y + (_paddingVertically + slotWidth) * currentRow;
			tempSlot = new Slot(newId,slotx,sloty);			
			add(tempSlot);
			_slots.push(tempSlot);
			
			currentColumn++;
			if (currentColumn == _numberOfColumns)
			{
				currentRow++;
				currentColumn = 0;
			}
		}
	}
	public function stickToBottom(BottomY:Float):Void
	{
		this.setAll("y", BottomY-GC.tileSize*2-10);
		for (slot in _slots)
		{
			slot.y = BottomY - GC.tileSize * 2 - 10;
			slot.rePositionItem();
		}
	}
	public function addItem(item:InventoryItem, scrollFactor:Int = 1):Void
	{
		for (slot in _slots)
		{
			if (slot.willAccept(item))
			{
				slot.addItem(item,scrollFactor);
				break;
			}
		}
		
	}
	
	public function removeItem(item:InventoryItem):Void
	{
		for (slot in _slots)
		{
			if (slot.hasItem(item))
			{
				slot.removeItem();
				break;
			}
		}
	}
	
}