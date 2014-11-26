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
			//trace("accept 1 " + invType);
			return true;			
		}
		else if (invType == inventoryType && slotCapacity > itemCount)
		{
			//trace("accept 2 " + invType);
			return true;
		}		
		return false;
	}
	public function addItem(inventoryType:Int,amount:Int = 1):Void
	{		
		if (itemCount > 0)
		{
			itemCount+=amount;
		}
		else if (itemCount == 0)
		{
			invType = inventoryType;			
			itemCount = amount;
		}
		//trace("slot type " + inventoryType + "/" + invType + ". Amount " + itemCount);
	}
	
	public function removeItem(amount:Int=1):Int
	{	
		var returntype:Int = invType;
		if (itemCount >= amount)
		{
			itemCount-= amount;
		}
		if (itemCount == 0)
		{
			invType = -1;
		}
		return returntype;
		//trace("slot type " + invType + ". Amount " + itemCount);
	}
	public function hasItem(inventoryType:Int,amount:Int = 1):Bool
	{
		if (itemCount > 0)
		{
			if (invType == inventoryType && itemCount >= amount)
			{				
					return true;				
			}			
		}
		return false;
	}
}