package;
import js.JQuery;

/**
 * ...
 * @author watanabe
 */
class ModuleMapMaker
{

	public function new() 
	{
		
	}
	
	public static function getMap(id:String,ww:Int,hh:Int):ModuleMap{
		
		var j:JQuery = new JQuery("#container");
		
		var j2:JQuery = j.clone();
		j2.attr("id", id);
		j2.appendTo("#hoge"); //////container
		
		var map1:ModuleMap = new ModuleMap(
			//j,"#container",400,300
			j2, 
			"#"+id,
			ww,
			hh+2
		);		
		
		return map1;
		
	}
	
	private static function getDiv(id:String):JQuery {
		
		var j:JQuery = new JQuery("#container");
		
		var j2:JQuery = j.clone();
		j2.attr("id", id);
		j2.appendTo("#hoge"); 
		
		return j2;
	}
	
}