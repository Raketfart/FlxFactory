package classes;

/**
 * ...
 * @author 
 */
class TileRect
{
	public var tileX:Int;
	public var tileY:Int;
	public var tileW:Int;
	public var tileH:Int;
	
	public function new(TileX:Int,TileY:Int,TileW:Int,TileH:Int) 
	{
		tileX = TileX;
		tileY = TileY;
		tileW = TileW;
		tileH = TileH;
	}
	
	public function containsTile(X:Int, Y:Int):Bool
	{
		if (X >= tileX && X < tileX + tileW && Y >= tileY && Y <= tileY + tileH)
		{
			return true;
		}
		return false;
	}
	
}