package;
import createjs.easeljs.Ticker;
import data.MapDataList;
import haxe.Timer;
import js.Browser;

/**
 * ...
 * @author watanabe
 */
class Maps
{

	private var _map1:ModuleMap;
	private var _map2:ModuleMap;
	var _loader:MapDataList;
	
	public function new() 
	{
		
	}
	
	public function init():Void {
		
		_loader = new MapDataList();
		_loader.load(_onLoad);
	}
	
	private function _onLoad():Void{

		_map1 = new ModuleMap(0);///////////////tween
		_map2 = new ModuleMap(1);
		
		_map1.init(_loader);
		_map2.init(_loader);
		
		Ticker.setFPS(30);
		Ticker.addEventListener("tick", _update);
		
		_tween();
	}
	
	
	//tween __ 
	private function _tween():Void
	{
		_map2.tween(40000);
		_map2.startRot(10000);
		_map2.next();
		
		Timer.delay(_tween2, 20000);
	}
	
	//
	private function _tween2():Void
	{
		_map1.tween(40000);
		_map1.startRot(10000);
		_map1.next();
		
		Timer.delay(_tween, 20000);
	}
	
	
	private function _update(e):Void {
		
		_map1.update();
		_map2.update();
		
	}
	
	
	
	
	
	
}