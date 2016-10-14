package ;
import js.Browser;



/**
 * ...
 * @author nab
 */

class Main 
{
	
	private static var _maps:Maps;
	
	static function main() 
	{
		new Main();
	}
	
	public function new() {
		Browser.window.onload = initialize;	
	}
	
	private function initialize(e):Void
	{
		_maps = new Maps();
		_maps.init();
		
	}
	
}