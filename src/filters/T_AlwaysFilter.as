package filters 
{
	import data.AlterInfo;
	
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

		override public function getNodeList():Vector.<String>
		{
			var condition:ConditionFilter;
			var start:Number, end:Number;
			var node:Object = new Object;
			var now:AlterInfo;
			var str:String;
			var i:int, j:int;
			var temp:Object = new Object;
			var b:Boolean;
			var ret:Vector.<String> = new Vector.<String>;

			if (parameter[0] is ConditionFilter && parameter[1] is Number && parameter[2] is Number)
			{
				condition = parameter[0] as ConditionFilter;
				start = parameter[1].Get() as Number;
				end = parameter[2].Get() as Number;
			}
			else
			{
				throw new Error("AlwaysFilter.getNodeList() : Type mismatch!");
			}

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
					temp[str] = 1;
				}
			}

			for (; i < Canvas.canvas.nodeAlterInfo.length; ++i)
			{
				now = Canvas.canvas.nodeAlterInfo[i];

				if (now.mode == AlterInfo.REMOVE)
				{
					delete node[now.node];
					temp[now.node] = 0;
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
						temp[now.node] = 0;
					}
				}
			}

			for (str in temp)
			{
				if (temp[str] == 1)
				{
					ret.push(str);
				}
			}

			return ret;
		}

		public static function getName():String {
			return "항상 만족";
		}
	}
}
