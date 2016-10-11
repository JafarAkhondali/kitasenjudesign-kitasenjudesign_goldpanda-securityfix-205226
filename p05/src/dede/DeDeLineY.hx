package dede;
import dede.cuts.DeDeParam;

/**
 * ...
 * @author watanabe
 */
class DeDeLineY extends DeDeLine
{

	public function new() 
	{
	
		super();
		
	}
	
	/**
	 * 
	 */
	override public function init():Void {
		
		_digits = [];
		var num:Int = 20;
		_width = WIDTH;// num * SPACE;
		
		for (i in 0...num) {
			var digit:DeDeDigit = new DeDeDigit();
			add(digit);			
			//digit.position.x = _spaceX * i - _spaceX * (num-1)/2;
			digit.init();
			digit.setGeoMax(240);
			//digit.setStrokes(nn.substr(i,1),_scale,_space);
			//digit.setType(0);
			_digits.push(digit);
		}		
		
		//
		//reset("A", 0, false, 0, 2 + 2 * Math.random(), 3 + 18 * Math.random(),_spaceX);
		reset(0, DeDeParam.getParam(), false);
	}	
	
	
	override public function reset(
		type:Int, data:DeDeParam, isTypeRandom:Bool = false
	):Void
	{
		//
		_data = data;
		_textIndex = 0;
		
		var len:Int = _data.txt.length;
		
		var ox:Float = -_width / 2 + data.startX;// _digits[0].position.x;

		for (i in 0..._digits.length) {
			
			var t:String = _getNextText();
			var ww:Float = StrokeUtil.getWidth(t,data.font) * SPACE_R;
			_digits[i].position.x = ox + ww/2;// - _width / 2;
			_digits[i].setStrokes(t, SCALE, _data.space, _data.font);//////////////////////////
			_digits[i].reset();
			if (isTypeRandom) {
				type = Math.floor(Math.random() * 6);
			}
			_digits[i].setType( type,data.isRotate );
			_digits[i].update(2);
			ox += (ww + data.spaceX);
			
			if ( i < len ) {
				_digits[i].visible = true;
			}else {
				_digits[i].visible = false;
			}
			
		}
		
		//update();
		_updateLimit();
	}		
	
}