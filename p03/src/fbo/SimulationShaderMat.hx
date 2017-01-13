package fbo;
import js.html.Float32Array;
import fbo.shaders.CurlNoise;
import sound.MyAudio;
import three.DataTexture;
import three.Mapping;
import three.ShaderMaterial;
import three.Texture;
import three.Vector3;
import three.Vertex;

/**
 * ...
 * @author watanabe
 */
class SimulationShaderMat extends ShaderMaterial
{

	
/////////////////////////////////////		
	private var _vertex:String  = "
		varying vec2 vUv;
		varying float vLife;
		varying vec3 vStarts;
		attribute float life;
		attribute vec3 starts;
		//varying float fragDepth;
		void main() {
			vLife = life;
			
			vUv = vec2(uv.x, uv.y);
			vStarts = starts;
			gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
		}	
	";
	
	
	
	
/////////////////////////////////////	
	private var _fragment:String = CurlNoise.glsl+ "

		// simulation

		varying vec2 vUv;
		varying float vLife;
		varying vec3 vStarts;
		uniform sampler2D texture;
		uniform float timer;//timer = 0;
		uniform float frequency;
		uniform float amplitude;
		uniform float maxDistance;
		uniform float freqByteData[32];
		uniform float strength;
		uniform vec3 freqs;
		uniform vec3 start;
		uniform float resetFlag;
		
		void main() {

			vec2 uvv = vUv;
			uvv.y = 1.0 - uvv.y;
			vec4 pixel = texture2D( texture, uvv );//irowo hirou
			vec3 pos = pixel.xyz;
			float aa = pixel.a;// fract( pixel.w + timer );
			
			float ss = 1.0;
			float rr = 0.6 * sin(timer * 0.1);
			vec3 vv = curlNoise(pos * rr);/////koko
			vv.x *= freqs.x / 255.0 * 8.0 * strength * ss;
			vv.y *= freqs.y / 255.0 * 8.0 * strength * ss;
			vv.z *= freqs.z / 255.0 * 8.0 * strength * ss;
			
			pos = pos + vv;// * freqByteData[3] / 255.0 * 10.0;
			//pos = vec3(vUv.x*20.0+vv.x*10.0,vUv.y*20.0,0.0);
			
			//pos.y += hoge.y * 2.1;
			//pos.z += hoge.z * 2.1;
			
			//if ( a < 0.0 || resetFlag == 1.0 ) {
			
			//if(aa<=0.1){
			if ( resetFlag == 1.0 ) {
				//aa = 100.0;
				pos =  curlNoise( pos * vec3(aa, aa, aa) * 1000.0 * sin(timer) ) * 20.0 * sin( -timer);
				//pos = start + curlNoise( vec3(vLife * 10.0, vLife * 11.1, vLife * 13.3) ) * 10.0;// * 0.01;
				//a = curlNoise( pos * pixel.w ).x;
			}
			
			gl_FragColor = vec4( pos, aa );//pos wo hozon

		}	
	";
	
	
	private var _idx1:Int = 0;
	private var _idx2:Int = 1;
	private var _idx3:Int = 2;
	private var _rad:Float =0;
	private var _isReset:Bool = false;
	
	
	public function new(ww:Int, hh:Int) 
	{
		var width:Int = ww;
		var height:Int = hh;
		
//var texture = new THREE.DataTexture( data, width, height, THREE.RGBFormat, THREE.FloatType, THREE.DEFAULT_MAPPING, THREE.RepeatWrapping, THREE.RepeatWrapping );
		
		var data:Float32Array = getSphere( width*height,width,height, 250 );
        var texture:DataTexture = new DataTexture( 
			data,
			width,
			height, 
			untyped __js__("THREE.RGBAFormat"), 
			untyped __js__("THREE.FloatType"), 
			untyped __js__("THREE.DEFAULT_MAPPING"), 
			untyped __js__("THREE.RepeatWrapping"), 
			untyped __js__("THREE.RepeatWrapping")
		);
        texture.needsUpdate = true;

       super({
                uniforms: {
                    texture: { type: "t", value: texture },
                    //texture2: { type: "t", value: texture },
                    timer: { type: "f", value: 0},
                    frequency: { type: "f", value: 0.01 },
                    amplitude: { type: "f", value: 96 },
                    maxDistance: { type: "f", value: 48 },
					freqByteData:{type:"fv1",	value:MyAudio.a.freqByteDataAry},//Uint8Array
					freqs: { type: "v3", value: new Vector3( 0, 1, 2 ) },
					start: { type: "v3", value: new Vector3( 0, 1, 2 ) },
					strength: { type: "f", value: 1 },
					resetFlag: { type: "f", value: 0 }
                },
                vertexShader: _vertex,
                fragmentShader:  _fragment
        });		
		transparent=true;
	}
	
	public function next():Void {
		
		_idx1 = Math.floor( 12 * Math.random() );
		_idx2 = Math.floor( 12 * Math.random() );
		_idx3 = Math.floor( 12 * Math.random() );
		
	}
	
	/**
	 * 
	 * @param	a
	 */
	public function update(a:MyAudio):Void {
		
		uniforms.timer.value += 0.01;
		uniforms.freqByteData.value = a.freqByteDataAry;
		uniforms.freqs.value.x = a.freqByteDataAry[_idx1];
		uniforms.freqs.value.y = a.freqByteDataAry[_idx2];
		uniforms.freqs.value.z = a.freqByteDataAry[_idx3];
		
		var amp:Float = 300;
		_rad += 0.01;
		
		uniforms.start.value.x = amp * Math.sin( _rad*0.86 );
		uniforms.start.value.y = amp * Math.cos( _rad*0.79 );
		uniforms.start.value.z = amp * Math.sin( _rad * 0.90 );
		
		if (_isReset) {
			trace("RESET");
			uniforms.resetFlag.value = 1;
			_isReset = false;
		}else {
			uniforms.resetFlag.value = 0;			
		}
	}
	
	
	/**
	 * 
	 * @param	count
	 * @param	size
	 * @return
	 */
	private function getSphere( count:Int, ww:Int, hh:Int, size:Float ):Float32Array{

            var len:Int = count * 4;
            var data = new Float32Array( len );
            var p:Vector3 = new Vector3();
			
			var i:Int = 0;
            for( j in 0...len )
            {
                p = getPoint(size,ww,hh,j);
                data[ i     ] = p.x;
                data[ i + 1 ] = p.y;
                data[ i + 2 ] = p.z;
				data[ i + 3 ] = Math.random();
				i += 4;
            }
            return data;
    }
	
	public function reset():Void {
		
		//reset = 1 nisuru
		_isReset = true;
	}
	
	
	private function getPoint(size:Float,ww:Int,hh:Int,j:Int ):Vector3
    {
            //the 'discard' method, not the most efficient
			/*
			var list:Array<Vertex> = FboMain.dae.meshes[0].geometry.vertices;
			var v3:Vector3 = list[Math.floor(list.length * Math.random())].clone();
			*/
			var v3:Vector3 = new Vector3();
			v3.x = 100 * (Math.random() - 0.5);
			v3.y = 100 * (Math.random() - 0.5);
			v3.z = 100 * (Math.random() - 0.5);
			
			//v3.x = (j % hh) * 10;
			//v3.y = Math.floor( j / hh ) * 10;
			//v3.z = 0;
			
			//v3.x += 20 * (Math.random() - 0.5);
			//v3.y += 20 * (Math.random() - 0.5);
			//v3.z += 20 * (Math.random() - 0.5);
			
			return v3;
    }
	
}