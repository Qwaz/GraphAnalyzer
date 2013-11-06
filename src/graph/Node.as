package graph
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Node extends GraphObject
	{
		public static const
		FRICTION:Number = 0.97,
		CONSTANT:Number = 100;
		
		public var speedX:Number=0, speedY:Number=0;
		public var dragging:Boolean = false;
		
		private var idName:String, nameLabel:TextField;
		
		public function Node(idName:String)
		{
			this.idName = idName;
			
			this.graphics.beginFill(0xFF0000);
			this.graphics.drawCircle(0, 0, 1);
			
			nameLabel = new TextField();
			nameLabel.text = idName;
			nameLabel.selectable = false;
			
			var tf:TextFormat = nameLabel.getTextFormat();
			tf.size = 3;
			nameLabel.setTextFormat(tf);
			
			this.addChild(nameLabel);
		}
		
		public function update():void {
			if (dragging)
			{
				x = parent.mouseX + (parent as Canvas).diffX;
				y = parent.mouseY + (parent as Canvas).diffY;
			}
			else
			{
				this.x += speedX;
				this.y += speedY;
			}
			
			if (this.x < -50)
			{
				this.x = -50;
				speedX = 0;
			}
			else if (this.x > 50)
			{
				this.x = 50;
				speedX = 0;
			}
	
			if (this.y < -50)
			{
				this.y = -50;
				speedY = 0;
			}
			else if (this.y > 50)
			{
				this.y = 50;
				speedY = 0;
			}
			
			speedX *= FRICTION;
			speedY *= FRICTION;
		}
		
		override public function distance(mouseX:Number, mouseY:Number):Number {
			return Point.distance(new Point(mouseX, mouseY), new Point(this.x, this.y));
		}
		
		override public function set highlighted(val:Boolean):void {
			if(_highlighted != val){
				this.graphics.clear();
				if(val){
					this.graphics.beginFill(0x00FF00);
					this.graphics.drawCircle(0, 0, 1.3);
				} else {
					this.graphics.beginFill(0xFF0000);
					this.graphics.drawCircle(0, 0, 1);
				}
				_highlighted = val;
			}
		}
	}
}