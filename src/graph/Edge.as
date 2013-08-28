package graph
{
	import flash.display.LineScaleMode;

	public class Edge extends GraphObject
	{
		public static const
		CONSTANT:Number = 0.004;
		
		public var node1:String, node2:String;
		
		public function Edge(node1:String, node2:String)
		{
			this.node1 = node1;
			this.node2 = node2;
			
			this.graphics.lineStyle(1, 0, 1, false, LineScaleMode.NONE);
			this.graphics.lineTo(1, 1);
		}
		
		override public function distance(mouseX:Number, mouseY:Number):Number {
			var x1:Number=this.x, x2:Number=x1+this.scaleX;
			var y1:Number=this.y, y2:Number=y1+this.scaleY;
			var a:Number = (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
			var b:Number = (x1-mouseX)*(x1-mouseX)+(y1-mouseY)*(y1-mouseY);
			var c:Number = (x2-mouseX)*(x2-mouseX)+(y2-mouseY)*(y2-mouseY);
			if (a+b < c || a+c < b) return Number.MAX_VALUE;
			return (Math.abs((y2-y1)*mouseX-(x2-x1)*mouseY-x1*(y2-y1)+y1*(x2-x1))/
				Math.sqrt((y2-y1)*(y2-y1)+(x2-x1)*(x2-x1)))+2;
		}
		
		override public function set highlighted(val:Boolean):void {
			if(_highlighted != val){
				this.graphics.clear();
				if(val){
					this.graphics.lineStyle(1.5, 0x00FF00, 1, false, LineScaleMode.NONE);
					this.graphics.lineTo(1, 1);
				} else {
					this.graphics.lineStyle(1, 0, 1, false, LineScaleMode.NONE);
					this.graphics.lineTo(1, 1);
				}
				_highlighted = val;
			}
		}
	}
}
