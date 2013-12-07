package filters 
{
	import graph.Edge;
	import graph.Node;
	
	public class A_HighlightFilter extends ApplyFilter
	{
		public function A_HighlightFilter() {
			super();
		}
		
		override public function getParameters():Array {
			return [TimeFilter];
		}
		
		override public function apply():void {
			var nodeList:Object = parameter[0].getNodeList();
			var str:String;
			
			for (str in nodeList)
			{
				if (nodeList[str] && Canvas.canvas.node[str])
				{
					Canvas.canvas.node[str].hl_filter = true;
				}
			}
		}
		
		override public function reset():void
		{
			var node:Node, edge:Edge;
			
			for each (node in Canvas.canvas.node)
			{
				node.hl_filter = false;
			}
			
			for each (edge in Canvas.canvas.edge)
			{
				edge.hl_filter = false;
			}
		}
		
		public static function getName():String {
			return "하이라이트";
		}
	}
}