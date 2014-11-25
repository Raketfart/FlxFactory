package scene ;

/**
 * ...
 * @author 
 */
class TileType
{

	public static inline var TYPE_EMPTY:Int = 0;
	public static inline var TYPE_SOLIDBLACK:Int = 8;
	
	public static inline var TYPE_METAL_WALL:Int = 1;
	
	public static inline var TYPE_ICE_SOLID:Int = 4;
	
	public static inline var TYPE_DIRT_SOLID:Int = 2;	
	public static inline var TYPE_DIRT_CLAY:Int = 5;
	public static inline var TYPE_DIRT_SILVER:Int = 6;
	public static inline var TYPE_DIRT_COAL:Int = 7;
	
	public static inline var TYPE_DIRT_GRASS:Int = 3;
	public static inline var TYPE_DIRT_FLOOR:Int = 10;
	public static inline var TYPE_EMPTY_FLOOR:Int = 11;
	
	public static inline var BG_DIRT_SOLID:Int = 16;
	public static inline var BG_DIRT_GRASS:Int = 17;
	
	public static inline var BG_WALL_LEFT:Int = 31;
	public static inline var BG_WALL_MIDDLE:Int = 32;
	public static inline var BG_WALL_RIGHT:Int = 33;
	public static inline var BG_ROOF_1:Int = 20;
	public static inline var BG_ROOF_2:Int = 21;
	public static inline var BG_ROOF_3:Int = 22;
	public static inline var BG_ROOF_4:Int = 23;
	public static inline var BG_ROOF_5:Int = 24;
	
	public static function isTileDiggable(tiletype:Int):Bool
	{
		switch (tiletype) 
		{

		   case TYPE_DIRT_CLAY:
				return true;
		   case TYPE_DIRT_SOLID:
				return true;
		   case TYPE_DIRT_SILVER:
				return true;
		   case TYPE_DIRT_COAL:
				return true;
		   case TYPE_DIRT_GRASS:
				return true;
		   case TYPE_EMPTY_FLOOR:
				return true;
		   case TYPE_DIRT_FLOOR:
				return true;
		   default:
			  return false;

		}
	}
	
}