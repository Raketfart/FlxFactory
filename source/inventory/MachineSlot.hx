package inventory;

/**
 * ...
 * @author 
 */
class MachineSlot
{

	public var id:String;		
	public var invType:Int;
	public var itemCount:Int;
	private var slotCapacity:Int = 5;
	
	
	public function new() 
	{
		
		itemCount = 0;
		invType = -1;
	}
	
	public function willAccept(inventoryType:Int):Bool
	{
		if (invType == -1)
		{
			return true;
		}
		else if (invType == inventoryType && slotCapacity > itemCount)
		{
			return true;
		}		
		return false;
	}
	public function addItem(inventoryType:Int):Void
	{		
		if (itemCount > 0)
		{
			itemCount++;
		}
		else if (itemCount == 0)
		{
			invType = inventoryType;			
			itemCount++;
		}
		//trace("slot type " + inventoryType + ". Amount " + itemCount);
	}
	
	public function removeItem():Int
	{	
		var returntype:Int = invType;
		if (itemCount > 1)
		{
			itemCount--;
		}
		else if (itemCount == 1)
		{
			itemCount = 0;			
			invType = -1;
		}
		return returntype;
		//trace("slot type " + invType + ". Amount " + itemCount);
	}
	public function hasItem(inventoryType:Int):Bool
	{
		if (itemCount > 0)
		{
			if (invType == inventoryType)
			{
				return true;
			}			
		}
		return false;
	}
}