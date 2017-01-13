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
		_mat = new BgShader();
		
		super(
			cast _geo, _mat
		);
		
	}
	
	public function update(buffer:WebGLRenderTarget) {
		
		_mat.update(buffer);
		
	}
	
	
	
}

