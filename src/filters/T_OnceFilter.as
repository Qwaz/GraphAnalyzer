package filters 
{
	import data.AlterInfo;
	
	/**
	 * 주어진 시간 동안 한 번이라도 존재해서 조건을 만족하면 됨.
	 */
	public class T_OnceFilter extends TimeFilter 
	{
		public function T_OnceFilter() 
		{
			super();
		}
		
		override public function getParameters():Array
		{
			return [ConditionFilter, Number, Number];
		}

		override public function getNodeList():Object
		{
			var condition:ConditionFilter;
			var start:Number, end:Number;
			var node:Object = new Object;
			var now:AlterInfo;
			var str:String;
			var i:int, j:int;
			var ret:Object = new Object;
			var b:Boolean;
			var changed:Object;
			var newOp:Boolean;

			condition = parameter[0] as ConditionFilter;
			start = parameter[1] as Number;
			end = parameter[2] as Number;

			for (i = 0; i < Canvas.canvas.nodeAlterInfo.length && Canvas.canvas.nodeAlterInfo[i].time <= start; ++i)
			{
				now = Canvas.canvas.nodeAlterInfo[i];
				if (now.mode == AlterInfo.REMOVE)
				{
					delete node[now.node];
					node[now.node] = null;
				}
				else
				{
					if (now.mode == AlterInfo.ADD)
					{
						node[now.node] = new Object();
					}
					Canvas.apply(node[now.node], now.data);
				}
			}

			for (str in node)
			{
				if (node[str] && condition.check(str, node))
				{
					ret[str] = 1;
				}
			}

			for (; i < Canvas.canvas.nodeAlterInfo.length &&
				Canvas.canvas.nodeAlterInfo[i].time <= end; )
			{
				changed = new Object();
				newOp = true;
				
				for (; i < Canvas.canvas.nodeAlterInfo.length &&
					(newOp || Canvas.canvas.nodeAlterInfo[i - 1].time ==
						Canvas.canvas.nodeAlterInfo[i].time); ++i)
				{
					now = Canvas.canvas.nodeAlterInfo[i];
				
					if (now.mode == AlterInfo.REMOVE)
					{
						delete node[now.node];
					}
					else
					{
						if (now.mode == AlterInfo.ADD)
						{
							node[now.node] = new Object();
						}
						Canvas.apply(node[now.node], now.data);
						changed[now.node] = 1;
					}
					
					newOp = false;
				}
				
				for (str in changed)
				{
					if (condition.check(str, node))
					{
						ret[now.node] = 1;
					}
				}
			}

			return ret;
		}

		public static function getName():String {
			return "한 번이라도 만족";
		}
	}
}
