package dede.cuts;

/**
 * ...
 * @author watanabe
 */
class DeDeString
{

	public var text:String = "";
	public var font:Int = 0;
	public var spaceX:Float = 0;
	public var type:Int = -1;
	public var offsetY:Float = 0;
	private static var _count:Int = 0;
	public static var texts:Array<Dynamic> = [
	
		{ text:"デデデデデ", font:0, spaceX:30,offsetY:20 },
		{ text:"RINGO", font:1, spaceX:40,offsetY:0 },
		{ text:"DEDEMOUSE", font:1, spaceX:40,offsetY:0 },
		{ text:"デデデデデ", font:0, spaceX:30,offsetY:20 },
		{ text:"DEDE", font:1, spaceX:40,offsetY:0 },
		{ text:"KITASENJUDESIGN", font:1, spaceX:40,offsetY:0 },
		{ text:"デデデデデ", font:0, spaceX:30,offsetY:20 },
		{ text:"TOKYODESIGNWEEK2016", font:1, spaceX:40,offsetY:0 }
		
	];
	
	public function new(o:Dynamic) 
	{
		text = o.text;
		font = o.font;
		spaceX = o.spaceX;//moji spacex
		offsetY = o.offsetY;
	}
	
	/**
	 * DeDeString
	 * @return
	 */
	public static function getData():DeDeString {
		
		var data:DeDeString = new DeDeString(
			texts[ _count % texts.length ]
		);
		_count++;
		
		return data;
		
	}
	
}