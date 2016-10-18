package objects.objs.motion;
import three.Vector3;
import objects.MyFaceSingle;

/**
 * shokichi wo kimeru
 * @author watanabe
 */
class FacePosition
{

	public function new() 
	{
		
	}
	

	static public function setMoveYPositionMulti(
		faces:Array<MyFaceSingle>, pos:Array<Vector3>, scale:Float, spaceY:Float
	):Void {
		
		//toriaezu yaru
		var no:Int = 0;
		var count:Int = 0;
		var oy:Float = -0.2;
		for (i in 0...faces.length) {
			
			//
			if (no >= pos.length) {
				faces[i].visible = false;
				continue;
				
			}else {
				faces[i].visible = true;
				
			}
			
			var p:Vector3 = pos[no];
			faces[i].scale.set(scale, scale, scale);
			faces[i].position.x = p.x;
			faces[i].position.y = p.y - spaceY * (count + oy);// - _spaceY;//0,1,2
			faces[i].baseY = faces[i].position.y;
			faces[i].position.z = p.z;
					
			faces[i].changeIndex(Math.floor(Math.random()*3));		
			
			count++;
			if (count > 5) {
				no++;
				count = 0;
				oy = -0.2 - 0.2 * Math.random();
			}
			//num++;
		}
		
	}
	
	
	
	static public function setMoveYPosition(faces:Array<MyFaceSingle>, pos:Array<Vector3>, scale:Float, spaceY:Float):Void 
	{
		
		//toriaezu yaru
		for (i in 0...faces.length) {
					
					//5ko
					if(i<5){
						var p:Vector3 = pos[0];
						
						faces[i].scale.set(scale, scale, scale);
						faces[i].position.x = p.x;
						faces[i].position.y = p.y - spaceY * (i+0.3);// - _spaceY;//0,1,2
						faces[i].baseY = faces[i].position.y;
						faces[i].position.z = p.z;
					
						faces[i].changeIndex(Math.floor(Math.random()*3));		
						faces[i].visible = true;
						
					}else {
						faces[i].visible = false;
						
					}
					
		}				
		
	}
	
}