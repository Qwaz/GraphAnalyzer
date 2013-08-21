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
			var y1:Number=this.x, y2:Number=y2+this.width;
			
			return 0;
		}
	}
}