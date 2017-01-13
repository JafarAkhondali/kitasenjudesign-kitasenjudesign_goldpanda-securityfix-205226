package;
import createjs.easeljs.Container;
import createjs.easeljs.Matrix2D;
import createjs.easeljs.Shape;
import data.StageSize;
import js.Browser;
import js.html.ImageElement;

/**
 * ...
 * @author nabe
 */
class BgDrawer extends Container
{

	private var _img:ImageElement;
	
	private var _shape1:Shape;
	private var _shape2:Shape;
	
	public function new() 
	{
		super();
	}
	
	/**
	 * 
	 * @param	img
	 */
	public function init(img:ImageElement,ww:Float,hh:Float):Void {
		
		_img = img;
		//
		
		var stgWidth	:Float = ww;// StageSize.getWidth();
		var stgHeight	:Float = hh;// StageSize.getHeight() + 2;
		
		_shape1 = new Shape();
		_shape1.y = 0;
		
		var s:Float = ww / img.width;
		var m:Matrix2D = new Matrix2D();
		m.scale(s,s);
		_shape1.graphics.beginBitmapFill(_img,null,m );
		//_shape1.graphics.beginFill("#ff0000");
		_shape1.graphics.drawRect(0, 0, ww, hh);
		addChild(_shape1);

		/*
		var mm:Matrix2D = new Matrix2D();
		mm.translate(0, -stgHeight / 2+1);

		_shape2 = new Shape();		
		_shape2.y = Math.floor(stgHeight / 2) -1;
		_shape2.graphics.beginBitmapFill(_img,mm);
		_shape2.graphics.drawRect(0, 0, stgWidth, stgHeight/2);
		
		addChild(_shape2);
		*/
	}
	
	/**
	 * update
	 */
	public function update():Void {

	}
	
}