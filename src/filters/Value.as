package filters
{
	public class Value 
	{
		private var _isConstant:Boolean;
		private var val:Object;
		private var node:String;
		
		/**
		 * 변수면 constant를 false로, val에 이름.
		 * 상수면 constant를  true로, val에 값.
		 */
		public function Value(isConstant:Boolean, val:Object)
		{
			var vals:Array;
			
			this._isConstant = isConstant;
			this.val = val;
			
			if (!isConstant)
			{
				vals = val.split(".");
				
				if (vals.length == 1)
				{
					node = "";
				}
				else if (vals.length == 2)
				{
					node = vals[0];
					val = vals[1];
				}
				else
				{
					throw new Error("변수 소속 표기에 오류가 있습니다");
				}
			}
		}
		
		/**
		 * 변수면 obj에 노드 정보를 줘야 함.
		 */
		public function Get(obj:Object=null):Object
		{
			if (_isConstant)
			{
				return val;
			}
			else if (node == "")
			{
				if (obj[val as String] != null)
				{
					return obj[val as String];
				}
				else
				{
					throw new Error("속성 '" + (val as String) + "'을(를) 찾을 수 없습니다.");
				}
			}
			else
			{
				if (Canvas.canvas.node[node])
				{
					if (Canvas.canvas.node[node].data[val] != null)
					{
						return Canvas.canvas.node[node].data[val];
					}
					else
					{
						throw new Error("속성 '" + (val as String) + "'을(를) 찾을 수 없습니다.");
					}
				}
				else
				{
					throw new Error("노드 '" + node + "'을(를) 찾을 수 없습니다.");
				}
			}
		}
		
		public function get isConstant():Boolean {
			return _isConstant;
		}
	}
}
