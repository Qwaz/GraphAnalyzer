package graph
{
	import flash.display.LineScaleMode;

	public class Edge extends GraphObject
	{
		public static const CONSTANT:Number = 0.004;
		public const SEPARATION:Number = .5;
		private const HIGHLIGHT_SCALING:Number = 1.5;
		
		public var node1:String, node2:String;
		
		public function Edge(node1:String, node2:String)
		{
			super();
			
			this.node1 = node1;
			this.node2 = node2;
		}
		
		public function update():void
		{
			var node:Object = (parent as Canvas).node;
			var x1:Number = node[this.node1].x, x2:Number = node[this.node2].x;
			var y1:Number = node[this.node1].y, y2:Number = node[this.node2].y;
			
			this.x = x1 - SEPARATION * (y2 - y1) / Math.sqrt((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1));
			this.y = y1 + SEPARATION * (x2 - x1) / Math.sqrt((y2 - y1) * (y2 - y1) + (x2 - x1) * (x2 - x1));
			
			this.graphics.clear();
			
			if (_highlighted)
			{
				this.graphics.lineStyle(size * HIGHLIGHT_SCALING, 0x00FF00, 1, false, LineScaleMode.NONE);
			}
			else
			{
				this.graphics.lineStyle(size, 0, 1, false, LineScaleMode.NONE);
			}
			
			this.graphics.lineTo(x2 - x1, y2 - y1);
		}
		
		override public function distance(mouseX:Number, mouseY:Number):Number {
			var node:Object = (parent as Canvas).node;
			var x1:Number = node[this.node1].x, x2:Number = node[this.node2].x;
			var y1:Number = node[this.node1].y, y2:Number = node[this.node2].y;
			var a:Number = (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
			var b:Number = (x1 - mouseX) * (x1 - mouseX) + (y1 - mouseY) * (y1 - mouseY);
			var c:Number = (x2 - mouseX) * (x2 - mouseX) + (y2 - mouseY) * (y2 - mouseY);
			
			if (a + b < c || a + c < b)
				return Number.MAX_VALUE;
			
			if ((x2 - x1) * (mouseY - y2) - (y2 - y1) * (mouseX - x2) > 0)
			{
				return Math.abs((y2 - y1) * mouseX - (x2 - x1) * mouseY - x1 * (y2 - y1) + y1 * (x2 - x1)) /
					Math.sqrt(a) + 2 - SEPARATION / 2;
			}
			else
			{
				return Math.abs((y2 - y1) * mouseX - (x2 - x1) * mouseY - x1 * (y2 - y1) + y1 * (x2 - x1)) /
					Math.sqrt(a) + 2 + SEPARATION / 2;
			}
		}
		
		override public function set highlighted(val:Boolean):void {
			_highlighted = val;
			update();
		}
	}
}
