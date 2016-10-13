package canvas.primitives;
import common.MyDAELoader;
import sound.MyAudio;
import three.BoxGeometry;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.Vector3;

/**
 * ...
 * @author watanabe
 */
class Hachigatsu extends PrimitiveBase
{
	//face wo load
	private var _loader:MyDAELoader;
	
	public function new() 
	{
		super();
	}
	
	override public function init(o:Dynamic):Void {
		super.init(o);
		
		if(_loader==null){
			_loader = new MyDAELoader();
			//_loader.load("dae/katori.dae", _onLoad);
			_loader.load("dae/8gatsu11.dae", _onLoad);
			
		}
		//var cube:Mesh = new Mesh(new BoxGeometry(100, 100, 100, 1, 1, 1), new MeshBasicMaterial( { color:0xff0000 } ));
		//add(cube);
	}
	
	
	private function _onLoad():Void
	{
		this.visible = false;		
		_loader.dae.scale.x = 0.8;
		_loader.dae.scale.y = 0.8;
		_loader.dae.scale.z = 0.8;
		
		this.rotation.x = Math.PI / 2;
		
		add( _loader.dae );
		
	}
	

	override public function update(a:MyAudio,rotV:Vector3):Void {
	
		
		this.rotation.x += 0.01;
		this.rotation.y += 0.015;
		this.rotation.z += 0.013;
		
		//this.rotation.y += rotV.y * 0.5 + 0.01;
		
		//super.update(a, rotV);
		
	}	
	
}