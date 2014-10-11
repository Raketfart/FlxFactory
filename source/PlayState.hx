package;

import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;
import flixel.util.loaders.CachedGraphics;
import flixel.util.loaders.TextureRegion;
import machine.Conveyor;
import machine.InventoryItem;
import machine.Machine;
import machine.Module;
import openfl.Assets;
import flixel.util.FlxPoint;
import openfl.Lib;



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
	
	
	private var _collisionMap:FlxTilemap;
	var hud:HUD;
	var camfollow:FlxSprite;
	var camfollowBounds:FlxRect;
	var camZoom:Int;
	var camfollowBoundsBorder:FlxSprite;
	
	/* EMITTER */
	private var _emitter:FlxEmitter;
	private var _whitePixel:FlxParticle;	
	var _boxGroup:FlxGroup;
	/* EMITTER */
	
	public var moduleArr:Array<Module>;
	
	override public function create():Void
	{
		FlxRandom.globalSeed = 123321;
		
		camZoom = 1;
		
		
		var backgroundRepeat1:FlxBackdrop = new FlxBackdrop(Assets.getBitmapData(AssetPaths.background_sky__png), 0, 0, true, false);
		add(backgroundRepeat1);
		
		var backgroundRepeat2:FlxBackdrop = new FlxBackdrop(Assets.getBitmapData(AssetPaths.background_clouds__png), .1, .8, true, false);
		add(backgroundRepeat2);
		backgroundRepeat2.y = 130;
		var backgroundRepeat3:FlxBackdrop = new FlxBackdrop(Assets.getBitmapData(AssetPaths.background_mountains__png), .3, .9, true, false);
		add(backgroundRepeat3);
		backgroundRepeat3.y = 120;
		var backgroundRepeat4:FlxBackdrop = new FlxBackdrop(Assets.getBitmapData(AssetPaths.background_grass__png), .5, 1, true, false);
		add(backgroundRepeat4);
		backgroundRepeat4.y = 190;
		
		var mapTileHeightMax = 40;
		//var mapTileWidthMax = 40;
		var leftoverbgheight =  (mapTileHeightMax * GC.tileSize) - (190 + 233);
		var bg:FlxSprite = new FlxSprite(0, 185 + 233);
		bg.makeGraphic(FlxG.width, Std.int(leftoverbgheight), FlxColor.BLACK);
		add(bg);
		bg.scrollFactor.x = 0;
		
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
		_collisionMap.loadMap(Assets.getText(AssetPaths.worldmap__txt),textureRegion, GC.tileSize, GC.tileSize, FlxTilemap.OFF);		
		add(_collisionMap);
				
		//FlxG.camera.setBounds(0, 0, _collisionMap.width, _collisionMap.height, true);
		
		_highlightBox = new FlxSprite(0, 0);
		_highlightBox.makeGraphic(GC.tileSize, GC.tileSize, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(_highlightBox, 0, 0, GC.tileSize - 1, GC.tileSize - 1, FlxColor.TRANSPARENT, { thickness: 1, color: FlxColor.RED });
		add(_highlightBox);
		
		setupPlayer();
		
		_boxGroup = new FlxGroup();
		add(_boxGroup);
		
		
		
		hud = new HUD(this);
		add(hud);
		
		
		
		//_btnPlay.y = 10;
		
		//_helperText.text = "rect w " + _collisionMap.getBounds().width;
		camfollowBounds = new FlxRect(100, 280, 500, 400);
		camfollowBoundsBorder = new FlxSprite();
		add(camfollowBoundsBorder);
		drawCamFollowBounds();
		
		camfollow = new FlxSprite(camfollowBounds.left, camfollowBounds.top);
		camfollow.makeGraphic(2, 2, FlxColor.AZURE);
		add(camfollow);
		
		
		super.create();
		
		//FlxG.camera.setBounds(0, 0, _collisionMap.width, _collisionMap.height, true);
		FlxG.camera.setBounds(-500, -500, 2000, 1500, false);
		FlxG.camera.follow(camfollow, FlxCamera.STYLE_NO_DEAD_ZONE,1);
		//FlxG.camera.zoom = 2;
		
		_emitter = new FlxEmitter(40, 40, 200);
		_emitter.setXSpeed( -50, 50);
		_emitter.setYSpeed( -50, -100);
		_emitter.width = GC.tileSize;
		_emitter.height= GC.tileSize;
		
		_emitter.bounce = 0.1;
		_emitter.gravity = 400;
		add(_emitter);
		
		for (i in 0...(Std.int(_emitter.maxSize / 2))) 
		{
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(4, 4, FlxColor.BROWN);
			_whitePixel.visible = false; 
			//_whitePixel.acceleration.y = 800; 			
			_emitter.add(_whitePixel);	
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(2, 2, FlxColor.BLACK);
			_whitePixel.acceleration.y = 400; 						
			_whitePixel.visible = false;
			_emitter.add(_whitePixel);
		}
		
		FlxG.worldBounds.height = _collisionMap.heightInTiles * GC.tileSize+20;
		FlxG.worldBounds.width = _collisionMap.widthInTiles * GC.tileSize + 20;
		
		moduleArr = new Array<Module>();
		setupTestMachines();
	}
	
	function setupTestMachines():Void
	{
		var mod:Module = new Machine(4, 4);
		add(mod);
		moduleArr.push(mod);
		var crate:InventoryItem = new InventoryItem();
		var mod2:Module = new Conveyor(5, 4);
		add(mod2);
		moduleArr.push(mod2);
		
		mod.connections.push(mod2);
		
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
	private function drawCamFollowBounds():Void
	{
		
		camfollowBoundsBorder.x = camfollowBounds.left;
		camfollowBoundsBorder.y = camfollowBounds.top;
		camfollowBoundsBorder.makeGraphic(Std.int(camfollowBounds.width), Std.int(camfollowBounds.height), FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(camfollowBoundsBorder, 0, 0, camfollowBounds.width - 1, camfollowBounds.height - 1, FlxColor.TRANSPARENT, { thickness: 1, color: FlxColor.RED } );
		
		
	}
	
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
	
	private function checkMouseClicks():Void
	{
		if (FlxG.mouse.justPressedRight)
		{ 
			if (isClickOnMap() == true)
			{
				/*
				_emitter.x = _highlightBox.x;
				_emitter.y = _highlightBox.y;
				_emitter.start(true, 3, 0,20,2);
				
				_debugtxt.text = "right";
				//_player.switchState(2);
				*/
				if ( FlxG.keys.pressed.SHIFT )
				{
					var b:Box = new Box(_highlightBox.x, _highlightBox.y);
					_boxGroup.add(add(b));
				}
				else {
					//var b:Conveyor = new Conveyor(_highlightBox.x, _highlightBox.y);
					//_conveyorGroup.add(b);
				}
			}
		}
		if (FlxG.mouse.justPressed)
		{
			if (isClickOnMap() == true)
			{				
				_emitter.x = _highlightBox.x;
				_emitter.y = _highlightBox.y;
				_emitter.start(false, 1, 0.01,6,3);
				//_player.switchState(1);	
				_debugtxt.text = "left";
					
			}
			
		}
		if (FlxG.mouse.pressed)
		{		
			if (isClickOnMap() == true)
			{				
				_collisionMap.setTile(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize), FlxG.keys.pressed.SHIFT ? 0 : TileType.TYPE_METAL_WALL);
			}
		}
		
		if (FlxG.mouse.justReleased || FlxG.mouse.justReleasedRight)
		{
			_debugtxt.text = "-";		
		}
	}
	private function isClickOnMap():Bool
	{
		//if not over hud
		if (!hud.hudbg.overlapsPoint(new FlxPoint(FlxG.mouse.x,FlxG.mouse.y), true))
		{
			//if inside map
			var mapsize:FlxRect = new FlxRect(0, 0, _collisionMap.width, _collisionMap.height);				
			if (mapsize.overlaps(new FlxRect(FlxG.mouse.x,FlxG.mouse.y,1,1)))
			{
			
				return true;
			
			}
			
		}
		return false;
	}
	override public function update():Void
	{
		
		checkMouseClicks();
		
		// Tilemaps can be collided just like any other FlxObject, and flixel
		// automatically collides each individual tile with the object.
		FlxG.collide(_player, _collisionMap);
		FlxG.overlap(_emitter, _collisionMap);
		
		//FlxG.collide(_boxGroup, _conveyorGroup,onConveyorCollision);
		
		FlxG.collide(_boxGroup);
		
		if (camZoom == 1)
		{		
			updateCamera();
		} else {
			updatePlayer();
		}
		
		_highlightBox.x = Math.floor(FlxG.mouse.x / GC.tileSize) * GC.tileSize;
		_highlightBox.y = Math.floor(FlxG.mouse.y / GC.tileSize) * GC.tileSize;
		
		super.update();
		
	}
	private function updateCamera():Void
	{
		if (FlxG.keys.anyPressed(["LEFT", "A"]))
		{
			//FlxG.camera..x += 10;			
			if (camfollow.x > camfollowBounds.left)
			{
				camfollow.x -= 10;
			}
		}
		else if (FlxG.keys.anyPressed(["RIGHT", "D"]))
		{
			//FlxG.camera.x -= 10;
			if (camfollow.x < camfollowBounds.left+camfollowBounds.width)
			{
				camfollow.x += 10;
			}
		}
		if (FlxG.keys.anyPressed(["UP", "W"]) )
		{
			//FlxG.camera.y += 10;
			if (camfollow.y > camfollowBounds.top)
			{
				camfollow.y -= 10;
			}
		}
		if (FlxG.keys.anyPressed(["DOWN", "S"]) )
		{
			//FlxG.camera.y -= 10;
			if (camfollow.y < camfollowBounds.top+camfollowBounds.height)
			{
				camfollow.y += 10;
			}
		}
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
	/*
	function onConveyorCollision(boxRef:FlxObject, convRef:FlxObject):Void
	{
		boxRef.velocity.x = 100;
		trace(convRef.ID);
		boxRef.y = convRef.y - 10;
		
	}
	*/
	public function resetCam():Void
	{
		//FlxG.scaleMode = new FixedScaleMode();
		//trace("w1 " + FlxG.worldBounds.toString());
		
		if (camZoom == 1)
		{
			camZoom = 2;
			FlxG.camera.zoom = camZoom;
			FlxG.camera.setSize(500, 300);
			
			camfollowBounds = new FlxRect(50, 120, 600, 500);
			drawCamFollowBounds();
			restrictCamFollow();
			
			FlxG.camera.follow(_player, FlxCamera.STYLE_PLATFORMER, 1);
		}
		else {
			//trace("zoom out");
			camZoom = 1;
			FlxG.camera.zoom = camZoom;
			FlxG.camera.setSize(1000, 600);
			
			camfollowBounds = new FlxRect(100, 280, 500, 400);
			drawCamFollowBounds();
			restrictCamFollow();
			
			FlxG.camera.follow(camfollow, FlxCamera.STYLE_NO_DEAD_ZONE,1);
		}
		trace("w2 " + FlxG.worldBounds.toString());
		trace("m2 " + (_collisionMap.heightInTiles*GC.tileSize));
		
		//FlxG.camera.setBounds(-500, -500, 2000, 1500, true);
		//FlxG.camera.follow(camfollow, FlxCamera.STYLE_NO_DEAD_ZONE,1);
		
	}
	
	private function restrictCamFollow()
	{
		if (camfollow.x < camfollowBounds.left)
			{
				
				camfollow.x = camfollowBounds.left;
			} 
			else if (camfollow.x > camfollowBounds.left+camfollowBounds.width)
			{
				
				camfollow.x = camfollowBounds.left+camfollowBounds.width;
			}
			if (camfollow.y < camfollowBounds.top)
			{
				
				camfollow.y = camfollowBounds.top;
			} 
			else if (camfollow.y > camfollowBounds.top+camfollowBounds.height)
			{
				
				camfollow.y = camfollowBounds.top+camfollowBounds.height;
			}
	}
	
	public function resetGame():Void
	{
		//_collisionMap.loadMap(Assets.getText(AssetPaths.worldmap__txt), AssetPaths.worldtiles__png, GC.tileSize, GC.tileSize, FlxTilemap.OFF);
		_player.setPosition(64, 64);
	}
	
	public function mapGen1():Void
	{
		var dirtbeginsrow:Int = 10;
		
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
		var coalBeginRow:Int = 12;
		var coalEndRow:Int = 14;
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