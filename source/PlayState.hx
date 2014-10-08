package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.loaders.CachedGraphics;
import flixel.util.loaders.TextureRegion;
import openfl.Assets;
import flixel.util.FlxPoint;



using flixel.util.FlxSpriteUtil;
/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	//var _player:Player;
	
	public var _debugtxt:FlxText;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	/**
	 * Box to show the user where they're placing stuff
	 */ 
	private var _highlightBox:FlxSprite;
	
	/**
	 * Player modified from "Mode" demo
	 */ 
	private var _player:Player;
	
	/**
	 * Some interface buttons and text
	 */
	
	
	private static inline var TILE_WIDTH:Int = 21;
	private static inline var TILE_HEIGHT:Int = 21;
	private var _collisionMap:FlxTilemap;
	var hud:HUD;
	
	
	override public function create():Void
	{
		FlxRandom.globalSeed = 123321;
		
		var bg:FlxSprite = new FlxSprite(0, 0);
		//bg.makeGraphic(TILE_WIDTH*35, TILE_HEIGHT*25, 0xffd5f2f7);
		bg.makeGraphic(TILE_WIDTH*12, TILE_HEIGHT*14, 0xffd5f2f7);
		add(bg);
		
		var x:FlxSprite = new FlxSprite(200, 0);
		x.makeGraphic(200, TILE_HEIGHT*14, 0xff0000FF);
		x.scrollFactor.x = .5;
		add(x);
		
		_debugtxt = new FlxText(10, 10, 200, "-");
		add(_debugtxt);
		
		
		
		//tile space helper
		var cached:CachedGraphics = FlxG.bitmap.add(AssetPaths.pixelspritesheet_trans__png);
		// top left corner of the first tile
		var startX:Int = 2;
		var startY:Int = 2;
		// tile size
		var tileWidth:Int = 21;
		var tileHeight:Int = 21;
		// tile spacing
		var spacingX:Int = 2;
		var spacingY:Int = 2;
		// end of tiles
		var width:Int = cached.bitmap.width - startX;
		var height:Int = cached.bitmap.height - startY;
		// define region
		var textureRegion:TextureRegion = new TextureRegion(cached, startX, startY, tileWidth, tileHeight, spacingX, spacingY, width, height);
		
		_collisionMap = new FlxTilemap();				
		_collisionMap.loadMap(Assets.getText(AssetPaths.worldmap_small__txt),textureRegion, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);		
		add(_collisionMap);
				
		//FlxG.camera.setBounds(0, 0, _collisionMap.width, _collisionMap.height, true);
		
		_highlightBox = new FlxSprite(0, 0);
		_highlightBox.makeGraphic(TILE_WIDTH, TILE_HEIGHT, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(_highlightBox, 0, 0, TILE_WIDTH - 1, TILE_HEIGHT - 1, FlxColor.TRANSPARENT, { thickness: 1, color: FlxColor.RED });
		add(_highlightBox);
		
		setupPlayer();
		
		
		hud = new HUD(this);
		add(hud);
		
		//_btnPlay.y = 10;
		
		//_helperText.text = "rect w " + _collisionMap.getBounds().width;
		
		
		
		super.create();
		
		//FlxG.camera.setBounds(0, 0, _collisionMap.width, _collisionMap.height, true);
		FlxG.camera.setBounds(0, 0, 1000, 1000, true);
		FlxG.camera.follow(_player, FlxCamera.STYLE_NO_DEAD_ZONE,1);
		FlxG.camera.zoom = 2;
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	
	
	private function setupPlayer():Void
	{
		/*
		_player = new FlxSprite(64, 64);
		_player.loadGraphic("assets/spaceman.png", true, 16);
		
		// Bounding box tweaks
		_player.setSize(14, 14);
		_player.offset.set(1, 1);
		
		// Basic player physics
		_player.drag.x = 640;
		_player.acceleration.y = 420;
		_player.maxVelocity.set(120, 200);
		
		
		// Animations
		_player.animation.add("idle", [0]);
		_player.animation.add("run", [1, 2, 3, 0], 12);
		_player.animation.add("jump", [4]);
		
		add(_player);
		*/
		_player = new Player(64, 64);
		add(_player);
	}
	
	override public function update():Void
	{
		
		if (FlxG.mouse.justPressedRight)
		{ 
			_debugtxt.text = "right";
			//_player.switchState(2);		
		}
		if (FlxG.mouse.justPressed)
		{
			//_player.switchState(1);	
			_debugtxt.text = "left";
			
			
		}
		if (FlxG.mouse.pressed)
		{		
			if (!hud.hudbg.overlapsPoint(new FlxPoint(FlxG.mouse.x,FlxG.mouse.y), true))
			{
				//_collisionMap.setTile(Std.int(FlxG.mouse.x / TILE_WIDTH), Std.int(FlxG.mouse.y / TILE_HEIGHT), FlxG.keys.pressed.SHIFT ? 0 : 1);
				_collisionMap.setTile(Std.int(FlxG.mouse.x / TILE_WIDTH), Std.int(FlxG.mouse.y / TILE_HEIGHT), FlxG.keys.pressed.SHIFT ? 0 : TileType.TYPE_METAL_WALL);
				
			}
		}
		
		if (FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight)
		{
			_debugtxt.text = "-";
		
		}
		
		// Tilemaps can be collided just like any other FlxObject, and flixel
		// automatically collides each individual tile with the object.
		FlxG.collide(_player, _collisionMap);
		
		
		_highlightBox.x = Math.floor(FlxG.mouse.x / TILE_WIDTH) * TILE_WIDTH;
		_highlightBox.y = Math.floor(FlxG.mouse.y / TILE_HEIGHT) * TILE_HEIGHT;
		
		
		
		updatePlayer();
		
		super.update();
		
	}
	
	private function updatePlayer():Void
	{
		//FlxSpriteUtil.screenWrap(_player);
		
		// MOVEMENT
		_player.acceleration.x = 0;
		
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			_player.flipX = true;
			_player.acceleration.x -= _player.drag.x;
		}
		else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			_player.flipX = false;
			_player.acceleration.x += _player.drag.x;
		}
		if (FlxG.keys.anyJustPressed(["UP", "W"]) && _player.velocity.y == 0)
		{
			_player.y -= 1;
			_player.velocity.y = -200;
		}
		
		// ANIMATION
		if (_player.velocity.y != 0)
		{
			_player.animation.play("jump");
		}
		else if (_player.velocity.x == 0)
		{
			_player.animation.play("idle");
		}
		else
		{
			_player.animation.play("run");
		}
	}
	
	public function resetCam():Void
	{
		FlxG.camera.setBounds(0, 0, _collisionMap.width, _collisionMap.height, true);
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN,1);
		FlxG.camera.zoom = 2;
	}
	
	public function resetGame():Void
	{
		_collisionMap.loadMap(Assets.getText(AssetPaths.worldmap__txt), AssetPaths.worldtiles__png, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
		_player.setPosition(64, 64);
	}
	
	public function mapGen1():Void
	{
		var dirtbeginsrow:Int = 8;
		
		trace("mapgen " + _collisionMap.widthInTiles + "x" + _collisionMap.heightInTiles);
		for (i in 1..._collisionMap.widthInTiles-1) {
			_collisionMap.setTile(i, dirtbeginsrow, TileType.TYPE_DIRT_GRASS);			
		}
		for (iy in dirtbeginsrow+1..._collisionMap.heightInTiles-1) {
			for (ix in 1..._collisionMap.widthInTiles-1) {
				_collisionMap.setTile(ix,iy, TileType.TYPE_DIRT_SOLID);			
			}
		}
		
	}
	
	public function mapGen2():Void
	{
		var coalBeginRow:Int = 10;
		var coalEndRow:Int = 12;
		var coalSeeds:Int = FlxRandom.intRanged(1, 20);
		
		//var coalLocX:Int = FlxRandom.intRanged(10, 12);
		//var coalLocY:Int = FlxRandom.intRanged(1,_collisionMap.widthInTiles-1);
		
		for (i in 1...coalSeeds) {
			var pos:FlxPoint = getSeedLoc(coalBeginRow,coalEndRow);
			_collisionMap.setTile(Std.int(pos.x),Std.int(pos.y), TileType.TYPE_ICE_SOLID);						
		}
		
	}
	private function getSeedLoc(startRow:Int,endRow:Int):FlxPoint
	{
		var coalLocX:Int = FlxRandom.intRanged(1, _collisionMap.widthInTiles - 2);
		var coalLocY:Int = FlxRandom.intRanged(startRow, endRow);
		//trace("x" + coalLocX + " : " + (_collisionMap.widthInTiles - 1));
		
		return new FlxPoint(coalLocX, coalLocY);
	}
	
	public function mapGen3():Void
	{
		
		
	}
	public function mapGen4():Void
	{
		
		
	}
	
	
}