package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class Value 
	{
		var constant:Boolean;
		var name:String;
		var val:Object;
		
		/**
		 * 변수면 constant를 false로, name에는 이름.
		 * 상수면 constant를  true로, name은 무시되고, val에 값을.
		 */
		public function Value(constant:Boolean, name:String = "", val:Object = new Object())
		{
			this.constant = constant;
			this.name = name;
			this.val = val;
		}
		/**
		 * 변수면 obj에 노드 정보를 줘야 함.
		 */
		public function Get(obj:Object = new Object()):Object
		{
			if (constant)
			{
				return val;
			}
			else
			{
				return obj[name];
			}
		}
		
	}

}