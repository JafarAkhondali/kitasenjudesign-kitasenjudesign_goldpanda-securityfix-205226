package;
import js.Browser;
import net.badimon.five3D.typography.Typography3D;
import three.ExtrudeGeometry;
import three.Geometry;
import three.Line;
import three.LineBasicMaterial;
import three.Mesh;
import three.MeshBasicMaterial;
import three.Object3D;
import three.Shape;
import three.ShapeGeometry;
import three.Vector2;
import three.Vector3;
import tween.TweenMax;
import typo.FontMeshMaker;
import typo.Stroke;
import typo.StrokeUtil;

/**
 * ...
 * @author watanabe
 */
class BeyondCodeGeo
{
	
	private static var _mojiGeo:Map<String,Dynamic> = new Map<String,Dynamic>();
	private static var _renderOrder:Int = 0;
	public static var mat	:LineBasicMaterial;// = new LineBasicMaterial( { color:0xffffff } );
	public static var mat2	:MeshBasicMaterial;
	public function new() 
	{
		
	}
	
	
	public static function getFillMesh(nn:String, font:Int):Object3D {
	
		if (mat == null) {
			mat = new LineBasicMaterial( { color:0xffffff } );
			mat.transparent = true;
			mat.side = Three.DoubleSide;
		}		
		//Tracer.debug(">>>>>>"+nn);
		
		var o:Object3D = new Object3D();
		
		var name:String = font + "_" + nn+"2";
		var geo:Geometry = _mojiGeo.get(name);

		if(geo==null){
			var ss:Array<Shape> = _getShape(nn, font);
			geo = cast new ShapeGeometry(untyped ss, { } );
			//var geo:ExtrudeGeometry = new ExtrudeGeometry(untyped ss, { amount:10,bevelEnabled:false } );
			_mojiGeo.set(name, geo);
		}
				
		if(geo!=null){
			var line:Mesh = new Mesh(geo, cast mat);// new MeshBasicMaterial( { color:0xff0000 } ));
			line.renderOrder = _renderOrder;
			_renderOrder++;
			o.add(line);
		}
		
		return o;		
		
	}
	
	
	/**
	 * 
	 * @param	nn
	 * @param	font
	 * @return
	 */
	public static function getLine(nn:String,font:Int):Object3D {
		
		if (mat == null) {
			mat = new LineBasicMaterial( { color:0xffffff } );
			mat.transparent = true;
		}
		
		var o:Object3D = new Object3D();
		var geos:Array<Geometry> = getGeo(nn, font);
		for (i in 0...geos.length) {
			var line:Line = new Line(geos[i], mat);
			line.renderOrder = _renderOrder;
			_renderOrder++;
			o.add(line);
		}
		
		return o;
		
	}

	
	
	
	/**
	 * 
	 * @param	nn
	 * @return
	 */
	public static function getGeo(nn:String,font:Int):Array<Geometry> {

		//if (_mojiGeo == null) {
		//	_mojiGeo=new Map<String,Array<Geometry>>();
		//}
		
		var name:String = font +"_" + nn;
		
		if (_mojiGeo.get(name) != null) {
			return _mojiGeo.get(name);
		}
		
		_mojiGeo.set(name, _getGeo(nn,font));
		
		return _mojiGeo.get(name);
		
	}
	
	private static function _getGeo(nn:String,font:Int):Array<Geometry>{
		var geos:Array<Geometry> = [];
			
			var strokes:Array<Stroke> = StrokeUtil.getStrokes(nn, 2*0.65, font);
			
			for (j in 0...strokes.length) {
				
				var vv:Array<Vector2> = strokes[j].getPoints();
				var g:Geometry = new Geometry();
				for (i in 0...vv.length) {
					g.vertices.push(new Vector3(
						vv[i].x,
						-vv[i].y,
						0
					));
				}
				g.vertices.push(new Vector3(
					vv[0].x,
					-vv[0].y,
					0
				));
				
				geos.push(g);
				
			}
		
		return geos;		
	
	}
	
	
	private static function _getShape(nn:String,font:Int):Array<Shape>{
		var geos:Array<Shape> = [];
			
			var strokes:Array<Stroke> = StrokeUtil.getStrokes(nn, 2*0.65, font);
			
			for (j in 0...strokes.length) {
				
				var vv:Array<Vector2> = strokes[j].getPoints();
				var g:Shape = new Shape();
				for (i in 0...vv.length) {
					if (i == 0) {
						g.moveTo(
							vv[i].x,
							-vv[i].y
						);						
					}else{
						g.lineTo(
							vv[i].x,
							-vv[i].y
						);
					}
				}
				g.lineTo(
					vv[0].x,
					-vv[0].y
				);
				
				geos.push(g);
				
			}
		
		return geos;		
	
	}	
	
}

