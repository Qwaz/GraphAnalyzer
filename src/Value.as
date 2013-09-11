package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class Value 
	{
		private var isConstant:Boolean;
		private var val:String;
		
		/**
		 * 변수면 constant를 false로, name에는 이름.
		 * 상수면 constant를  true로, name은 무시되고, val에 값을.
		 */
		public function Value(isConstant:Boolean, val:String = "")
		{
			this.isConstant = isConstant;
			this.val = val;
		}
		/**
		 * 변수면 obj에 노드 정보를 줘야 함.
		 */
		public function Get(obj:Object=null):Object
		{
			if (isConstant)
			{
				return Number(val);
			}
			else
			{
				return obj[name];
			}
		}
		
		public function get isConstant():Boolean {
			return this.isConstant;
		}
		
	}

}