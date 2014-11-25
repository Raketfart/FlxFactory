package scene;
import flixel.FlxG;
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

	public var mapWidth:Int = 70;
	public var mapHeight:Int = 30;
	
	//public var coins:FlxGroup;	
	//public var floor:FlxObject;
	//public var exit:FlxSprite;
	public var decorationGroup:FlxGroup;
	public var collideGroupExtra:FlxGroup;
	public var collisionMap:FlxTilemap;
	public var backgroundMap:FlxTilemap;
	
	public function new(collidegrp:FlxGroup) 
	{
		super();
				
		collisionMap = new FlxTilemap();				
		collisionMap.loadMap(MapGenerator.generateWorldString(mapWidth,mapHeight),AssetPaths.tiles_map__png, GC.tileSize, GC.tileSize, FlxTilemap.OFF);		
		
		backgroundMap = new FlxTilemap();				
		backgroundMap.loadMap(MapGenerator.generateWorldString(mapWidth,mapHeight),AssetPaths.tiles_map__png, GC.tileSize, GC.tileSize, FlxTilemap.OFF);		
		
		collideGroupExtra = new FlxGroup();
		decorationGroup = new FlxGroup();
		
		MapGenerator.generateWorld(collisionMap);
		MapGenerator.generateBackground(backgroundMap);
		
		MapGenerator.generateBuilding(backgroundMap,collisionMap,collideGroupExtra,decorationGroup);
		
		
		
		//trace(backgroundMap.getData());	
		//trace(collisionMap.getData());		
		add(backgroundMap);
		add(collisionMap);
		
		add(collideGroupExtra);
		add(decorationGroup);
		
		collidegrp.add(collisionMap);
		collidegrp.add(collideGroupExtra);
		
		
	}
	
}