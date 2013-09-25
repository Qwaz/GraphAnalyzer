package filters 
{
	public class TimeFilter extends Filter
	{
		public function TimeFilter() 
		{
			super();
		}
		
		public function getNodeList():Vector.<String>
		{
			return null;
		}
		
		public static function getSatisfyingList(condition:ConditionFilter, time:Number):Vector.<String>
		{
			var node:Object;
			var now:AlterInfo;
			var str:String;
			var ret:Vector.<String>;
			
			for (i = 0; i < Canvas.nodeAlterInfo.length && Canvas.nodeAlterInfo[i].time <= time; ++i)
			{
				now = Canvas.nodeAlterInfo[i];
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
					ret.push(str);
				}
			}
			
			return ret;
		}
	}
}