package filters 
{
	import graph.Node;
	
	/**
	 * Force-Directed와 화면 그리기 가중치를 설정한다.
	 * 슬라이더를 움직이면 표시되고 있는 값으로 설정된다.
	 */
	
	public class A_WeightFilter extends ApplyFilter 
	{
		public static const WEIGHT_MAX:Number = 3;
		public static const WEIGHT_MIN:Number = 1;
		public static const SIZE_MAX:Number = 3;
		public static const SIZE_MIN:Number = 1;
		
		public function A_WeightFilter() 
		{
			super();
		}
		
		override public function getParameters():Array {
			return [TimeFilter, Value];
		}
		
		override public function apply():void {
			var nodeList:Object = parameter[0].getNodeList();
			var str:String;
			var w:Number;
			
			for (str in nodeList)
			{
				if (nodeList[str] && Canvas.canvas.node[str])
				{
					if (!((parameter[1] as Value).Get(str) is Number))
					{
						throw new Error("가중치 필터에는 실수를 입력하세요");
					}
					break;
				}
			}
			
			for (str in nodeList)
			{
				if (nodeList[str] && Canvas.canvas.node[str])
				{
					w = (parameter[1] as Value).Get(str) as Number;
					Canvas.canvas.node[str].weight = w;
					if (Canvas.canvas.node[str].weight > WEIGHT_MAX) Canvas.canvas.node[str].weight = WEIGHT_MAX;
					if (Canvas.canvas.node[str].weight < WEIGHT_MIN) Canvas.canvas.node[str].weight = WEIGHT_MIN;
					Canvas.canvas.node[str].size = w;
					if (Canvas.canvas.node[str].size > SIZE_MAX) Canvas.canvas.node[str].size = SIZE_MAX;
					if (Canvas.canvas.node[str].size < SIZE_MIN) Canvas.canvas.node[str].size = SIZE_MIN;
				}
			}
		}
		
		override public function reset():void {
			var node:Node;
			for each(node in Canvas.canvas.node) {
				node.weight = 1;
				node.size = 1;
			}
		}
		
		public static function getName():String {
			return "가중치 설정";
		}
	}
}
