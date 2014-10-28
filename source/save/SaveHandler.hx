package save;
import classes.TilePos;
import machine.Module;

/**
 * ...
 * @author 
 */
class SaveHandler
{

	public function new(state:PlayState) 
	{
		
		for (m in state.machineController.moduleArr)
		{
			var tilePos:TilePos = m.tilePos;
			var classname = Type.getClassName( Type.getClass(m) );
			trace("save " + classname + ", " + tilePos.tileX + "x" + tilePos.tileY);	
			//trace("Module : " +  m.toString());			
		}
		/*
		var mod =  state.machineController.moduleArr[0];
		var tilePos:TilePos = mod.tilePos;
		tilePos.tileY -= 3;
		var classname = Type.getClassName( Type.getClass(mod) );		
		state.machineController.addModule(classname, tilePos);
		*/
	}
	
}