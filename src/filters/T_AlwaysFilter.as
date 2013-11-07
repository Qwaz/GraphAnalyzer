package filters 
{
	import data.AlterInfo;
	
	/**
	 * 주어진 시간 동안 항상 존재하고, 항상 조건을 만족해야 함.
	 */
	public class T_AlwaysFilter extends TimeFilter 
	{
		public function T_AlwaysFilter() 
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
				if (node[str] && condition.check(node[str]))
				{
					ret[str] = 1;
				}
			}

			for (; i < Canvas.canvas.nodeAlterInfo.length && Canvas.canvas.nodeAlterInfo[i].time <= end; ++i)
			{
				now = Canvas.canvas.nodeAlterInfo[i];

				if (now.mode == AlterInfo.REMOVE)
				{
					delete node[now.node];
					ret[now.node] = 0;
				}
				else
				{
					if (now.mode == AlterInfo.ADD)
					{
						node[now.node] = new Object();
					}
					Canvas.apply(node[now.node], now.data);

					if (!condition.check(node[now.node]))
					{
						ret[now.node] = 0;
					}
				}
			}

			return ret;
		}

		public static function getName():String {
			return "항상 만족";
		}
	}
}
