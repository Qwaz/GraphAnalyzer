package filters 
{
	import mx.collections.ArrayList;
	public class Filter 
	{
		public static const DEFAULT_FILTER_NAME:String = "필터 이름";
		
		public var parameter:Array = [];
		
		[Bindable]
		public var filterName:String = DEFAULT_FILTER_NAME;
		
		[Bindable]
		public var params:ArrayList = new ArrayList();
		
		public function Filter() 
		{
			var paramList:Array = this.getParameters();
			var i:int;
			for (i = 0; i < paramList.length; i++) {
				switch(paramList[i]) {
					case ConditionFilter:
						params.addItem({value:"조건 필터", type:ConditionFilter});
						break;
					case TimeFilter:
						params.addItem({value:"시간 필터", type:TimeFilter});
						break;
					case ApplyFilter:
						params.addItem({value:"적용 필터", type:ApplyFilter});
						break;
					case Value:
						params.addItem({value:"값", type:Value});
						break;
					case Number:
						params.addItem( { value:"시간", type:Number } );
						break;
				}
			}
		}
			
		private function initParameter(filterList:ArrayList):void {
			var i:int, j:int;
			for (i = 0; i < params.length; i++) {
				var ithParam:Object = params.getItemAt(i);
				
				if (ithParam.type == Value) {
					parameter[i] = new Value(!isNaN(Number(ithParam.value)), ithParam.value);
				} else if (ithParam.type == Number) {
					if (!isNaN(Number(ithParam.value))) {
						parameter[i] = Number(ithParam.value);
					} else {
						parameter[i] = null;
						break;
					}
				} else {
					for (j = filterList.getItemIndex(this) - 1; j >= 0; j--) {
						var jthFilter:Filter = filterList.getItemAt(j) as Filter;
						if (ithParam.value == jthFilter.filterName && jthFilter is ithParam.type) {
							parameter[i] = jthFilter;
							break;
						}
					}
				}
					
				//매개변수를 찾지 못함
				if (j == -1) {
					parameter[i] = null;
					break;
				}
			}
		}
		
		public static function getBoldColor(targetClass:Class):uint {
			if (targetClass == Value) return 0x000000;
			else if (targetClass == Number) return 0xFF00FF;
			
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
		
		// 모든 필터들에 이 함수를 구현하세요.
		// public static function getName():String {}
	}
}