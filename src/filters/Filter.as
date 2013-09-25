package filters 
{
	public class Filter 
	{
		public var parameter:Array;
		
		public function Filter() 
		{
		}
		
		public function getAttribute():Array
		{
			return [];
		}
		
		public static function getName():String {
			return "하위 클래스에서 구현 되지 않음";
		}
	}
}