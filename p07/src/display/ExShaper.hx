package display;
import createjs.easeljs.Shape;
import data.MotionData;

/**
 * ...
 * @author watanabe
 */
class ExShaper extends Shape
{

	public var vx:Float = 0;
	public var vy:Float = 0;
	public var vr:Float = 0;
	
	private var _data:MotionData;
	
	public function new(data:MotionData) 
	{
		super();
		
		_data = data;
		
		if (_data.mode == MotionData.MODE_MULTI) {
			
			/*
			vx = (Math.random() - 0.5) * 2;
			vy = (Math.random() - 0.5) * 2;
			vr = (Math.random() - 0.5 ) * 0.5;
			*/
			
			var n1:Float = 0.5 + Math.random();
			vx = _data.speedX * n1;//(Math.random() - 0.5) * 2;
			vy = _data.speedY * n1;//(Math.random() - 0.5) * 2;
			vr = _data.speedR;//(Math.random() - 0.5 ) * 0.5;
			
		}else {
			
			vx = _data.speedX;
			vy = _data.speedY;
			vr = _data.speedR;
			//(Math.random() - 0.5 ) * 2;			
		}
	}
	
	
	public function update(limX:Float,limY:Float):Void
	{
		
		this.x += vx;
		this.y += vy;
		this.rotation += vr;
		
		//limit
		_limit(limX, limY);
		
	}
	
	private function _limit(limX:Float,limY:Float):Void {
		
		if (x < -limX/2) {
			x = 0;
			vx *= -1;
		}
			
		if (x > limX/2 ) {
			x = limX/2;
			vx *= -1;
		}
			
		///////Y
		if (y < -limY/2) {
			y = -limY/2;
			vy *= -1;
		}
			
		if (y > limY/2 ) {
			y = limY/2;
			vy *= -1;
		}				
		
	}
	
	
}