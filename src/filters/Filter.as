package filters 
{
	public class Filter 
	{
		public static const DEFAULT_FILTER_NAME:String = "필터 이름";
		
		public var parameter:Array=[], filterName:String=DEFAULT_FILTER_NAME;
		
		public function Filter() 
		{
		}
		
		public static function getBoldColor(targetClass:Class):uint {
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
		
		public static function getLightColor(targetClass:Class):uint {
			if (targetClass == Value) return 0x000000;
			
			var filter:Object = new targetClass();
			
			try {
				if (filter is TimeFilter) {
					return 0x8F9CFF;
				} else if (filter is ApplyFilter) {
					return 0x74CF6B;
				} else if (filter is ConditionFilter) {
					return 0xFF7878;
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