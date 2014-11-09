package machinewindow;

import flixel.FlxBasic;
import flixel.util.FlxPoint;

/**
 * ...
 * @author 
 */
class RobotOrder
{
	public var ordertype:String;
	public var targetPos:FlxPoint;
	public var amount:Float;
	
	public function new(OrderType:String,TargetPos:FlxPoint=null,Amount:Float=0) 
	{
		ordertype = OrderType;
		targetPos = TargetPos;
		amount = Amount;
		
	}
	
}