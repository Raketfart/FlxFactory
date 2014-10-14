package scene;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

/**
 * ...
 * @author 
 */
class WorldMap extends FlxGroup
{

	public var mapWidth:Int = 100;
	public var mapHeight:Int = 40;
	
	public var coins:FlxGroup;	
	public var floor:FlxObject;
	public var exit:FlxSprite;
	public var collisionMap:FlxTilemap;
	public var backgroundMap:FlxTilemap;
	
	public function new() 
	{
		super();
				
		collisionMap = new FlxTilemap();				
		collisionMap.loadMap(MapGenerator.generateWorldString(mapWidth,mapHeight),AssetPaths.tiles__png, GC.tileSize, GC.tileSize, FlxTilemap.OFF);		
		
		backgroundMap = new FlxTilemap();				
		backgroundMap.loadMap(MapGenerator.generateWorldString(mapWidth,mapHeight),AssetPaths.tiles__png, GC.tileSize, GC.tileSize, FlxTilemap.OFF);		
		
		
		MapGenerator.generateWorld(collisionMap);
		
		MapGenerator.generateBuilding(backgroundMap,collisionMap);
		
		trace(backgroundMap.getData());	
		//trace(collisionMap.getData());		
		add(backgroundMap);
		add(collisionMap);
		
	}
	
}