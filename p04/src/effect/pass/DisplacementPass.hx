package effect.pass;
import common.Path;
import data.TexLoader;
import sound.MyAudio;
import three.ImageUtils;
import three.postprocessing.ShaderPass;
import three.Texture;

/**
 * ...
 * @author watanabe
 */
class DisplacementPass extends ShaderPass
{
	private var _vertex:String = "
		varying vec2 vUv;
		void main() {
			vUv = uv;
			gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
		}		
	";
	
	private var _fragment:String = "
					uniform sampler2D tDiffuse;
					uniform sampler2D disTexture;
					uniform sampler2D colTexture;
					uniform float strengthX;
					uniform float strengthY;
					uniform float counter;
					uniform float isDisplace;
					uniform float isColor;
					varying vec2 vUv;
					
					vec4 getColor(vec4 texel) {
						
						vec4 out1 = vec4(0.0);
						vec2 pp = vec2( 0.5, fract( texel.x + counter ) );
							if ( pp.y < 0.5) {
								pp.y = pp.y * 2.0;
								out1 = texture2D( colTexture, pp );						
							}else {
								pp.y = (1.0 - (pp.y - 0.5) * 2.0);				
								out1 = texture2D( colTexture, pp );
							}
							if ( texel.x == 0.0 ) {
								out1 = vec4(0.0, 0.0, 0.0, 1.0);
							}		
							return out1;
					}
					
					void main() {
						
						//dispace
						vec4 texel = vec4(0.0);
						
						if(isDisplace == 1.0){
							vec4 col = texture2D( disTexture, vUv);
							float f1 = strengthX * sin(counter*0.17);// pow(counter, 2.0 + 3.0 * col.x);//sin(counter * 3.9) * 0.23;
							float f2 = strengthY * sin(counter*0.22);// pow(counter, 2.0 + 3.0 * col.x) * 0.001;// pow(counter, 2.0 + 3.0 * col.y);//cos(counter * 3.7) * 0.23;
							
							vec2 axis = vec2( 
								vUv.x + (col.y-0.5)*f1, vUv.y + (col.z-0.5)*f2
							);
							
							texel = texture2D( tDiffuse, axis );
						}else {
							
							texel = texture2D( tDiffuse, vUv );
						}
						
						//position
						vec4 out1 = vec4(0.0);
						
						if( isColor == 1.0){
							out1 = getColor(texel);
						}else {
							out1 = texel * 0.99;
						}
						
						gl_FragColor = out1;
					}
	";
	
	
	private var _textures:Array<Texture>;
	private var _colors:Array<Texture>;
	private var _displaceIndex:Int = 0;
	
	
	public function new() 
	{
		_textures = [];
		//for (i in 1...11) {	
		//	_textures.push( ImageUtils.loadTexture("displace/displace" +(i)+".png") );
		//}
		
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace0.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace1.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace2.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace3.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace4.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace5.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace6.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace7.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace8.png") );
		
		_colors = [
			ImageUtils.loadTexture( Path.assets + "grade/grade.png"),
			ImageUtils.loadTexture( Path.assets + "grade/grade2.png"),
			ImageUtils.loadTexture( Path.assets + "grade/grade3.png"),
			ImageUtils.loadTexture( Path.assets + "grade/grade4.png")
		];
		
		super( {
			uniforms: {
				"tDiffuse":	{ type: "t", value: null },
				"isDisplace": 	{ type: "f", value: 1 },
				"isColor": 		{ type: "f", value: 1 },
				"disTexture" : { type: "t", value: _textures[0] },
				"colTexture": { type: "t", value: _colors[3] },
				"strengthX": { type:"f", value:0.5 },
				"strengthY": { type:"f", value:0.5 },
				"counter":{type:"f",value:0}
			},		
			vertexShader: _vertex,
			fragmentShader: _fragment
		});
		
		enabled = true;
		setTexture(true, true);
	}
	
	//
	public function update(audio:MyAudio):Void {
	
		//if (!enabled) return;
		
		trace("update");
		uniforms.strengthX.value = Math.pow( audio.freqByteData[3] / 255, 4) * 0.75;
		uniforms.strengthY.value = Math.pow( audio.freqByteData[7] / 255, 4) * 0.75;
		uniforms.counter.value += 0.1;// audio.freqByteData[3] / 255 * 0.8;		
		
	}
	
	/**
	 * setTexture
	 */
	public function setTexture(isColor:Bool, isDisplace:Bool):Void
	{
		_displaceIndex++;
		
		uniforms.isColor.value = (isColor) ? 1 : 0;
		uniforms.isDisplace.value = (isDisplace) ? 1 : 0;
		
		uniforms.disTexture.value = _textures[ Math.floor( Math.random() * _textures.length ) ];
		uniforms.colTexture.value = _colors[ _displaceIndex % _colors.length ];
		
	}
	
	
}