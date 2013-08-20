package
{
	import flash.display.Sprite;
	
	public class Node extends Sprite
	{
		public var data:Object, to:Object;
		public var speedX:Number=0, speedY:Number=0;
		
		public function Node()
		{
			super();
			
			data = new Object();
			to = new Object();
			
			this.graphics.beginFill(0xFF0000);
			this.graphics.drawCircle(0, 0, 1);
		}
		
		public function dispose():void {
			this.parent.removeChild(this);
			data = null;
			to = null;
		}
	}
}