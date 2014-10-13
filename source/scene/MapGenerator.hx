package scene;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import util.TilePos;

/**
 * ...
 * @author 
 */
class MapGenerator
{

	public static function generateWorld(map:FlxTilemap):Void
	{
		var dirtbeginsrow:Int = 10;
		
		for (i in 1...map.widthInTiles-1) {
			map.setTile(i, dirtbeginsrow, TileType.TYPE_DIRT_GRASS);			
		}
		for (iy in dirtbeginsrow+1...map.heightInTiles-1) {
			for (ix in 1...map.widthInTiles-1) {
				map.setTile(ix,iy, TileType.TYPE_DIRT_SOLID);			
			}
		}		
	}
	
	public static function generateCoal(map:FlxTilemap):Void
	{
		var coalBeginRow:Int = 12;
		var coalEndRow:Int = 14;
		//var rnd:FlxRandom = new FlxRandom();
		var coalSeeds:Int = FlxRandom.intRanged(1, 20);		
		
		for (i in 1 ... coalSeeds) {
			var coalLocX:Int = FlxRandom.intRanged(1,  map.widthInTiles - 2);
			var coalLocY:Int = FlxRandom.intRanged(coalBeginRow, coalEndRow);
			var pos:TilePos = new TilePos(coalLocX,coalLocY);
			
			map.setTile(pos.tileX,pos.tileY, TileType.TYPE_ICE_SOLID);						
		}
		
	}
	
	
}