package typo;
import net.badimon.five3D.typography.HelveticaMedium;
import net.badimon.five3D.typography.HelveticaMedium;
import three.Geometry;
import three.Mesh;
import three.Path;
import three.Shape;
import net.badimon.five3D.typography.Typography3D;
import three.ShapeGeometry;

/**
 * ...
 * @author nab
 */
class FontMeshMaker
{

	private static var map:Map<String,Geometry> = new Map();
	
	public function new() 
	{
		
	}

			/*
			var shape:Shape = new Shape();
			FontTest.getLetterPoints(shape, s.substr(i, 1), true, 4, new HelveticaMedium());
			//shapes.push(shape);
			//var geo:ExtrudeGeometry = new ExtrudeGeometry(untyped shape, {amount:1});
			//var geo:ShapeGeometry = new ShapeGeometry(untyped shape, { } );
			var geo:ExtrudeGeometry = new ExtrudeGeometry(untyped shape, { amount:30,bevelEnabled:false } );

			var mesh:Mesh = new Mesh(
				geo, 
				new MeshLambertMaterial( { color:0xffffff, side:Three.DoubleSide } )
			);
			mesh.position.x = i * 60 - (s.length-1)*60/2;
			add(mesh);
			*/
	
	public static function getGeometry(moji:String,f:Int):Geometry {
		
		if (moji == " ") return null;
		
		var key:String = f + "_" + moji;
		if ( map.get(key) != null) {
			return map.get(key);
		}
		
		var ff:Typography3D =  StrokeUtil.getFont(f);
		
		var shape:Shape = new Shape();
		getShape(shape, moji, true, 1.3, ff);
		
		var geo:ShapeGeometry = new ShapeGeometry(untyped shape, { } );
		//var geo:ExtrudeGeometry = new ExtrudeGeometry(untyped shape, { amount:30,bevelEnabled:false } );
		map.set(key, geo);
		
		
		return geo;
		/*
		var mesh:Mesh = new Mesh(
				geo, 
				new MeshLambertMaterial( { color:0xffffff, side:Three.DoubleSide } )
			);
			mesh.position.x = i * 60 - (s.length-1)*60/2;
			add(mesh);*/
		
		
	}
		
	
	
	
	
	
	
	public static function getShape(
		g:Dynamic,
		moji:String,
		isCentering:Bool = false,
		scale:Float = 1,
		letter:Typography3D = null
	):Shape {


			var shape:Shape = g;
			var motif:Array<Dynamic> = letter.motifs.get(moji);
			var ox:Float = 0;
			var oy:Float = 0;
			var s:Float = scale;
			
			if (isCentering) {
				ox = -letter.widths.get(moji) / 2;
				oy = -letter.height / 2;
			}
			
			var len:Int = motif.length;
			trace(len);
			var count:Int = 0;
			for (i in 0...len) {
				
				var tgt:String = motif[i][0];
				if (tgt == "M") {
					
					if( moji != "デ"){
						if (count >= 1) {
							g = new Path();
							shape.holes.push(untyped g);
						}
					}
					
					g.moveTo(
						s * (motif[i][1][0] + ox),
						-s * (motif[i][1][1] + oy)
					);
					count++;
					
				}else if( tgt=="L" ){
					g.lineTo(s * (motif[i][1][0] + ox), -s * (motif[i][1][1] + oy));
					
				}else if (tgt == "C") {
					
					g.quadraticCurveTo(
						s * (motif[i][1][0] + ox),
						-s * (motif[i][1][1] + oy),
						s * (motif[i][1][2] + ox),
						-s * (motif[i][1][3] + oy)
					);
					
				}
			}
			
			
			return shape;
			
		}
	
}