package filters 
{
	/**
	 * Filter 클래스
	 * @author 함도영
	 */
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