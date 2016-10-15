package;
import createjs.easeljs.Container;
import createjs.easeljs.Matrix2D;
import createjs.easeljs.Shape;
import data.MapData;
import data.MotionData;
import data.StageSize;
import display.ExShaper;
import haxe.Timer;
import js.Browser;
import js.html.ImageElement;
import net.badimon.five3D.typography.HelveticaMedium;
import net.badimon.five3D.typography.Neue;
import net.badimon.five3D.typography.Typography3D;

/**
 * ...
 * @author nabe
 */
class MainDrawer extends Container
{
	
	public static inline var SCALE:Float = 2;
	
	private var _callback:Void->Void;
	private var _img:ImageElement;
	private var _shapes:Array<ExShaper>;
	private var _helv:Typography3D;
	private var _data:MapData;
	private var _flag:Bool=false;
	private var _counter:Int = 0;
	private var _container:Container;
	//private var _rotSpeed:Float = 0;
	private var _isStart:Bool = false;
	private var _motionData:MotionData;
	private var _moji:String;
	
	public function new() 
	{
		super();
	}

	public function init(data:MapData, moji:String, callback:Void->Void):Void {

		_moji = moji;
		
		_data = data;
		_callback = callback;
		
		_flag = Math.random() < 0.5 ? true : false;
		//_helv = new HelveticaMedium();
		_helv = new Neue();
		
		//_rotSpeed = Math.random() < 0.5 ? 0.33 : -0.33;
		
		_img = Browser.document.createImageElement();
		//_img.src = "20160528125235.jpg";
		
		#if debug
			_img.src = "20160528125235.png";
			data.title = "A";
			data.region = "A";
		#else
			_img.src = data.image;//"https://www.gstatic.com/prettyearth/assets/full/1003.jpg";
		#end
		
		_container = new Container();
		addChild(_container);
		_img.onload = _onLoad;
		
	}
	
	/**
	 * _onLoad
	 * @param	e
	 */
	private function _onLoad(e) 
	{
		////////////////////////////////////////start
		_shapes = [];
		//var str:String = "DEDEMOUSE";
		
		//moji
		_makeTypo0();
		
		if (_callback != null) {
			_callback();	
		}
		
	}

	private function _makeTypo0():Void {
		
		var str:String = _moji;// DEDEMOUSE.substr(mojiCount % DEDEMOUSE.length, 1);  //_data.region;// .substr(0, 4);		
		//mojiCount++;
		
		var space:Float = 20;
		
		var width:Float = (str.length-1)*space;//space
		for (i in 0...str.length) {
			width += _helv.getWidth( str.substr(i, 1).toUpperCase() ) * SCALE;
		}
		var ox:Float = -width / 2;// _helv.getWidth( str.substr(0, 1).toUpperCase() ) * SCALE / 2;
		
		var scale:Float = Browser.window.innerWidth / width * 0.4;
		if (str.length >= 3) {
			scale = Browser.window.innerWidth / width;
		}
		_container.scaleX = scale;
		_container.scaleY = scale;
		_container.x = Browser.window.innerWidth / 2;
		_container.y = StageSize.getHeight() / 2;
		
		//
		for (i in 0...str.length) {
			var ss:String = str.substr(i, 1).toUpperCase();
			var ww:Float = _helv.getWidth( ss ) * SCALE;
			ox += ww / 2;
			_makeTypo(
				ss, 
				ox,//-width/2, 
				0,//Browser.window.innerHeight / 2
				scale
			);
			ox += ww/2 + space;
		}
		
		_isStart = true;
	}
	
	private function _makeTypo(moji:String, xx:Float, yy:Float, scale:Float):Void
	{

		var m:Matrix2D = new Matrix2D();
		m.scale(1 / scale, 1 / scale);
		m.translate( 
			(-xx-_container.x/scale), // scale,
			(-yy-_container.y/scale) // scale
		);
		
		_motionData = MotionData.getData();
		
		if (Maps.multiMode) {
			_motionData.mode = Math.random() < 0.5  ? MotionData.MODE_MULTI : MotionData.MODE_ONE;
			
		}else {
			_motionData.mode = MotionData.MODE_ONE;// Math.random() < 0.5  ? MotionData.MODE_MULTI : MotionData.MODE_ONE;
		}
		
				
		var shape:ExShaper = new ExShaper(_motionData);
		
		//shape.graphics.beginStroke("#ffffff");
		shape.graphics.beginBitmapFill(_img, null, m);
		//shape.graphics.beginFill("#ff0000");
		shape.x = xx;
		shape.y = yy;
		
		_container.addChild(shape);
		
		FontTest.getLetterPoints(shape.graphics, moji, true, SCALE, _helv);
		_shapes.push(shape);

		
	}	
	
	
	public function update():Void {

		_counter++;
		
		//parent
		if (_isStart && _motionData.mode==MotionData.MODE_ONE) {
			
			_container.x += _motionData.speedX;
			_container.y += _motionData.speedY;
			_container.rotation += _motionData.speedR;
			
		}
		
		
		if (_shapes != null && _motionData.mode == MotionData.MODE_MULTI) {
			
			var ww:Float = StageSize.getWidth();
			var hh:Float = StageSize.getHeight();
			
			for (i in 0..._shapes.length) {
				
				if(_motionData!=null){
					
					_shapes[i].update(ww,hh);
					
				}
				//if(_flag){
					//_shapes[i].x += 1;// 3 * (Math.random() - 0.5);
					//_shapes[i].y +=	0.5;// 3 * (Math.random() - 0.5);			
				//}else {
				//	_shapes[i].rotation += 0.33;		
				//}		
			}
		}
		
	}
	
	/**
	 * 
	 * @return
	 */
	public function getImage():ImageElement {
		
		return _img;
		
	}
}