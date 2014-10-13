package;


import entity.Player;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.text.FlxText;
import flixel.tile.FlxBaseTilemap.FlxTilemapAutoTiling;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;

import machine.Conveyor;
import inventory.InventoryItem;
import machine.Machine;
import machine.Module;
import openfl.Assets;
import flixel.math.FlxPoint;
import openfl.Lib;
import scene.Background;
import scene.MapGenerator;



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
	public var player:Player;
	
	/**
	 * Some interface buttons and text
	 */
	
	
	private var _collisionMap:FlxTilemap;
	public var moduleGrp:FlxGroup;
	public var inventoryGrp:FlxGroup;
	
	public var camfollow:FlxSprite;
	var camController:CameraController;
	var hud:HUD;
	
	
	/* EMITTER */
	private var _emitter:FlxEmitter;
	private var _whitePixel:FlxParticle;	
	/* EMITTER */
	
	public var moduleArr:Array<Module>;
	
	
	override public function create():Void
	{
		//FlxRandom.globalSeed = 123321;
		
		
		
		var background:Background = new Background();
		add(background);
		
		_debugtxt = new FlxText(10, 10, 200, "-");
		add(_debugtxt);
		
		setupMap();
				
		
		_highlightBox = new FlxSprite(0, 0);
		_highlightBox.makeGraphic(GC.tileSize, GC.tileSize, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(_highlightBox, 0, 0, GC.tileSize - 1, GC.tileSize - 1, FlxColor.TRANSPARENT, { thickness: 1, color: FlxColor.RED });
		add(_highlightBox);
			

		moduleArr = new Array<Module>();
		moduleGrp = new FlxGroup();
		add(moduleGrp);
		inventoryGrp = new FlxGroup();
		add(inventoryGrp);
		
		setupTestMachines();
		
		player = new Player(64, 64);
		add(player);
	
		_emitter = new FlxEmitter(40, 40, 200);
		//_emitter.setXSpeed( -50, 50);
		//_emitter.setYSpeed( -50, -100);
		_emitter.width = GC.tileSize;
		_emitter.height= GC.tileSize;
		
		//_emitter.bounce = 0.1;
		//_emitter.gravity = 400;
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
		
		hud = new HUD(this);
		add(hud);
		
		camController = new CameraController(this);
		add(camController);
		camfollow = new FlxSprite(camController.camfollowBounds.left, camController.camfollowBounds.top);
		camfollow.makeGraphic(2, 2, FlxColor.BLUE);
		add(camfollow);
		
		
		
		//FlxG.camera.setBounds(-500, -500, 2000, 1500, false);
		FlxG.camera.follow( camfollow, FlxCameraFollowStyle.NO_DEAD_ZONE,1);		
		
		FlxG.worldBounds.height = _collisionMap.heightInTiles * GC.tileSize+20;
		FlxG.worldBounds.width = _collisionMap.widthInTiles * GC.tileSize + 20;
		
		mapGen1();
		
		super.create();
		
	}
	//{ region Setup
	function setupMap() 
	{		
		/*
		//tile space helper
		var cached:FlxGraphic = FlxG.bitmap.add(AssetPaths.pixelspritesheet_trans__png);
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
		*/
		_collisionMap = new FlxTilemap();				
		_collisionMap.loadMapFromCSV(Assets.getText(AssetPaths.worldmap__txt),AssetPaths.pixelspritesheet_trans__png, GC.tileSize, GC.tileSize,FlxTilemapAutoTiling.OFF,0,1,1);		
		add(_collisionMap);
		
	}
	
	function setupTestMachines():Void
	{
		var mod:Module = new Machine(7, 9);
		moduleGrp.add(mod);
		moduleArr.push(mod);
		
		var mod2:Module = new Conveyor(8, 9);
		moduleGrp.add(mod2);
		moduleArr.push(mod2);
		
		mod.connections.push(mod2);
		
		var mod3:Module = new Conveyor(9, 9);
		moduleGrp.add(mod3);
		moduleArr.push(mod3);
		
		mod2.connections.push(mod3);
		
		var crate:InventoryItem = new InventoryItem();
		inventoryGrp.add(crate);
		mod.addToInventory(crate);
		crate = new InventoryItem();
		inventoryGrp.add(crate);
		
	}
	
	//} endregion
	
	
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
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
					var crate:InventoryItem = new InventoryItem();
					inventoryGrp.add(crate);
					moduleArr[0].addToInventory(crate);
					//var b:Box = new Box(_highlightBox.x, _highlightBox.y);
					//_boxGroup.add(add(b));
				}
				else {
					var mod:Module = new Conveyor(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
					moduleGrp.add(mod);
					moduleArr.push(mod);
					for (m in moduleArr)
					{
						//trace(m.tilePos.tileX + " vs " + (Std.int(FlxG.mouse.x / GC.tileSize) - 1));
						if (m.tilePos.tileX == Std.int(FlxG.mouse.x / GC.tileSize) - 1 && m.tilePos.tileY == Std.int(FlxG.mouse.y / GC.tileSize))
						{
							m.connections.push(mod);
							
						}
					}
					
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
				_emitter.start(false, 1, 6);
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
	override public function update(elapsed:Float):Void
	{
		
		checkMouseClicks();
		
		// Tilemaps can be collided just like any other FlxObject, and flixel
		// automatically collides each individual tile with the object.
		FlxG.collide(player, _collisionMap);
		FlxG.overlap(_emitter, _collisionMap);
		
		//FlxG.collide(_boxGroup, _conveyorGroup,onConveyorCollision);
		
		//FlxG.collide(_boxGroup);
		
		if (camController.camZoom == 1)
		{		
			camController.updateCameraControls();
		} else {
			
			player.updateMovementControls();
		}
		
		_highlightBox.x = Math.floor(FlxG.mouse.x / GC.tileSize) * GC.tileSize;
		_highlightBox.y = Math.floor(FlxG.mouse.y / GC.tileSize) * GC.tileSize;
		
		super.update(elapsed);
		
	}
	
	
	
	public function switchCam():Void
	{
		camController.switchCam();
	}	
	public function resetGame():Void
	{
		player.setPosition(64, 64);
	}	
	public function mapGen1():Void
	{
		MapGenerator.generateWorld(_collisionMap);		
	}
	public function mapGen2():Void
	{
		MapGenerator.generateCoal(_collisionMap);		
	}
	
}