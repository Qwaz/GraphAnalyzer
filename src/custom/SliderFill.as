package custom
{
	import flash.display.Sprite;
	import flash.events.Event;
	import spark.core.SpriteVisualElement;
	
	public class SliderFill extends SpriteVisualElement
	{
		private const WIDTH:Number = 2;
		
		public var linePosition:Vector.<Number>;
		
		private var lastWidth:Number = 0;
		
		public function SliderFill():void {
			addEventListener(Event.ENTER_FRAME, checkResizing);
		}
		
		private function checkResizing(e:Event):void {
			if (linePosition && linePosition.length > 0 && this.width != lastWidth) {
				redraw();
				lastWidth = this.width;
			}
		}
		
		private function redraw():void {
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, this.width, this.height);
			
			this.graphics.beginFill(0x3FFF3F);
			
			var i:int;
			for (i = 0; i < linePosition.length; i++) {
				var num:Number = linePosition[i];
				
				this.graphics.drawRect(this.width * num - WIDTH / 2, 0, WIDTH, this.height);
			}
		}
	}
	
}