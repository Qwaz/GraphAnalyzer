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
					if (!((parameter[1] as Value).Get(str) is Number))
					{
						throw new Error("선형 가중치 필터에는 실수를 입력하세요");
					}
					min = max = (parameter[1] as Value).Get(str) as Number;
					break;
				}
			}
			
			for (str in nodeList)
			{
				if (Canvas.canvas.node[str])
				{
					w = (parameter[1] as Value).Get(str) as Number;
					if (w < min) min = w;
					if (w > max) max = w;
				}
			}
			
			if (min == max)
			{
				for (str in nodeList)
				{
					if (Canvas.canvas.node[str])
					{
						Canvas.canvas.node[str].weight = Canvas.canvas.node[str].size = 1;
					}
				}
			}
			else
			{
				for (str in nodeList)
				{
					if (Canvas.canvas.node[str])
					{
						w = (parameter[1] as Value).Get(str) as Number;
						ratio = (w - min) / (max - min);
						Canvas.canvas.node[str].weight =
							(A_WeightFilter.WEIGHT_MAX - A_WeightFilter.WEIGHT_MIN) * ratio + A_WeightFilter.WEIGHT_MIN;
						Canvas.canvas.node[str].size =
							(A_WeightFilter.SIZE_MAX - A_WeightFilter.SIZE_MIN) * ratio + A_WeightFilter.SIZE_MIN;
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
