package;

import entity.Player;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxButtonPlus;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;
import flixel.util.loaders.CachedGraphics;
import flixel.util.loaders.TextureRegion;
import hud.HUD;
import machine.Machine;
import openfl.system.System;



import openfl.Assets;
import scene.Background;
import scene.Emitter;
import scene.MapGenerator;
import scene.TileType;
import scene.WorldMap;



using flixel.util.FlxSpriteUtil;
/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	
	
	public var player:Player;	
	//public var _collisionMap:FlxTilemap;
	public var worldmap:WorldMap;
	public var machineController:MachineController;
	public var mouseController:MouseController;
	public var emitter:Emitter;	
	public var hud:HUD;
	
	public var collideGrp:FlxGroup;
	
	var camController:CameraController;
	
	private var _gameTimer:Float;
	
	
	
	override public function create():Void
	{
		FlxRandom.globalSeed = 123321;
		_gameTimer = 0;
		
		var background:Background = new Background();
		add(background);
		
		collideGrp = new FlxGroup();
		
		setupMap();
		
		
		
		machineController = new MachineController();
		add(machineController);
		
		//machineController.setupTestMachines();
		machineController.setupTestMachines2();
		
		
		emitter = new Emitter(collideGrp);
		add(emitter);
		
		
		player = new Player(64, 64);
		add(player);
		collideGrp.add(player);
		
		hud = new HUD(this);
		add(hud);
		GC.hud = hud;
		GC.state = this;
		
		FlxG.worldBounds.width = worldmap.mapWidth * GC.tileSize + 20;
		FlxG.worldBounds.height = worldmap.mapHeight * GC.tileSize+20;
		
		camController = new CameraController(this);
		add(camController);
		
		mouseController = new MouseController(this);
		add(mouseController);
		
		super.create();
		
		
		//mapGen1();
		
		//FlxG.watch.add(player,"x","px");
		
	}
	
	//{ region Setup
	function setupMap() 
	{
		
		worldmap = new WorldMap();
		add(worldmap);
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

	
	
	
	public function isClickOnMap():Bool
	{
		//if not over hud
		if (!hud.hudbg1.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), true)
			&& !hud.hudbg2.overlapsPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y), true)
			)
		{
			//if inside map
			var mapsize:FlxRect = new FlxRect(0, 0, worldmap.collisionMap.width, worldmap.collisionMap.height);				
			if (mapsize.overlaps(new FlxRect(FlxG.mouse.x,FlxG.mouse.y,1,1)))
			{			
				return true;			
			}
			
		}
		return false;
	}
	override public function update():Void
	{
		
		
		
		// Tilemaps can be collided just like any other FlxObject, and flixel
		// automatically collides each individual tile with the object.
		//FlxG.collide(worldmap.collisionMap,player);
		FlxG.collide(worldmap.collisionMap,collideGrp);
		//FlxG.collide(worldmap.collisionMap,emitter);
		
		//FlxG.collide(_boxGroup, _conveyorGroup,onConveyorCollision);
		
		//FlxG.collide(_boxGroup);
		if (GC.windowMode == false)
		{
			if (camController.camZoom == 1)
			{		
				camController.updateCameraControls();
			} else {
				player.updateMovementControls();
			}
		}
		
		_gameTimer += FlxG.elapsed*GC.gamespeed;		
		if (_gameTimer > 1) 
		{			
			Accountant.tick();	
			_gameTimer -= 1;
			//FlxG.watch.add(this,"_gameTimer");
		}
		
		super.update();
		
	}
	
	
	
	public function switchCam():Void
	{
		camController.switchCam();
		
	}
	public function quitGame():Void
	{
		System.exit(0);
	}
	
	public function resetGame():Void
	{
		//_collisionMap.loadMap(Assets.getText(AssetPaths.worldmap__txt), AssetPaths.worldtiles__png, GC.tileSize, GC.tileSize, FlxTilemap.OFF);
		player.setPosition(64, 64);
		FlxG.resetGame();
	}
	
	public function mapGen1():Void
	{
		MapGenerator.generateWorld(worldmap.collisionMap);
		
	}
	
	public function mapGen2():Void
	{
		
		MapGenerator.generateCoal(worldmap.collisionMap);
		MapGenerator.generateSilver(worldmap.collisionMap);
		
	}
	
	
	
	
}