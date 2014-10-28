package ;

import hud.Ding;

class Accountant 
{
	
	public static var hourCount:Float = 0;
	public static var dayCount:Float = 1;
	public static var weekCount:Float = 1;
	public static var monthCount:Float = 1;
		
	public static var money:Float = 2400;
			
	public static var stockCapacity:Int = 100;
	public static var stockCurrent:Int = 0;
						
	public static function tick() {
				
		hourCount ++;		
		if (hourCount > 23) {
			hourCount = 0;
			dayCount += 1;				
		}
		if (dayCount == 8) {
			dayCount = 1;
			weekCount += 1;
		}
		if (weekCount == 5) {
			weekCount = 1;
			monthCount += 1;		
		}
				
	}	
		
	public static function moneyLose(amount:Int) {
		money -= amount;
	}
	public static function moneyGain(amount:Int) {
		money += amount;		
	}
	
/**
	Uses ressources. Returns bool if stock is sufficient.
**/	/*	
	public static function getRessources(amount:Int):Bool {
		if (stockRessources >= amount)
		{
			stockRessources -= amount;
			//MachineManager.removeRess();
			
			return true;
		} 
		else 
		{
			
			return false;
		}
		
	}
	public static function hasRessources(amount:Int):Bool {
		if (stockRessources >= amount)
		{			
			return true;
		} 
		else 
		{
			return false;
		}	
	}*/

/**
	Buy ressources. Returns bool if money is sufficient.
**/	/*
	public static function buyRessources(amount:Int):Bool {
		if (buyPriceRessources*amount <= money && stockRessources+stockPart1+stockPart2+stockToy+amount <= stockCapacity)
		{
			stockRessources += amount;
			money -= buyPriceRessources * amount;
			statSpendingRessources += buyPriceRessources * amount;			

			var ding:Ding = new Ding(25, GC.CoordBottomBarY-5, "+" + amount);
			hudGrp.add(ding);

			return true;
		} 
		else 
		{
							
			return false;
		}
	}*/

	
	
	
}