package;
import common.Dat;
import common.dat.Dat2;
import common.Key;
import createjs.easeljs.Ticker;
import data.MapDataList;
import data.StageSize;
import haxe.Timer;
import js.Browser;
import js.JQuery;
import sound.MyAudio;

/**
 * ...
 * @author watanabe
 */
class Maps
{

	private var _maps:Array<ModuleMap> = [];
	
	private var _loader:MapDataList;
	private var _mojiCount:Int = 0;
	private var _audio:MyAudio;
	private var _count:Int = 0;
	private var _numX:Int = 1;
	public static inline var DEDEMOUSE:String = "DEDEMOUSE";
	
	public static var multiMode:Bool = false;
	
	
	public function new() 
	{
		
	}
	
	public function init():Void {
		
		_loader = new MapDataList();
		_loader.load(_onLoad);
	}
	
	private function _onLoad():Void{

		Dat.init(_start0);
	}
	
	private function _start0():Void {
		
		_audio = new MyAudio();
		_audio.init(_start);	
	}
	
	private function _start():Void{
		
		gen(_numX);
		
		Ticker.setFPS(30);
		Ticker.addEventListener("tick", _update);
		
		//Dat.gui.add(this, "_next");
		Key.board.addEventListener(Key.keydown, _onDown);
		
	}
	
	private function _onDown(e) {
		
		switch(e.keyCode) {
			case Dat.Q:
				_numX = 1;
			case Dat.W:
				_numX = 2;				
			case Dat.E:
				_numX = 3;				
			case Dat.RIGHT:
				multiMode = !multiMode;
		}
		
	}
	
	//
	private function gen(num:Int):Void {
	
		var ww:Int = Math.floor(StageSize.getWidth() / num);
		var hh:Int = Math.floor(StageSize.getWidth() / num * 3 / 5);
		var distance:Float = StageSize.getHeight() + hh;
		var time:Int = Math.floor( 40000 * (distance / (StageSize.getHeight() * 2)) );
		
		for(i in 0...num){
			var map:ModuleMap = ModuleMapMaker.getMap(
				"unko"+_count,
				ww,
				hh
			);
			map.init(_loader);
			map.tween(time,Math.floor(ww*i),-hh,_onRemove);
			map.startRot(13000);
			map.setMoji(_getMoji());		
			map.start();
			_maps.push(map);
			_count++;
		}
		
		
		var v:Float = distance / time;
		var nextTime:Int = Math.floor(hh / v);
		Timer.delay(_onGen, nextTime);
		
	}
	
	private function _onRemove(tgt:ModuleMap):Void
	{
		Tracer.debug("remove num->"+_maps.length);		
		_maps.splice(_maps.indexOf(tgt), 1);
	}
	
	
	private function _onGen() {
		
		gen(_numX);// 1 + Math.floor(3 * Math.random()));
		
	}
	
	
	private function _update(e):Void {
		
		for (i in 0..._maps.length) {
			_maps[i].update();
		}
		
	}
	
	
	private function _getMoji():String {
		
		if (multiMode) {
			return "DEDEMOUSE";
		}
		
		var m:String = DEDEMOUSE.substr(_mojiCount % DEDEMOUSE.length, 1); 
		_mojiCount++;
		return m;
		
	}	
	
	
	
}