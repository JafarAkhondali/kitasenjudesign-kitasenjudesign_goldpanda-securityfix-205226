package data;
import js.Browser;

/**
 * ...
 * @author watanabe
 */
class StageSize
{

	public function new() 
	{
		
	}

	public static function getWidth():Float {
		
		return Browser.window.innerWidth;
		
	}
	
	public static function getHeight():Int {
		
		return Browser.window.innerHeight+100; 
		
	}
	
}