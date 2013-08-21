package graph
{
	import flash.display.LineScaleMode;
	import flash.geom.Point;

	public class Edge extends GraphObject
	{
		public static const
		CONSTANT:Number = 0.001;
		
		public var node1:String, node2:String;
		
		public function Edge(node1:String, node2:String)
		{
			this.node1 = node1;
			this.node2 = node2;
			
			this.graphics.lineStyle(1, 0, 1, false, LineScaleMode.NONE);
			this.graphics.lineTo(1, 1);
		}
		
		override public function distance(mouseX:Number, mouseY:Number):Number {
			var x1:Number=this.x, x2:Number=x1+this.width;
			var y1:Number=this.y, y2:Number=y1+this.height;
			return (((y2-y1)*mouseX-(x2-x1)*mouseY-x1*(y2-y1)+y1*(x2-x1))/
				Math.sqrt((y2-y1)*(y2-y1)+(x2-x1)*(x2-x1)))
		}
	}
}
