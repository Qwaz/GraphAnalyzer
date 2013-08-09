package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class Parser extends UIComponent
	{
		public function Parser()
		{
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(e:Event):void {
			var t:Sprite = new Sprite();
			
			t.graphics.beginFill(0xFFFFFF*Math.random());
			t.graphics.drawCircle(100*Math.random(), 100*Math.random(), 3);
			t.x = Math.random()*this.width;
			t.y = Math.random()*this.height;
			
			addChild(t);
		}
	}
}