package fbo.data;
import js.html.Float32Array;
import three.DataTexture;

/**
 * ...
 * @author watanabe
 */
class StartPosTexture
{

	private var _data:Float32Array;
	private var _texture:DataTexture;
	
	public function new(width:Int,height:Int) 
	{
		
		
		_data = getSphere( width*height,width,height, 250 );
        var texture:DataTexture = new DataTexture( 
			_data,
			width,
			height, 
			untyped __js__("THREE.RGBFormat"), 
			untyped __js__("THREE.FloatType"), 
			untyped __js__("THREE.DEFAULT_MAPPING"), 
			untyped __js__("THREE.RepeatWrapping"), 
			untyped __js__("THREE.RepeatWrapping")
		);
        texture.needsUpdate = true;		
		
	}
	
	//private 
	
}