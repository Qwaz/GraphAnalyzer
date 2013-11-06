package filters
{
	public class Value 
	{
		private var _isConstant:Boolean;
		private var val:String;
		
		/**
		 * 변수면 constant를 false로, name에는 이름.
		 * 상수면 constant를  true로, name은 무시되고, val에 값을.
		 */
		public function Value(isConstant:Boolean, val:String = "")
		{
			this._isConstant = isConstant;
			this.val = val;
		}
		/**
		 * 변수면 obj에 노드 정보를 줘야 함.
		 */
		public function Get(obj:Object=null):Object
		{
			if (_isConstant)
			{
				return Number(val);
			}
			else
			{
				// 속성이 없으면 에러 출력
				if (obj[val] != null)
					return obj[val];
				else
					throw new Error("속성 '" + val + "'을(를) 찾을 수 없습니다.");
			}
		}
		
		public function get isConstant():Boolean {
			return _isConstant;
		}
		
	}

}