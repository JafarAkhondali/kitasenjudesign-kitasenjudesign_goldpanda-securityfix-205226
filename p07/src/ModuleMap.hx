package;
import createjs.easeljs.Container;
import createjs.easeljs.Shape;
import createjs.easeljs.Stage;
import createjs.easeljs.Ticker;
import data.MapData;
import data.MapDataList;
import data.MotionData;
import data.StageSize;
import haxe.Timer;
import js.Browser;
import js.html.CanvasElement;
import js.html.Element;
import js.html.ImageElement;
import js.JQuery;
import net.badimon.five3D.typography.Typography3D;

/**
 * ...
 * @author watanabe
 */
class ModuleMap
{
	
	
	private var _loader:MapDataList;
	private var _canvasName1:String = "canvas1";
	private var _canvasName2:String = "canvas2";
	
	private  var _canvas1:CanvasElement;
	private  var _canvas2:CanvasElement;

	private var _div1:JQuery;
	
	private  var _stage1:Stage;
	private  var _stage2:Stage;

	private  var _circles:Circles;
	private  var _types:Array<String>;
	private  var _typo:MainDrawer;
	
	private  var _bg:BgDrawer;
	private var _data:MapData;
	private var _flag:Bool = false;
	private var _isStart:Bool = false;
	private var _type:Int = 0;
	
	
	
	public function new(type:Int=0) 
	{
	
		if (type == 0) {
			_canvasName1 = "canvas1";
			_canvasName2 = "canvas2";
		}else {
			_canvasName1 = "canvas3";
			_canvasName2 = "canvas4";	
		}
		
		_type = type;
		
		_canvas1 = cast Browser.document.getElementById(_canvasName1);
		_canvas2 = cast Browser.document.getElementById(_canvasName2);
		
		_div1 = new JQuery("#container" + _type );
		_div1.hide();
		
		_stage1 = new Stage(cast _canvas1);
		_stage1.autoClear = false;
		
		_stage2 = new Stage(cast _canvas2);
		_stage2.autoClear = false;
		
	}
	
	public function start():Void {
		
		_isStart = true;
		
	}
	
	public function startRot(delay:Int):Void {
		
		_div1.show();
		Timer.delay(_onStartRot, delay);
		
	}
	
	private function _onStartRot():Void {
		
		_flag = true;
		
	}

	
	//tween0
	public function tween(time:Int=30000,callback:Void->Void=null):Void {
		
		trace("tween");
		
		
		 _flag = false;
		 _div1.stop();
		_div1.css(
			{top:StageSize.getHeight()}
		);
		
		_div1.animate(
			{top:-StageSize.getHeight()},time,'linear',callback
		);

		_onResize(null);
	}
	
	
	public function init(data:MapDataList):Void
	{
		_loader = data;
		
		//new JQuery( Browser.window ).resize(_onResize);
		Browser.window.onresize = _onResize;
		_onResize(null);

		//_stage2.addEventListener("stagemousedown", _onDown);
		//_onDown();
	}
	
	public function next(moji:String):Void {
		

		setMoji(moji);
		
	}
	
	//reload
	private function setMoji(moji:String):Void 
	{
		trace("_onDown");
		if(_stage1!=null){
			_stage1.clear();
			_stage2.clear();
		}
		
		
		_data = _loader.getRandom();
		
		//new JQuery("#region_no").text("LOADING");
		new JQuery("#region_no" + _type).text("#" + _data.id);
		new JQuery("#title" + _type).text(_data.title);
		new JQuery("#title" + _type).off("click");
		new JQuery("#title" + _type).on("click", _goMap);
		
		new JQuery("#google" + _type).off("click");
		new JQuery("#google" + _type).on("click", _goGoogle);
		new JQuery("#google" + _type).text("earthview.withgoogle.com");
		
		new JQuery("#loading" + _type).show();
		new JQuery("#loading" + _type).text("LOADING");
		new JQuery("#title" + _type).text(_data.title);
		
		if (_typo != null) {
			_stage2.removeChild(_typo);
		}
		
		///////////////kokode moji wo shitei
		_typo = new MainDrawer();
		_typo.init(_data, moji, _onLoadMainDrawer);//////////////////LOADER
		_stage2.addChild(_typo);		
		
		//_div1.hide();
		
		_onResize(null);
		
	}
	
	/**
	 * _onLoadMainDrawer
	 */
	private function _onLoadMainDrawer():Void
	{
		//new JQuery("#loading" + _type).hide();
		
		//bg remove
		if (_bg != null) {
			_stage1.removeChild(_bg);
		}
		
		//_div1.show();
		//new JQuery("#canvas2").show();
		
		_bg = new BgDrawer();
		_bg.init(_typo.getImage());
		_stage1.addChild(_bg);
		_stage1.update();
		_stage2.update();

	}
	
	function _goMap(e) 
	{
		//Browser.window.location.href = _data.map;
		Browser.window.open(_data.map, "map");
	}
	function _goGoogle(e) 
	{
		//Browser.window.location.href = _data.map;
		Browser.window.open(_data.url, "google");
	}
	
	function _onResize(e):Void 
	{
		_canvas1.width 		= Browser.window.innerWidth;
		_canvas1.height 	= StageSize.getHeight()+2;
		
		_canvas2.width 		= Browser.window.innerWidth;
		_canvas2.height 	= StageSize.getHeight()+2;
		
		if(_stage1!=null){
			_stage1.clear();
			_stage2.clear();
		}
	}
	
	public function update():Void 
	{
		if (!_isStart) return;
		
		
		if(_typo!=null && _flag){
			_typo.update();
		}
		if (_bg != null) {
			_bg.update();
		}
		
		_stage1.update();
		_stage2.update();
		
	}	
	
}