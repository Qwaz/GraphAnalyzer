package graph
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	
	public class GraphObject extends Sprite
	{
		public var data:Object;
		public var consider:Boolean;
		public var weight:Number;
		public var size:Number;
		
		protected var _highlighted:Boolean = false;
		
		public function GraphObject() {
			data = new Object();
			consider = true;
			weight = 1;
			size = 1;
		}
		
		public function dispose():void {
			this.parent.removeChild(this);
			data = null;
		}
		
		public function distance(mouseX:Number, mouseY:Number):Number {
			return 0;
		}
		
		public function set highlighted(val:Boolean):void {
			_highlighted = val;
		}
	}
}