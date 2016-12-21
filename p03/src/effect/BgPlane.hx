package effect;
import effect.BgShader;
import three.Mesh;
import three.PlaneBufferGeometry;
import three.WebGLRenderer;
import three.WebGLRenderTarget;


/**
 * BgPlane
 */
class BgPlane extends Mesh
{
	var _mat:BgShader;
	var _geo:PlaneBufferGeometry;

	public function new() 
	{
		_geo = new PlaneBufferGeometry(2, 2, 1, 1);
		//_geo = new PlaneBufferGeometry(2, 2, 1, 1);
		_mat = new BgShader();
		//_mat.blending = Three.SubtractiveBlending;
		super(
			cast _geo, _mat
		);
		frustumCulled = false;
		renderDepth = 0;
		
	}
	
	public function update(
		buffer1:WebGLRenderTarget,
		buffer2:WebGLRenderTarget	
	) {
		
		_mat.update(buffer1,buffer2);
		
	}
	
	
	
}

