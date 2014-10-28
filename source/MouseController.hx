package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import hud.HUD;
import machine.ConveyorLeft;
import machine.Machine;
import machine.Module;
import scene.TileType;
import util.FlxFSM;

/**
 * ...
 * @author 
 */
class MouseController extends FlxGroup
{

	public var fsm:FlxFSM<MouseController>;
	
	public var highlightBox:FlxSprite;
	public var state:PlayState;
	
	public function new(State:PlayState ) 
	{		
		super();
		state = State;
		
		highlightBox = new FlxSprite(0, 0);
		highlightBox.makeGraphic(GC.tileSize, GC.tileSize, FlxColor.TRANSPARENT);
		FlxSpriteUtil.drawRect(highlightBox, 0, 0, GC.tileSize - 1, GC.tileSize - 1, FlxColor.TRANSPARENT, { thickness: 1, color: FlxColor.WHITE });
		highlightBox.visible = false;
		add(highlightBox);
		
		fsm = new FlxFSM<MouseController>(this, new Idle());
	
	}
	
	override public function update():Void
	{
		
		//checkMouseClicks();
		
		//_highlightBox.x = Math.floor(FlxG.mouse.x / GC.tileSize) * GC.tileSize;
		//_highlightBox.y = Math.floor(FlxG.mouse.y / GC.tileSize) * GC.tileSize
		//x = Math.floor(FlxG.mouse.x / GC.tileSize) * GC.tileSize;
		//y = Math.floor(FlxG.mouse.y / GC.tileSize) * GC.tileSize;
		fsm.update(FlxG.elapsed);
		
		super.update();
		
	}
	public function changeTool(ToolName:String):Void
	{
		if (ToolName == HUD.TOOL_DIG)
		{
			fsm.state = new ToolDig();
		} 
		else if (ToolName == HUD.TOOL_BUILD)
		{
			fsm.state = new ToolBuild();
		} 
		else if (ToolName == HUD.TOOL_CONV_RIGHT)
		{
			fsm.state = new ToolModule();
		} 
		else if (ToolName == HUD.TOOL_CONV_LEFT)
		{
			fsm.state = new ToolModule();
		} 
		else if (ToolName == HUD.TOOL_CONV_UP)
		{
			fsm.state = new ToolModule();
		} 
		else if (ToolName == HUD.TOOL_CONV_DOWN)
		{
			fsm.state = new ToolModule();
		} 
		else if (ToolName == HUD.TOOL_MACHINE1 || ToolName == HUD.TOOL_MACHINE2 || ToolName == HUD.TOOL_MACHINE3 || ToolName == HUD.TOOL_MACHINE4)
		{
			fsm.state = new ToolModule();
		} 
		else if (ToolName == HUD.TOOL_DECONSTRUCT)
		{
			fsm.state = new ToolDeconstruct();
		} 
		else if (ToolName == HUD.TOOL_CRATE)
		{
			fsm.state = new ToolModule();
		} 
		else if (ToolName == HUD.TOOL_CONTROL)
		{
			fsm.state = new ToolControl();
		} 
		else if (ToolName == HUD.TOOL_WINDOW)
		{
			fsm.state = new ToolWindow();
		} 
		else {
			fsm.state = new Idle();
		}
	}
}
class Idle extends FlxFSMState<MouseController>
{
	override public function enter(Owner:MouseController, FSM:FlxFSM<MouseController>)
	{
		//trace("Enter Idle");				
	}
	
	override public function update(elapsed:Float, Owner:MouseController, FSM:FlxFSM<MouseController>)
	{					
	}
}
class ToolWindow extends FlxFSMState<MouseController>
{
	override public function enter(Owner:MouseController, FSM:FlxFSM<MouseController>)
	{
					
	}
	
	override public function update(elapsed:Float, Owner:MouseController, FSM:FlxFSM<MouseController>)
	{					
	}
}
class ToolDig extends FlxFSMState<MouseController>
{
	override public function enter(Owner:MouseController, FSM:FlxFSM<MouseController>)
	{
		//trace("Enter ToolDig");			
		Owner.highlightBox.visible = true;
		Owner.highlightBox.color = FlxColor.RED;
	}
	
	override public function update(elapsed:Float, Owner:MouseController, FSM:FlxFSM<MouseController>)
	{		
		Owner.highlightBox.x = Math.floor(FlxG.mouse.x / GC.tileSize) * GC.tileSize;
		Owner.highlightBox.y = Math.floor(FlxG.mouse.y / GC.tileSize) * GC.tileSize;
		if (FlxG.mouse.pressed)
		{
			var tiletype:Int = Owner.state.worldmap.collisionMap.getTile(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));				
			if (TileType.isTileDiggable(tiletype))
			{					
				Owner.state.worldmap.collisionMap.setTile(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize), TileType.TYPE_EMPTY);					
				Owner.state.emitter.emit(Owner.highlightBox.x,Owner.highlightBox.y);
			} 
		}
	}
	override public function exit(Owner:MouseController)
	{
		Owner.highlightBox.color = FlxColor.WHITE;
		Owner.highlightBox.visible = false;
	}
}
class ToolDeconstruct extends FlxFSMState<MouseController>
{
	override public function enter(Owner:MouseController, FSM:FlxFSM<MouseController>)
	{
		//trace("Enter ToolDeconstruct");			
		Owner.highlightBox.visible = true;
		Owner.highlightBox.color = FlxColor.HOT_PINK;
	}
	
	override public function update(elapsed:Float, Owner:MouseController, FSM:FlxFSM<MouseController>)
	{		
		Owner.highlightBox.x = Math.floor(FlxG.mouse.x / GC.tileSize) * GC.tileSize;
		Owner.highlightBox.y = Math.floor(FlxG.mouse.y / GC.tileSize) * GC.tileSize;
		if (FlxG.mouse.pressed)
		{
			var tiletype:Int = Owner.state.worldmap.collisionMap.getTile(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));							
			if (tiletype == TileType.TYPE_METAL_WALL)
			{
				Owner.state.worldmap.collisionMap.setTile(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize), TileType.TYPE_EMPTY);
				Owner.state.emitter.emitSmoke(Owner.highlightBox.x,Owner.highlightBox.y);
			}
			else if (Owner.state.machineController.getModuleAt(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize)) != null)
			{
				Owner.state.machineController.removeModule();
				Owner.state.emitter.emitSmoke(Owner.highlightBox.x,Owner.highlightBox.y);
			}
		}
	}
	override public function exit(Owner:MouseController)
	{
		Owner.highlightBox.color = FlxColor.WHITE;
		Owner.highlightBox.visible = false;
	}
}
class ToolBuild extends FlxFSMState<MouseController>
{
	override public function enter(Owner:MouseController, FSM:FlxFSM<MouseController>)
	{
		//trace("Enter ToolBuild");			
		Owner.highlightBox.visible = true;
		Owner.highlightBox.color = FlxColor.GREEN;
	}
	
	override public function update(elapsed:Float, Owner:MouseController, FSM:FlxFSM<MouseController>)
	{		
		Owner.highlightBox.x = Math.floor(FlxG.mouse.x / GC.tileSize) * GC.tileSize;
		Owner.highlightBox.y = Math.floor(FlxG.mouse.y / GC.tileSize) * GC.tileSize;
		if (FlxG.mouse.pressed)
		{
			var tiletype:Int = Owner.state.worldmap.collisionMap.getTile(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));				
			if (tiletype==TileType.TYPE_EMPTY)
			{
				Owner.state.worldmap.collisionMap.setTile(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize), TileType.TYPE_METAL_WALL);
				GC.hud.addDing(Std.int(FlxG.mouse.x / GC.tileSize) * GC.tileSize, Std.int(FlxG.mouse.y / GC.tileSize) * GC.tileSize, "*");
			}			
		}
	}
	override public function exit(Owner:MouseController)
	{
		Owner.highlightBox.color = FlxColor.WHITE;
		Owner.highlightBox.visible = false;
	}
}
class ToolModule extends FlxFSMState<MouseController>
{
	var _moduleGhost:FlxSprite;
	var _arrowGhost:FlxSprite;
	var _tool:String;
	
	override public function enter(Owner:MouseController, FSM:FlxFSM<MouseController>)
	{
		_tool = GC.currentTool;
		
		addgraphics(Owner);
		
	}
	private function addgraphics(Owner:MouseController)
	{
		_arrowGhost = new FlxSprite(0, 0);		
		_arrowGhost.loadGraphic(AssetPaths.tiles_item__png,true,21,21);		
		_arrowGhost.animation.add("pointright", [45], 1,false);		
		_arrowGhost.animation.play("pointright");	
		_arrowGhost.setFacingFlip(FlxObject.LEFT, true, false);
		
		_moduleGhost = new FlxSprite(0, 0);		
		_moduleGhost.loadGraphic(AssetPaths.tiles_item__png,true,21,21);		
		_moduleGhost.animation.add("running", [40], 1, false);		
		_moduleGhost.animation.play("running");		
		_moduleGhost.setFacingFlip(FlxObject.LEFT, true, false);
		
		_moduleGhost.alpha = .5;	
		if (_tool == HUD.TOOL_CONV_LEFT)
		{
			_moduleGhost.facing = FlxObject.LEFT;
			_arrowGhost.facing = FlxObject.LEFT;
			_arrowGhost.visible = true;
		} 
		else if (_tool == HUD.TOOL_CONV_RIGHT)
		{
			_moduleGhost.facing = FlxObject.RIGHT;
			_arrowGhost.facing = FlxObject.RIGHT;
			_arrowGhost.visible = true;
		}
		else if (_tool == HUD.TOOL_CONV_UP)
		{
			_moduleGhost.facing = FlxObject.RIGHT;
			_arrowGhost.facing = FlxObject.RIGHT;
			_arrowGhost.visible = true;
		}
		else if (_tool == HUD.TOOL_CONV_DOWN)
		{
			_moduleGhost.facing = FlxObject.RIGHT;
			_arrowGhost.facing = FlxObject.RIGHT;
			_arrowGhost.visible = true;
		}
		else if (_tool == HUD.TOOL_MACHINE1)
		{			
			_moduleGhost.loadGraphic(AssetPaths.factory__png);
			_moduleGhost.facing = FlxObject.RIGHT;			
			_arrowGhost.visible = false;
		}
		else if (_tool == HUD.TOOL_MACHINE2)
		{			
			_moduleGhost.loadGraphic(AssetPaths.factoryDrill__png);
			_moduleGhost.facing = FlxObject.RIGHT;			
			_arrowGhost.visible = false;
		}
		else if (_tool == HUD.TOOL_MACHINE3)
		{			
			_moduleGhost.loadGraphic(AssetPaths.factoryStamper_1__png);
			_moduleGhost.facing = FlxObject.RIGHT;			
			_arrowGhost.visible = false;
		}
		else if (_tool == HUD.TOOL_MACHINE4)
		{			
			_moduleGhost.loadGraphic(AssetPaths.factory__png);
			_moduleGhost.facing = FlxObject.RIGHT;			
			_arrowGhost.visible = false;
		}
		Owner.add(_moduleGhost);
		Owner.add(_arrowGhost);
	}
	override public function update(elapsed:Float, Owner:MouseController, FSM:FlxFSM<MouseController>)
	{		
		//update graphics on tool change
		if (_tool != GC.currentTool)
		{
			Owner.remove(_moduleGhost);
			_moduleGhost.destroy();	
			Owner.remove(_arrowGhost);
			_arrowGhost.destroy();
			_tool = GC.currentTool;
			addgraphics(Owner);
		}
		
		Owner.highlightBox.x = Math.floor(FlxG.mouse.x / GC.tileSize) * GC.tileSize;
		Owner.highlightBox.y = Math.floor(FlxG.mouse.y / GC.tileSize) * GC.tileSize;
		_moduleGhost.x = Math.floor(FlxG.mouse.x / GC.tileSize) * GC.tileSize;
		_moduleGhost.y = Math.floor(FlxG.mouse.y / GC.tileSize) * GC.tileSize;
		_arrowGhost.x = _moduleGhost.x;
		_arrowGhost.y = _moduleGhost.y;
		
		if (_tool == HUD.TOOL_MACHINE1 || _tool == HUD.TOOL_MACHINE2 || _tool == HUD.TOOL_MACHINE3 || _tool == HUD.TOOL_MACHINE4)
		{
			if (Owner.state.machineController.canAddModule(3,2,Owner.state.worldmap.collisionMap))
			{
				_moduleGhost.color = FlxColor.GREEN;			
			} else {
				_moduleGhost.color = FlxColor.RED;
			}
		}
		
		if (FlxG.mouse.justReleased)
		{		
			if (Owner.state.isClickOnMap() == true)
			{	
				var tiletype:Int = Owner.state.worldmap.collisionMap.getTile(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));				
				
				if (GC.currentTool == HUD.TOOL_CONV_RIGHT)
				{
					if (Owner.state.machineController.canAddModule(1,1,Owner.state.worldmap.collisionMap))
					{
						Owner.state.machineController.addConvE();					
					}
				}
				else if (GC.currentTool == HUD.TOOL_CONV_LEFT)
				{
					if (Owner.state.machineController.canAddModule(1,1,Owner.state.worldmap.collisionMap))
					{
						Owner.state.machineController.addConvW();			
					}
				}
				else if (GC.currentTool == HUD.TOOL_CONV_UP)
				{
					if (Owner.state.machineController.canAddModule(1,1,Owner.state.worldmap.collisionMap))
					{
						Owner.state.machineController.addConvU();			
					}
				}
				else if (GC.currentTool == HUD.TOOL_CONV_DOWN)
				{
					if (Owner.state.machineController.canAddModule(1,1,Owner.state.worldmap.collisionMap))
					{
						Owner.state.machineController.addConvD();			
					}
				}
				else if (GC.currentTool == HUD.TOOL_MACHINE1 || GC.currentTool == HUD.TOOL_MACHINE2 || GC.currentTool == HUD.TOOL_MACHINE3 || GC.currentTool == HUD.TOOL_MACHINE4)
				{
					if (Owner.state.machineController.canAddModule(3,2,Owner.state.worldmap.collisionMap))
					{
						Owner.state.machineController.addMachine( GC.currentTool );					
					}
				}
				else if (GC.currentTool == HUD.TOOL_CRATE)
				{
					Owner.state.machineController.addCrateToModule();					
				}
				
				
				
			}
		}
		
	}
	override public function exit(Owner:MouseController)
	{
		Owner.remove(_moduleGhost);
		_moduleGhost.destroy();
		Owner.remove(_arrowGhost);
		_arrowGhost.destroy();
		
	}
}
class ToolControl extends FlxFSMState<MouseController>
{
	override public function enter(Owner:MouseController, FSM:FlxFSM<MouseController>)
	{
		//trace("Enter ToolDeconstruct");			
		//Owner.highlightBox.visible = true;
		//Owner.highlightBox.color = FlxColor.AQUAMARINE;
	}
	
	override public function update(elapsed:Float, Owner:MouseController, FSM:FlxFSM<MouseController>)
	{		
		Owner.highlightBox.x = Math.floor(FlxG.mouse.x / GC.tileSize) * GC.tileSize;
		Owner.highlightBox.y = Math.floor(FlxG.mouse.y / GC.tileSize) * GC.tileSize;
		if (FlxG.mouse.pressed && Owner.state.isClickOnMap() == true)
		{
			var m:Module = Owner.state.machineController.getModuleAt(Std.int(FlxG.mouse.x / GC.tileSize), Std.int(FlxG.mouse.y / GC.tileSize));
			if (m != null)
			{
				if (Std.is(m, Machine))
				{
					var machine:Machine = cast m;
					Owner.state.hud.showMachineWindow(machine);
					Owner.changeTool(HUD.TOOL_WINDOW);
				}
			}
		}
	}
	override public function exit(Owner:MouseController)
	{
		//Owner.highlightBox.color = FlxColor.WHITE;
		//Owner.highlightBox.visible = false;
	}
}