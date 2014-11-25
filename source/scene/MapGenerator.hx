package scene;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
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
	static private var _silverBeginRow:Int = 22;
	static private var _silverEndRow:Int = 27;

		
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
	public static function generateBackground(map:FlxTilemap):Void
	{
		for (i in 1...map.widthInTiles-1) {
			map.setTile(i, _dirtbeginsrow, TileType.BG_DIRT_GRASS);			
		}
		for (iy in _dirtbeginsrow+1...map.heightInTiles-1) {
			for (ix in 1...map.widthInTiles-1) {
				map.setTile(ix,iy, TileType.BG_DIRT_SOLID);			
			}
		}	
	}
	public static function generateCoal(map:FlxTilemap):Void
	{

		//var rnd:FlxRandom = new FlxRandom();
		var coalSeeds:Int = FlxRandom.intRanged(10, 60);		
		
		for (i in 1 ... coalSeeds) {
			var coalLocX:Int = FlxRandom.intRanged(1,  map.widthInTiles - 2);
			var coalLocY:Int = FlxRandom.intRanged(_coalBeginRow, _coalEndRow);
			var pos:TilePos = new TilePos(coalLocX,coalLocY);
			
			map.setTile(pos.tileX,pos.tileY, TileType.TYPE_DIRT_COAL);						
		}
		
	}
	
	public static function generateSilver(map:FlxTilemap):Void
	{

		var silverSeeds:Int = FlxRandom.intRanged(1, 20);		
		
		for (i in 1 ... silverSeeds) {
			var coalLocX:Int = FlxRandom.intRanged(1,  map.widthInTiles - 2);
			var coalLocY:Int = FlxRandom.intRanged(_silverBeginRow, _silverEndRow);
			var pos:TilePos = new TilePos(coalLocX,coalLocY);
			
			map.setTile(pos.tileX,pos.tileY, TileType.TYPE_DIRT_CLAY);						
		}
		
	}
	
	static private function buildingFluff(collMap:FlxTilemap,decorationGrp:FlxGroup)
	{
		var objDoor:FlxSprite = new FlxSprite(0, 0,AssetPaths.door__png);
		objDoor.x = collMap.x + (GC.tileSize*20);
		objDoor.y = collMap.y + (GC.tileSize*(_dirtbeginsrow)-38);		
		decorationGrp.add(objDoor);
		
		var objDoor:FlxSprite = new FlxSprite(0, 0,AssetPaths.door__png);
		objDoor.x = collMap.x + (GC.tileSize*60)-5;
		objDoor.y = collMap.y + (GC.tileSize*(_dirtbeginsrow)-38);		
		decorationGrp.add(objDoor);
		
		//windows
		var objFluff:FlxSprite = new FlxSprite(0, 0,AssetPaths.decoration_window1__png);
		objFluff.x = collMap.x + (GC.tileSize*24);
		objFluff.y = collMap.y + (GC.tileSize*(_dirtbeginsrow-4));		
		decorationGrp.add(objFluff);
		var objFluff:FlxSprite = new FlxSprite(0, 0,AssetPaths.decoration_window1__png);
		objFluff.x = collMap.x + (GC.tileSize*26);
		objFluff.y = collMap.y + (GC.tileSize*(_dirtbeginsrow-4));		
		decorationGrp.add(objFluff);			
		
		//iron roofbar
		var objFluff:FlxSprite = new FlxSprite(0, 0);
			objFluff.loadGraphic(AssetPaths.tiles_item__png, false, 21, 21);
			objFluff.animation.frameIndex = 10;
			objFluff.x = collMap.x + (GC.tileSize*20);
			objFluff.y = collMap.y + (GC.tileSize*(_dirtbeginsrow-5)+9);		
			decorationGrp.add(objFluff);
		var objFluff:FlxSprite = new FlxSprite(0, 0);
			objFluff.loadGraphic(AssetPaths.tiles_item__png, false, 21, 21);
			objFluff.animation.frameIndex = 12;
			objFluff.x = collMap.x + (GC.tileSize*59);
			objFluff.y = collMap.y + (GC.tileSize*(_dirtbeginsrow-5)+9);		
			decorationGrp.add(objFluff);
		for (ix in 21...59)
		{
			var objFluff:FlxSprite = new FlxSprite(0, 0);
			objFluff.loadGraphic(AssetPaths.tiles_item__png, false, 21, 21);
			objFluff.animation.frameIndex = 11;
			objFluff.x = collMap.x + (GC.tileSize*ix);
			objFluff.y = collMap.y + (GC.tileSize*(_dirtbeginsrow-5)+9);		
			decorationGrp.add(objFluff);
		}
		
		var objFluff:FlxSprite = new FlxSprite(0, 0,AssetPaths.decoration_crack1__png);
		objFluff.x = collMap.x + (GC.tileSize*29);
		objFluff.y = collMap.y + (GC.tileSize*(_dirtbeginsrow-5)+19);		
		decorationGrp.add(objFluff);
		
		var objFluff:FlxSprite = new FlxSprite(0, 0,AssetPaths.decoration_mousehole__png);
		objFluff.x = collMap.x + (GC.tileSize*23);
		objFluff.y = collMap.y + (GC.tileSize*(_dirtbeginsrow)-4);		
		decorationGrp.add(objFluff);
		
	}
	static public function generateBuilding(map:FlxTilemap, collMap:FlxTilemap,collGrp:FlxGroup,decorationGrp:FlxGroup):Void
	{
		buildingFluff(collMap,decorationGrp);
		
		//left house wall
		var collObj:FlxSprite = new FlxSprite(0, 0);
		collObj.width = GC.tileSize / 4;
		collObj.height = GC.tileSize * 10-38;
		collObj.x = collMap.x + (GC.tileSize*20);
		collObj.y = collMap.y + (GC.tileSize*(_dirtbeginsrow-10));		
		collObj.immovable = true;
		collObj.loadGraphic(AssetPaths.debugpink__png, false, Std.int(collObj.width),Std.int(collObj.height));
		collGrp.add(collObj);
		if (GC.debugdraw == false)
		{
			collObj.visible = false;
		}
				
		//right house wall
		var collObj:FlxSprite = new FlxSprite(0, 0);
		collObj.width = GC.tileSize / 4;
		collObj.height = GC.tileSize * 10-38;
		collObj.x = collMap.x + (GC.tileSize*59)+(GC.tileSize*3/4);
		collObj.y = collMap.y + (GC.tileSize*(_dirtbeginsrow-10));		
		collObj.immovable = true;
		collObj.loadGraphic(AssetPaths.debugpink__png, false, Std.int(collObj.width),Std.int(collObj.height));
		collGrp.add(collObj);
		if (GC.debugdraw == false)
		{
			collObj.visible = false;
		}		
		
		for (ix in 20...60)
		{
			collMap.setTile(ix, _dirtbeginsrow, TileType.TYPE_DIRT_FLOOR);		
		}
		for (ix in 20...60)
		{
			collMap.setTile(ix, _dirtbeginsrow - 5, TileType.TYPE_EMPTY_FLOOR);		
			//collMap.setTile(ix, _dirtbeginsrow - 10, TileType.TYPE_EMPTY_FLOOR);			
		}
		map.setTile(19, _dirtbeginsrow - 10, TileType.BG_ROOF_1);					
		collMap.setTile(20, _dirtbeginsrow - 10, TileType.BG_ROOF_2);					
		collMap.setTile(59, _dirtbeginsrow - 10, TileType.BG_ROOF_4);					
		map.setTile(60, _dirtbeginsrow - 10, TileType.BG_ROOF_5);					
		for (ix in 21...59)
		{
			collMap.setTile(ix, _dirtbeginsrow - 10, TileType.BG_ROOF_3);					
		}
		for (iy in _dirtbeginsrow-9..._dirtbeginsrow) {
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