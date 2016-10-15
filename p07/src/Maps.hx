package;
import common.Dat;
import common.dat.Dat2;
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
	var _mojiCount:Int = 0;
	public static inline var DEDEMOUSE:String = "DEDEMOUSE";
	
	public static var multiMode:Bool = true;
	
	public function new() 
	{
		
	}
	
	public function init():Void {
		
		_loader = new MapDataList();
		_loader.load(_onLoad);
	}
	
	private function _onLoad():Void{

		Dat.init(_start);
	}
	
	private function _start():Void{
		_map1 = new ModuleMap(0);///////////////tween
		_map2 = new ModuleMap(1);
		
		_map1.init(_loader);
		_map2.init(_loader);
		
		Ticker.setFPS(30);
		Ticker.addEventListener("tick", _update);
		
		Dat.gui.add(this, "_next");
		
		
		_tween();
	}
	
	
	private function _next():Void {
		
		multiMode = !multiMode;
		
	}
	
	
	//tween __ 
	private function _tween():Void
	{
		
		trace("_tween");
		_map2.tween(40000);
		_map2.startRot(12000);
		_map2.next(_getMoji());
		Timer.delay(_tween2, 20000);
		
	}
	
	//
	private function _tween2():Void
	{
		
		trace("_tween2");
		_map1.tween(40000);
		_map1.startRot(12000);
		_map1.next(_getMoji());
		Timer.delay(_tween, 20000);
		
	}
	
	private function _getMoji():String {
		
		if (multiMode) {
			return "DEDEMOUSE";
		}
		
		var m:String = DEDEMOUSE.substr(_mojiCount % DEDEMOUSE.length, 1); 
		_mojiCount++;
		return m;
		
	}
	
	
	private function _update(e):Void {
		
		_map1.update();
		_map2.update();
		
	}
	
	
	
	
	
	
}