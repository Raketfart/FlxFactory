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
	private var _player:FlxSprite;
	
	/**
	 * Some interface buttons and text
	 */
	
	
	private static inline var TILE_WIDTH:Int = 20;
	private static inline var TILE_HEIGHT:Int = 20;
	private var _collisionMap:FlxTilemap;
	var hud:HUD;
	
	
	override public function create():Void
	{
		
		var bg2:FlxSprite = new FlxSprite(-200, -200);
		bg2.makeGraphic(FlxG.width*8, FlxG.height*4, 0xffFF00FF);
		add(bg2);
		
		var bg:FlxSprite = new FlxSprite(0, 0);
		bg.makeGraphic(FlxG.width, FlxG.height, 0xffd5f2f7);
		add(bg);
		
		var x:FlxSprite = new FlxSprite(200, 0);
		x.makeGraphic(200, FlxG.height, 0xff0000FF);
		x.scrollFactor.x = .5;
		add(x);
		
		_debugtxt = new FlxText(10, 10, 200, "-");
		add(_debugtxt);
		
		
		
		
		_collisionMap = new FlxTilemap();
		
		// Initializes the map using the generated string, the tile images, and the tile size
		_collisionMap.loadMap(Assets.getText(AssetPaths.worldmap__txt), AssetPaths.worldtiles__png, TILE_WIDTH, TILE_HEIGHT, FlxTilemap.OFF);
		
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
		
		FlxG.camera.setBounds(0, 0, _collisionMap.width, _collisionMap.height, true);
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN,1);
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
				_collisionMap.setTile(Std.int(FlxG.mouse.x / TILE_WIDTH), Std.int(FlxG.mouse.y / TILE_HEIGHT), FlxG.keys.pressed.SHIFT ? 0 : 1);
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
	
}