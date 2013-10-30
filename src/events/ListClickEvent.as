package events
{
	import flash.events.Event;
	
	public class ListClickEvent extends Event {
		public var index:int;
		
		public function ListClickEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void {
			super(type, bubbles, cancelable);
		}
	}
	
}