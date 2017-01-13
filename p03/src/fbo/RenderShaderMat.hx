package fbo;
import common.Path;
import three.ImageUtils;
import three.ShaderMaterial;
import three.Texture;
import three.TextureLoader;
import three.Vector2;
import three.Vector3;
import three.WebGLRenderTarget;

/**
 * ...
 * @author watanabe
 */
class RenderShaderMat extends ShaderMaterial
{
	public static inline var animationFrameLength	:Int = 32;

	private var _vertex:String  = "
//float texture containing the positions of each particle
uniform sampler2D positions;
uniform sampler2D texture;
uniform sampler2D bg;
uniform vec2 nearFar;
uniform float pointSize;
varying vec2 vUv;
varying float size;

uniform float scale;
attribute vec2 aOffset;
attribute float rand;
varying vec2 vaOffset;	  

void main() {

	//positions画像のuv と vertexのposition が 対応するようになっている
    //the mesh is a nomrliazed square so the uvs = the xy positions of the vertices
    vec4 col = texture2D( positions, position.xy );
	vec3 pos = col.xyz;
	//float a = col.w;
	//vec3 pos = vec3(position.x * 100.0, position.y * 100.0, 40.0);
	
	vUv = uv;

	vaOffset = aOffset;
	gl_Position = projectionMatrix * modelViewMatrix * vec4( pos, 1.0 );
	gl_PointSize = 2.0 * scale / gl_Position.w;	
	
    //pos now contains the position of a point in space taht can be transformed
    //gl_Position = projectionMatrix * modelViewMatrix * vec4( pos, 1.0 );
    //size
    //gl_PointSize = size = 3.0;// max( 1., ( step( 1. - ( 1. / 512. ), position.x ) ) * pointSize );
}	
	";	
	
	
	
	private var _fragment:String = "
uniform sampler2D texture;
uniform sampler2D bg;
uniform float counter;
varying vec2 vUv;
varying vec2 vaOffset;
uniform vec2 repeat;
void main()
{
			vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
			vec4 color0 = texture2D( texture, uv * repeat + vaOffset  );//
			vec4 color1 = texture2D( bg, vUv );
			//vec2 uv = vec2(gl_PointCoord.x, 1.0 - gl_PointCoord.y);
			//vec4 color0 = texture2D( texture, gl_PointCoord );//
			
			if (color0.w < 0.5) {
				discard;
			}else {
				//1 - ( ( 1 - BGColor ) * ( 1 - ObjectColor ) )
				
				/*
				if (length(color1) > length(color0)) {
					gl_FragColor = color1*0.9;					
				}else {
					gl_FragColor = color0;					
				}
				*/
				vec4 a = vec4(1.0);
			
				a = 1.0 - ( ( 1.0 - color1 ) * ( 1.0 - color0 ) );
				
				/*
				if (length(color1) >= 0.5)
					a = 1.0 - 2.0 * ( 1.0 - color1 ) * ( 1.0 - color0 );
				else 
					a = 2.0 * color0 * color1;				
				*/
					
				gl_FragColor = a * 0.2 + color0 * 0.8;
				
				/*
				if (length(color0) <= 0.5)
					gl_FragColor = color0;
				else 
					gl_FragColor = vec4(color0.xyz - color1.xyz, 1.0);
				*/
				//gl_FragColor = vec4( 1.0 - color0.xyz, 1.0);
				
				
				//gl_FragColor = color0 - color1;// vec4(gl_PointCoord.x, 1.0 - gl_PointCoord.y, 0, 1.0);// color0;
			}
}
	";
	
	
	public function new() 
	{
		var tex:Texture = ImageUtils.loadTexture(Path.assets + "emoji/emoji2048_64.png");
		//tex.format = Three.RGBAFormat;
		
           super( {
                uniforms: {
					bg: { type: "t", value: null },
                    positions: { type: "t", value: null },
                    pointSize: { type: "f", value: 40 },
					texture: { type: "t", value: tex },
					scale: 		{ type: 'f', value: 3000.0 },
					repeat: 	{ type: 'v2', value: new Vector2(1 / animationFrameLength, 1 / animationFrameLength) },
					counter:	{ type: "f", value: 0}
                },
                vertexShader: _vertex,
                fragmentShader: _fragment,
                transparent: true,
                side:Three.DoubleSide,
              //blending:Three.SubtractiveBlending
            } );		
			depthTest = true;
			transparent = true;
			//blending = Three.AdditiveBlending;      
			alphaTest = 0.5;
			
			
	}
	
	//genzan
	public function setBg(t:WebGLRenderTarget):Void {
		
		//uniforms
		uniforms.bg.value = t;
		
		var counter:Float = uniforms.counter.value;
		counter++;
		counter = counter % 10;
		uniforms.counter.value = counter;
		
	}
	
}