package scene;
import flixel.tile.FlxTilemap;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import classes.TilePos;

/**
 * ...
 * @author 
 */
class MapGenerator
{
	static private var _dirtbeginsrow:Int = 15;
	static private var _coalBeginRow:Int = 20;
	static private var _coalEndRow:Int = 25;
	static private var _silverBeginRow:Int = 25;
	static private var _silverEndRow:Int = 30;

		
	public static function generateWorldString(Width:Int,Height:Int):String
	{
		var map:String = "";
		for (iy in 0...Height)
		{
			for (ix in 0...Width)
			{
				var type:Int = TileType.TYPE_EMPTY;
				if (iy == 0 || iy == Height-1) //first row
				{
					type = TileType.TYPE_SOLIDBLACK;
				}
				if (ix == 0) //left column
				{
					map += TileType.TYPE_SOLIDBLACK+",";
				}
				else if (ix == Width-1) //right column
				{
					map += TileType.TYPE_SOLIDBLACK; //no ending comma
				} else {
					map += type+",";
				}
				
			}
			if (iy < Height - 1)
			{
				map += " \n ";
			}
		}
		//add border
		
		//trace(map);
		return map;
	}
	
	
	public static function generateWorld(map:FlxTilemap):Void
	{
		
		
		for (i in 1...map.widthInTiles-1) {
			map.setTile(i, _dirtbeginsrow, TileType.TYPE_DIRT_GRASS);			
		}
		for (iy in _dirtbeginsrow+1...map.heightInTiles-1) {
			for (ix in 1...map.widthInTiles-1) {
				map.setTile(ix,iy, TileType.TYPE_DIRT_SOLID);			
			}
		}		
	}
	
	public static function generateCoal(map:FlxTilemap):Void
	{

		//var rnd:FlxRandom = new FlxRandom();
		var coalSeeds:Int = FlxRandom.intRanged(1, 30);		
		
		for (i in 1 ... coalSeeds) {
			var coalLocX:Int = FlxRandom.intRanged(1,  map.widthInTiles - 2);
			var coalLocY:Int = FlxRandom.intRanged(_coalBeginRow, _coalEndRow);
			var pos:TilePos = new TilePos(coalLocX,coalLocY);
			
			map.setTile(pos.tileX,pos.tileY, TileType.TYPE_DIRT_COAL);						
		}
		
	}
	
	public static function generateSilver(map:FlxTilemap):Void
	{

		var silverSeeds:Int = FlxRandom.intRanged(1, 10);		
		
		for (i in 1 ... silverSeeds) {
			var coalLocX:Int = FlxRandom.intRanged(1,  map.widthInTiles - 2);
			var coalLocY:Int = FlxRandom.intRanged(_silverBeginRow, _silverEndRow);
			var pos:TilePos = new TilePos(coalLocX,coalLocY);
			
			map.setTile(pos.tileX,pos.tileY, TileType.TYPE_DIRT_CLAY);						
		}
		
	}
	
	static public function generateBuilding(map:FlxTilemap, collMap:FlxTilemap):Void
	{
		for (ix in 20...60)
		{
			collMap.setTile(ix, _dirtbeginsrow, TileType.TYPE_DIRT_FLOOR);		
		}
		for (iy in _dirtbeginsrow-4..._dirtbeginsrow) {
			for (ix in 20...60)
			{		
				if (ix == 20)
				{
					map.setTile(ix, iy, TileType.BG_WALL_LEFT);			
				}
				else if (ix == 59)
				{
					map.setTile(ix, iy, TileType.BG_WALL_RIGHT);			
				}
				else
				{
					map.setTile(ix, iy, TileType.BG_WALL_MIDDLE);			
				}
			}
		}
		
	}
	
	
}