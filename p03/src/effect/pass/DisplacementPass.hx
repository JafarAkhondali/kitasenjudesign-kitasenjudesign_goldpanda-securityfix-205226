package effect.pass;
import common.Path;
import data.TexLoader;
import js.Browser;
import sound.MyAudio;
import three.ImageUtils;
import three.postprocessing.ShaderPass;
import three.Texture;
import three.WebGLRenderTarget;

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
					uniform sampler2D paper;
					uniform sampler2D tDiffuse;
					uniform sampler2D disTexture;
					uniform sampler2D colTexture;
					uniform sampler2D backBuffer;
					uniform float strengthX;
					uniform float strengthY;
					uniform float strengthZ;	
					uniform float rx;
					uniform float ry;
					
					uniform float counter;
					uniform float isDisplace;
					uniform float isColor;
					varying vec2 vUv;
					
					vec3 rgb2hsv(vec3 c)
					{
						vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
						vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
						vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

						float d = q.x - min(q.w, q.y);
						float e = 1.0e-10;
						return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
					}
					
					vec3 hsv2rgb(vec3 c)
					{
						vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
						vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
						return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
					}					
					
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
							float f1 = strengthX * sin(counter*rx);// pow(counter, 2.0 + 3.0 * col.x);//sin(counter * 3.9) * 0.23;
							float f2 = strengthY * sin(counter*ry);// pow(counter, 2.0 + 3.0 * col.x) * 0.001;// pow(counter, 2.0 + 3.0 * col.y);//cos(counter * 3.7) * 0.23;
							
							vec2 axis = vec2( 
								vUv.x + (col.y-0.5)*f1, vUv.y + (col.z-0.5)*f2
							);
							
							float shiftR = strengthX * 0.01 + 1.0;
							float shiftG = strengthY * 0.01 + 1.0;
							float shiftB = strengthZ * 0.01 + 1.0;
							
							vec4 pp = texture2D( tDiffuse, vUv );
							
								
								float rr = texture2D( tDiffuse, axis * shiftR ).x;
								float gg = texture2D( tDiffuse, axis * shiftG ).y;
								float bb = texture2D( tDiffuse, axis * shiftB ).z;
								
								//float r2 = texture2D(backBuffer, axis * shiftR ).x;
								//float g2 = texture2D(backBuffer, axis * shiftG ).y;
								//float b2 = texture2D(backBuffer, axis * shiftB ).z;
								
					vec4 cc = texture2D( tDiffuse, vUv);
								
								if(length(cc)>0.5){
									texel.x = rr - cc.x * 0.001;
									texel.y = gg - cc.y * 0.001;
									texel.z = bb - cc.z * 0.001;
								}else {
									texel.x = rr;
									texel.y = gg;
									texel.z = bb;									
								}
								texel.w = 1.0;
								

							
						}else {
							
							texel = texture2D( tDiffuse, vUv );
						}
						
						
						//vec4 texel = texture2D( colTexture, axis );
						
						//vec3 luma = vec3( 0.299, 0.587, 0.114 );
						//float v = dot( texel.xyz, luma );//akarusa
						//vec2 axis = vec2( 0.5,v );						
						
						//position
						vec4 out1 = vec4(0.0);
						
						//x zurasu yatsu wo
						if( isColor == 1.0){
							out1 = getColor(texel);
						}else {
							out1 = texel;
						}
						
						//out1 *= 0.999;
						/*
						if ( texel.x == 0.0 || mod( floor( texel.x * 1000.0 + counter ),2.0) == 0.0 ) {
							texel.x = 0.0;
							texel.y = 0.0;
							texel.z = 0.0;							
						}else {
							texel.x = out1.x;//1.0;
							texel.y = out1.y;//1.0;
							texel.z = out1.z;//1.0;														
						}*/
						/*
							texel.x = out1.x;//1.0;
							texel.y = out1.y;//1.0;
							texel.z = out1.z;//1.0;							
						*/
						
						//vec3 col = rgb2hsv(out1.xyz);
						//col.x += 0.001;
						//out1.xyz = hsv2rgb(col);
						
						gl_FragColor = out1;
						//gl_FragColor =  out1;// texel;
					}
	";
	
	
	private var _textures:Array<Texture>;
	private var _colors:Array<Texture>;
	private var _displaceIndex:Int = 0;
	private var _paper:Texture;
	
	public function new() 
	{
		
		_paper = TexLoader.getTexture( Path.assets + "displace/paper.jpg");
		
		_textures = [];
		//for (i in 1...11) {	
		//	_textures.push( ImageUtils.loadTexture("displace/displace" +(i)+".png") );
		//}
		//_textures.push( TexLoader.getTexture( Path.assets + "displace/mona.jpg") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/moji.jpg") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/boro.jpg") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/boro2.jpg") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/boro3.jpg") );
		
		//_textures.push( TexLoader.getTexture( Path.assets + "displace/gray.jpg") );
		//_textures.push( TexLoader.getTexture( Path.assets + "displace/gray2.jpg") );
		
		
		_textures.push( TexLoader.getTexture( Path.assets + "displace/noise.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/noise1.jpg") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/noise2.jpg") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/noise3.jpg") );

		_textures.push( TexLoader.getTexture( Path.assets + "displace/mate2.png") );
		
		
		_textures.push( TexLoader.getTexture( Path.assets + "displace/tone.jpg") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/grid.jpg") );
		
		_textures.push( TexLoader.getTexture( Path.assets + "displace/guruguru.png") );
		
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displaceA.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displaceV.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace.jpg") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displaceH.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace0.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace1.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace2.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace3.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace4.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "displace/displace5.png") );
		_textures.push( TexLoader.getTexture( Path.assets + "grade/grade.png") );
		
		
		_colors = [
			ImageUtils.loadTexture( Path.assets + "grade/grade.png"),
			ImageUtils.loadTexture( Path.assets + "grade/grade2.png"),
			ImageUtils.loadTexture( Path.assets + "grade/grade3.png"),
			ImageUtils.loadTexture( Path.assets + "grade/grade4.png")
		];
		
		
		super( {
			uniforms: {
				"tDiffuse":	{ type: "t", value: null },
				"backBuffer":	{ type: "t", value: null },
				"isDisplace": 	{ type: "f", value: 1 },
				"isColor": 		{ type: "f", value: 1 },
				"disTexture" : { type: "t", value: _textures[0] },
				"colTexture": { type: "t", value: _colors[3] },
				"strengthX": { type:"f", value:0 },
				"strengthY": { type:"f", value:0 },
				"strengthZ": { type:"f", value:0 },
				"rx": { type:"f", value:0 },
				"ry": { type:"f", value:0 },
				"paper":{ type:"t", value: _paper },
				
				"counter":{type:"f",value:0}
			},		
			vertexShader: _vertex,
			fragmentShader: _fragment
		});
		
	}
	
	/**
	 * 
	 * @param	audio
	 */
	public function update(audio:MyAudio,back:WebGLRenderTarget):Void {
	
		if (!enabled) return;
		
		uniforms.strengthX.value = 0.02 + Math.pow( audio.freqByteData[3] / 255, 4) * 0.75;
		uniforms.strengthY.value = 0.02 + Math.pow( audio.freqByteData[7] / 255, 4) * 0.75;
		uniforms.strengthZ.value = 0.02 + Math.pow( audio.freqByteData[5] / 255, 4) * 0.75;
		
		uniforms.counter.value += audio.freqByteData[3] / 255 * 0.8;		
		uniforms.backBuffer.value = back;	
		
	}
	
	/**
	 * setTexture
	 */
	public function setTexture(isColor:Bool, isDisplace:Bool):Void
	{
		_displaceIndex++;
		
		uniforms.isColor.value = (isColor) ? 1 : 0;
		uniforms.isDisplace.value = (isDisplace) ? 1 : 0;
		
		var idx:Int = Math.floor( Math.random() * _textures.length );
		//Browser.window.alert("");

		uniforms.rx.value = 0.02 * (Math.random() - 0.5);
		uniforms.ry.value = 0.02 * (Math.random() - 0.5);
		
		uniforms.disTexture.value = _textures[ idx ];
		uniforms.colTexture.value = _colors[ _displaceIndex % _colors.length ];
		
	}
	
	
}