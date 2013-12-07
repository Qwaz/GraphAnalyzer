package filters
{
	import utils.TrivialError;
	
	public class Value 
	{
		private var _isConstant:Boolean;
		private var val:Object;
		private var m_node:String;
		
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
					m_node = "";
				}
				else if (vals.length == 2)
				{
					m_node = vals[0];
					this.val = vals[1];
				}
				else
				{
					throw new Error("변수 소속 표기에 오류가 있습니다");
				}
			}
		}
		
		/**
		 * 특정 시점의 상태를 얻으려면 data에 전체 노드 데이터를 넘겨 준다.
		 */
		public function Get(node:String, data:Object = null):Object
		{
			if (_isConstant)
			{
				return val;
			}
			
			if (m_node != "") node = m_node;
			
			if (data)
			{
				if (data[node])
				{
					if (data[node][val] != null)
					{
						return data[node][val];
					}
					else
					{
						throw new Error("속성 '" + val + "'을(를) 찾을 수 없습니다.");
					}
				}
				else
				{
					throw new TrivialError("노드 '" + node + "'을(를) 찾을 수 없습니다.");
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
						throw new Error("속성 '" + val + "'을(를) 찾을 수 없습니다.");
					}
				}
				else
				{
					throw new TrivialError("노드 '" + node + "'을(를) 찾을 수 없습니다.");
				}
			}
		}
		
		public function get isConstant():Boolean {
			return _isConstant;
		}
	}
}
