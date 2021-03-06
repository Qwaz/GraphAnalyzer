package graph
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Node extends GraphObject
	{
		public static const FRICTION:Number = 0.97;
		public static const CONSTANT:Number = 50;
		public static const CORNER_WEIGHT:Number = 1;
		private static const HIGHLIGHT_SCALING:Number = 1.3;
		
		public var speedX:Number=0, speedY:Number=0;
		public var dragging:Boolean = false;
		
		private var idName:String, nameLabel:TextField;
		
		public function Node(idName:String)
		{
			super();
			
			this.idName = idName;
			
			nameLabel = new TextField();
			nameLabel.text = idName;
			nameLabel.selectable = false;
			
			var tf:TextFormat = nameLabel.getTextFormat();
			tf.size = 3;
			nameLabel.setTextFormat(tf);
			
			this.addChild(nameLabel);
			
			updateShape();
		}
		
		public function updateShape():void
		{
			this.graphics.clear();
			
			if (_highlighted)
			{
				this.graphics.beginFill(0x00FF00);
				this.graphics.drawCircle(0, 0, size * HIGHLIGHT_SCALING);
			}
			else if (_hl_filter)
			{
				this.graphics.beginFill(0xBFFF00);
				this.graphics.drawCircle(0, 0, size);
			}
			else
			{
				this.graphics.beginFill(0x008F6F);
				this.graphics.drawCircle(0, 0, size);
			}
		}
		
		public function updatePosition():void {
			if (dragging)
			{
				x = parent.mouseX + Canvas.canvas.diffX;
				y = parent.mouseY + Canvas.canvas.diffY;
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
			if (_highlighted != val)
			{
				_highlighted = val;
				updateShape();
			}
		}
		
		override public function set hl_filter(val:Boolean):void {
			if (_hl_filter != val)
			{
				_hl_filter = val;
				updateShape();
			}
		}
		
		public function GetName():String
		{
			return idName;
		}
	}
}