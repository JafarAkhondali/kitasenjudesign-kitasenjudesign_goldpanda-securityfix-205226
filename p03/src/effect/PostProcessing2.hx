package effect;
import effect.BgPlane;
import effect.pass.DisplacementPass;
import effect.pass.XLoopPass;
import effect.shaders.CopyShader;
import sound.MyAudio;
import three.PerspectiveCamera;
import three.postprocessing.EffectComposer;
import three.postprocessing.RenderPass;
import three.postprocessing.ShaderPass;
import three.Scene;
import three.WebGLRenderer;

/**
 * ...
 * @author nabe
 */
class PostProcessing2
{

	public static inline var MODE_NORMAL			:String = "MODE_NORMAL";
	public static inline var MODE_DISPLACEMENT_A	:String = "MODE_DISPLACEMENT_A";
	public static inline var MODE_DISPLACEMENT_B	:String = "MODE_DISPLACEMENT_B";
	public static inline var MODE_COLOR				:String = "MODE_COLOR";
	
	private var _modeList:Array<String> = [
		MODE_NORMAL,
		MODE_DISPLACEMENT_A,
		MODE_DISPLACEMENT_B,
		MODE_COLOR
	];
	
	private var _mode:Int = 0;
	private var _renderPass:RenderPass;
	private var _composer:EffectComposer;
	private var _displacePass	:DisplacementPass;
	private var _xLoopPass		:XLoopPass;
	
	private var _scene	:Scene;
	private var _camera	:PerspectiveCamera;
	private var _copyPass:ShaderPass;
	private var _rad:Float=0;
	private var _renderer:WebGLRenderer;
	
	//private var _textures:Array<Texture>;
	//private var _currentTexture:Texture;
	//private var _callback:Void->Void;
	private var strength:Float=0;
	private var _plane:BgPlane;
	
	public function new() 
	{
		
	}

	/**
	 * 
	 * @param	scene
	 * @param	camera
	 * @param	renderer
	 */
	public function init(scene:Scene,camera:PerspectiveCamera,renderer:WebGLRenderer):Void {
		
		_scene = scene;
		_camera = camera;
		_renderer = renderer;
		
		_plane = new BgPlane();
		_scene.add(_plane);		
		
		_renderPass = new RenderPass( scene, camera );
		//_renderPass
		_copyPass = new ShaderPass( CopyShader.getObject() );
		
		_composer = new EffectComposer( renderer );
		_composer.addPass( _renderPass );
		
		_displacePass = new DisplacementPass();
		_displacePass.enabled = true;
		_composer.addPass( _displacePass );
		
		_xLoopPass = new XLoopPass();
		_xLoopPass.enabled = true;
		//_composer.addPass( _xLoopPass );
		//passes
		//_xLoopPass = new XLoopPass();
		//_xLoopPass.enabled = true;
		//_composer.addPass(_xLoopPass);
		
		_composer.addPass( _copyPass );
		_copyPass.clear = true;
		_copyPass.renderToScreen = true;
		
		change(false, true);
	}
	
	
	//color 
	//displace1
	//displace2
	public function change(isColor:Bool,isDisplace:Bool):Void {
		
		_xLoopPass.setTexture(isColor,isDisplace);
		_displacePass.setTexture(isColor, isDisplace);
		
	}
	
	//changeMode 
	/*
	public function changeMode():Void {
		
		var s:String = _modeList[_mode % _modeList.length];
		switch(s) {
			case MODE_NORMAL:
				trace("a");
			case MODE_DISPLACEMENT_A:
				trace("b");
			case MODE_DISPLACEMENT_B:
				trace("c");				
			case MODE_COLOR:
				trace("d");			
		}
		
		_mode++;
	}*/
	
	
	public function update(audio:MyAudio) 
	{
		_xLoopPass.update(audio);
		_displacePass.update(audio);
		
		_composer.render();
		_plane.update(_composer.renderTarget1, _composer.renderTarget2);
		
		
		/*
		tilt.uniforms.v.value = 2 / 512 + 1 / 512 * Math.sin(_rad);
		_rad += Math.PI / 100;
		
		if (audio!=null && audio.isStart) {
			vig.uniforms.darkness.value = 1.1-Math.pow(audio.freqByteData[10] / 255, 4.5)*0.1;
		}*/
	}
	
	public function resize(w:Int, h:Int) 
	{
		_composer.setSize(w, h);
	}
	
	
}