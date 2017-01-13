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
	private var _id:String;
	private var _ww:Int = 0;
	private var _hh:Int = 0;
	private var _callback:ModuleMap->Void;
	
	
	public function new(root:JQuery,id:String,ww:Int,hh:Int) 
	{	
		//tekitouni tsuika
		_id = id;
		_ww = ww;
		_hh = hh + 20;
		
		_canvas1 = cast root.children(".canvas1").get(0);
		_canvas2 = cast root.children(".canvas2").get(0);
	
		_div1 = root;
		//_div1.hide();
		
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

	
	//are
	public function tween(time:Int=30000,xx:Float = 0, tgtY:Float= 0, callback:ModuleMap->Void=null):Void {
		
		trace("tween");
		 _flag = false;
		 _callback = callback;
		 _div1.stop();
		_div1.css({
			left:xx,
			top:StageSize.getHeight()
		});
		_div1.velocity(
			{top:tgtY},time,'linear'
		);

		_onResize(null);
		Timer.delay(_onTween, time);
	}
	
	private function _onTween():Void {
		
		//Browser.window.alert("kill");
		_div1.remove();
		if (_callback != null) {
			_callback(this);
		}
		
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
	
	
	public function setMoji(moji:String):Void 
	{
		trace("_onDown");
		if(_stage1!=null){
			_stage1.clear();
			_stage2.clear();
		}
		
		
		_data = _loader.getRandom();
		
		//Browser.window.alert("_data " + _data.title);		
		//new JQuery("#region_no").text("LOADING");
		new JQuery( _id + " .region_no").text("#" + _data.id);
		new JQuery( _id + " .title").text("DEFORMED MONA LISA");
		//new JQuery( _id + " .google").text("earthview.withgoogle.com");
		new JQuery( _id + " .google").text("RINGO ONGAKUSAI VER");
		
		new JQuery( _id + " .loading").show();
		new JQuery( _id + " .loading").text("LOADING");
		
		if (_typo != null) {
			_stage2.removeChild(_typo);
		}
		
		///////////////kokode moji wo shitei
		_typo = new MainDrawer();
		_typo.init(
			_data, moji, _ww,_hh, _onLoadMainDrawer
		);//////////////////LOADER
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
		_bg.init(_typo.getImage(),_ww,_hh);
		_stage1.addChild(_bg);
		_stage1.update();
		_stage2.update();

	}
	
	
	function _onResize(e):Void 
	{
		_canvas1.width 		= _ww;// StageSize.getWidth();
		_canvas1.height 	= _hh;// StageSize.getHeight() + 2;
		
		_canvas2.width 		= _ww;// StageSize.getWidth();
		_canvas2.height 	= _hh;// StageSize.getHeight() + 2;
		
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
		
		//_stage1.update();
		_stage2.update();
		
	}	
	
	public function kill() {
		
		_div1.remove();
		
	}
	
}