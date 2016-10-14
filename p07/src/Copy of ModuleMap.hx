package;
import createjs.easeljs.Container;
import createjs.easeljs.Shape;
import createjs.easeljs.Stage;
import createjs.easeljs.Ticker;
import data.MapData;
import data.MapDataList;
import data.MotionData;
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
	private var _div2:JQuery;
	
	private  var _stage1:Stage;
	private  var _stage2:Stage;

	private  var _circles:Circles;
	private  var _types:Array<String>;
	private  var _typo:MainDrawer;
	
	private  var _bg:BgDrawer;
	private var _data:MapData;
	
	public function new(type:Int=0) 
	{
	
		if (type == 0) {
			_canvasName1 = "canvas1";
			_canvasName2 = "canvas2";
		}else {
			_canvasName1 = "canvas3";
			_canvasName2 = "canvas4";	
		}
		
		_canvas1 = cast Browser.document.getElementById(_canvasName1);
		_canvas2 = cast Browser.document.getElementById(_canvasName2);
		
		_div1 = new JQuery("#"+_canvasName1);
		_div2 = new JQuery("#"+_canvasName2);
		
	}
	
	public function init():Void
	{

		
		_loader = new MapDataList();
		_loader.load(_onLoad);
		
		//
	}
	
	//tween0
	public function tween():Void {
		
		trace("tween");
		 
		
		_div1.velocity(
			{top:-1000},20000,'linear'
		);
		_div2.velocity(
			{top:-1000},20000,'linear'
		);
		_div1.css(
			{top:Browser.window.innerHeight}
		);
		_div2.css(
			{top:Browser.window.innerHeight}
		);		
		
	}
	
	
	private function _onLoad():Void{
		
		
		_stage1 = new Stage(cast _canvas1);
		_stage1.autoClear = false;
		
		_stage2 = new Stage(cast _canvas2);
		_stage2.autoClear = false;
		
		//Ticker.setFPS(30);
		//Ticker.addEventListener("tick", _update);
		
		//new JQuery( Browser.window ).resize(_onResize);
		Browser.window.onresize = _onResize;
		_onResize(null);

		//_stage2.addEventListener("stagemousedown", _onDown);
		_onDown();
	}
	

	//reload
	private function _onDown(e=null):Void 
	{
		trace("_onDown");
		
		//new JQuery("#canvas1").hide();
		//new JQuery("#canvas2").hide();
		
		_stage1.clear();
		_stage2.clear();
		
		
		_data = _loader.getRandom();
		
		//new JQuery("#region_no").text("LOADING");
		new JQuery("#region_no").text("#" + _data.id);
		
		new JQuery("#title").text(_data.title);
		
		new JQuery("#title").off("click");
		new JQuery("#title").on("click", _goMap);
		new JQuery("#google").off("click");
		new JQuery("#google").on("click", _goGoogle);
		new JQuery("#google").text("earthview.withgoogle.com");
		new JQuery("#loading").show();
		new JQuery("#loading").text("LOADING");
		new JQuery("#title").text(_data.title);
		
		if (_typo != null) {
			_stage2.removeChild(_typo);
		}
		_typo = new MainDrawer();
		_typo.init(_data,_onLoadMainDrawer);
		_stage2.addChild(_typo);		
		
		_onResize(null);
		
	}
	
	/**
	 * _onLoadMainDrawer
	 */
	private function _onLoadMainDrawer():Void
	{
		new JQuery("#loading").hide();
		
		//bg remove
		if (_bg != null) {
			_stage1.removeChild(_bg);
		}
		
		//new JQuery("#canvas1").show();
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
		_canvas1.height 	= Browser.window.innerHeight;
		
		_canvas2.width 		= Browser.window.innerWidth;
		_canvas2.height 	= Browser.window.innerHeight;
		
		/*
		new JQuery("#loading").css(
			{
				left:Browser.window.innerWidth / 2 - new JQuery("#loading").width() / 2,
				top:10
			}
		);
		
		new JQuery("#footer").css({
			{
				left:Browser.window.innerWidth / 2 - new JQuery("#footer").width() / 2,
				top:Browser.window.innerHeight - new JQuery("#footer").height() - 20
			}
		});		*/
		
		_stage1.clear();
		_stage2.clear();
		
	}
	
	public function update():Void 
	{
		
		if(_typo!=null){
			_typo.update();
		}
		if (_bg != null) {
			_bg.update();
		}
		
		_stage1.update();
		_stage2.update();
		
	}	
	
}