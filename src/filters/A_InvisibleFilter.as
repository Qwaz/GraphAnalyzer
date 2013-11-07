package filters 
{
	import graph.Edge;
	import graph.Node;
	
	public class A_InvisibleFilter extends ApplyFilter
	{
		public function A_InvisibleFilter() {
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
				if (Canvas.canvas.node[str]) {
					Canvas.canvas.node[str].visible = false;
					Canvas.canvas.node[str].consider = false;
				}
			}
			
			for (str in Canvas.canvas.edge)
			{
				if (Canvas.canvas.edge[str])
				{
					if (nodeList[Canvas.canvas.edge[str].node1] || nodeList[Canvas.canvas.edge[str].node2])
					{
						Canvas.canvas.edge[str].visible = false;
						Canvas.canvas.edge[str].consider = false;
					}
				}
			}
		}
		
		override public function reset():void
		{
			var node:Node, edge:Edge;
			
			for each (node in Canvas.canvas.node)
			{
				node.visible = true;
				node.consider = true;
			}
			
			for each (edge in Canvas.canvas.edge)
			{
				edge.visible = true;
				edge.consider = true;
			}
		}
		
		public static function getName():String {
			return "보이지 않게";
		}
	}
}