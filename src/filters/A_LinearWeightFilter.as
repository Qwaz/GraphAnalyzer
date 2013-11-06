package filters 
{
	import graph.Node;
	
	/**
	 * Force-Directed와 화면 그리기 가중치를 설정
	 * 설정된 값의 최댓값과 최솟값을 기준으로 1~3 범위로 선형으로 설정된다.
	 * 슬라이더를 움직이면 표시되고 있는 값으로 설정된다.
	 */
	
	public class A_LinearWeightFilter extends ApplyFilter 
	{
		public function A_LinearWeightFilter() 
		{
			super();
		}
		
		override public function getParameters():Array {
			return [TimeFilter, Value];
		}
		
		override public function apply():void {
			var nodeList:Object = parameter[0].getNodeList();
			var str:String;
			var w:Number, max:Number, min:Number, ratio:Number;
			
			for (str in nodeList)
			{
				if (Canvas.canvas.node[str])
				{
					if (!((parameter[1] as Value).Get(Canvas.canvas.node[str].data) is Number))
					{
						throw new Error("WeightFilter.apply() : Type mismatch!");
					}
					min = max = (parameter[1] as Value).Get(Canvas.canvas.node[str].data) as Number;
					break;
				}
			}
			
			for (str in nodeList)
			{
				if (Canvas.canvas.node[str])
				{
					w = (parameter[1] as Value).Get(Canvas.canvas.node[str].data) as Number;
					if (w < min) min = w;
					if (w > max) max = w;
				}
			}
			
			if (min == max)
			{
				(new A_WeightFilter()).reset();
			}
			else
			{
				for (str in nodeList)
				{
					if (Canvas.canvas.node[str])
					{
						w = (parameter[1] as Value).Get(Canvas.canvas.node[str].data) as Number;
						ratio = (w - min) / (max - min);
						Canvas.canvas.node[str].weight = Canvas.canvas.node[str].size = 2 * ratio + 1;
					}
				}
			}
		}
		
		override public function reset():void {
			// A_WeightFilter/reset()
		}
		
		public static function getName():String {
			return "선형 가중치 설정";
		}
	}
}
