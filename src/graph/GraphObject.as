package graph
{
	import flash.display.Sprite;
	
	import spark.filters.GlowFilter;
	
	public class GraphObject extends Sprite
	{
		public static var glowFilter:GlowFilter
		= new GlowFilter(0x00FF00);
		
		public var data:Object;
		
		public function GraphObject() {
			data = new Object();
		}
		
		public function dispose():void {
			this.parent.removeChild(this);
			data = null;
		}
		
		public function distance(mouseX:Number, mouseY:Number):Number {
			return 0;
		}
	}
}