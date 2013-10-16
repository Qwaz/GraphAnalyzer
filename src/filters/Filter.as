package filters 
{
	public class Filter 
	{
		public var parameter:Array;
		
		public function Filter() 
		{
		}
		
		public static function getColor(targetClass:Class):uint {
			if (targetClass == Value) return 0x000000;
			
			var filter:Object = new targetClass();
			
			try {
				if (filter is TimeFilter) {
					return 0x0000FF;
				} else if (filter is ApplyFilter) {
					return 0x00FF00;
				} else if (filter is ConditionFilter) {
					return 0xFF0000;
				} else {
					return 0xFFFFFF;
				}
			} catch (e:Error) {
				return 0xFFFFFF;
			}
			return 0xFFFFFF;
		}
		
		public function getParameters():Array
		{
			return [];
		}
		
		public static function getName():String {
			return "하위 클래스에서 구현 되지 않음";
		}
		
	}

}