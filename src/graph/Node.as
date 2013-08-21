package graph
{
	import flash.geom.Point;

	public class Node extends GraphObject
	{
		public static const
		FRICTION:Number = 0.97,
		CONSTANT:Number = 1;
		
		public var speedX:Number=0, speedY:Number=0;
		
		public function Node()
		{
			this.graphics.beginFill(0xFF0000);
			this.graphics.drawCircle(0, 0, 1);
		}
		
		public function update():void {
			this.x += speedX;
			this.y += speedY;
			
			if(this.x < -50) this.x = -50;
			else if(this.x > 50) this.x = 50;
			
			if(this.y < -50) this.y = -50;
			else if(this.y > 50) this.y = 50;
			
			speedX *= FRICTION;
			speedY *= FRICTION;
		}
		
		override public function distance(mouseX:Number, mouseY:Number):Number {
			return Point.distance(new Point(mouseX, mouseY), new Point(this.x, this.y));
		}
	}
}