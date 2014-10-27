package inventory ;
import flixel.FlxSprite;
import flixel.util.FlxColor;

/**
 * ...
 * @author 
 */
class InventoryItem extends FlxSprite
{
	public static var INV_CRATE = 0;
	public static var INV_COAL_RAW = 1;
	public static var INV_IRON_RAW = 2;
	public static var INV_COPPER_RAW = 3;
	
	public static var INV_IRON_BAR = 4;
	public static var INV_IRON_CYLINDER = 5;
	public static var INV_COPPER_BAR = 6;
	public static var INV_COPPER_CYLINDER = 7;
	
	public var invType:Int;
	
	public function new(InvType:Int = 0, X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		invType = InvType;
		
		//makeGraphic(Std.int(GC.tileSize/3),Std.int(GC.tileSize/3),FlxColor.BROWN);
		loadGraphic(AssetPaths.inventorytiles__png, false, 10, 10);
		animation.frameIndex= InvType;
		offset.x = width / 2;
		offset.y = height/ 2;
	}
	public function setInvType(Frame:Int)
	{
		invType = Frame;
		animation.frameIndex =  Frame;
	}
	
}