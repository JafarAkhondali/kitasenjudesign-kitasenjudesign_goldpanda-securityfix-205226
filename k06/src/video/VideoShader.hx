package video;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageData;
import js.html.Uint8ClampedArray;
import js.html.VideoElement;
import three.ShaderMaterial;
import three.Texture;


class VideoShader extends ShaderMaterial
{

	//vertex shader
	private var vv:String = "
	
		varying vec2 vUv;
		void main()
		{
			vUv = uv;
			//position.x = sin(position.y) * 0.1 + position.x;
			vec4 hoge = vec4(position, 1.0);//matrix keisan shinai
			hoge.z = 1.0;
			gl_Position = hoge;
		}	
	
	";

	//fragment shader
	private var ff:String = "
	
		uniform sampler2D texture;
		varying vec2 vUv;                                             
		void main()
		{
			gl_FragColor = texture2D(texture, vUv);
		}	
	
	";
	
	private var _canvas	:CanvasElement;
	private var _context:CanvasRenderingContext2D;
	private var _texture	:Texture;
	
	public function new() 
	{
		
		_canvas = Browser.document.createCanvasElement();
		_canvas.width = 512*2;
		_canvas.height = 512;
		_context = _canvas.getContext2d();
		
		_texture = new Texture( _canvas );
		_texture.needsUpdate = true;
		
		//_context
		
		/*
			video = document.getElementById( 'video' );
			texture = new THREE.VideoTexture( video );
			texture.minFilter = THREE.LinearFilter;
			texture.magFilter = THREE.LinearFilter;
			texture.format = THREE.RGBFormat;
		*/
		
		super({
			vertexShader: vv,
			fragmentShader: ff,
			uniforms: {
				texture: { type: 't', value: _texture }	
			}			
		});
		this.fog = false;
	}

	/**
	 * update
	 * @param	a
	 * @param	vi
	 */
	public function update(vi:VideoElement):Void {
		
		//video wo capture suru
		if(vi!=null){
			_context.drawImage(vi, 0, 0, vi.width, vi.height, 0, 0, _canvas.width, _canvas.height);
			_texture.needsUpdate = true;
		}
		//update
		
	}

	
	/*
 var imageData = context.getImageData(0, 0, 2, 2);
  console.log(imageData.width); // 出力：2
  console.log(imageData.height); // 出力：2
  console.log(imageData.data); // 出力：CanvasPixelArray
};
	*/
	
	
	/**
	 * 
	 * @param	rx 0-1
	 * @param	ry 0-1
	 */
	public function getPixel(rx:Float, ry:Float):Int {
		
		var idxX:Int = Math.floor( _canvas.width * rx );
		var idxY:Int = Math.floor( _canvas.height * ry );
		
		var data:ImageData = _context.getImageData(idxX,idxY,1,1);
		var col:Dynamic = data.data[0];
		
		var rr:Int = col[0];
		var gg:Int = col[1];
		var bb:Int = col[2];
		var aa:Int = col[3];
		
		var rgba:Int = ((aa << 24) + (rr << 16) + (gg << 8) + bb);
		
		return rgba;
	}
	
	
	
	
}