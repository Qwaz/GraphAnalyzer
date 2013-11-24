package filters 
{
	import graph.Edge;
	import graph.Node;
	
	public class A_VisibleFilter extends ApplyFilter 
	{
		public function A_VisibleFilter() 
		{
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
				if (nodeList[str] && Canvas.canvas.node[str]) {
					Canvas.canvas.node[str].visible = true;
					Canvas.canvas.node[str].consider = true;
				}
			}
			
			for (str in Canvas.canvas.edge)
			{
				if (Canvas.canvas.edge[str])
				{
					if (nodeList[Canvas.canvas.edge[str].node1] && nodeList[Canvas.canvas.edge[str].node2])
					{
						Canvas.canvas.edge[str].visible = true;
						Canvas.canvas.edge[str].consider = true;
					}
				}
			}
		}
		
		override public function reset():void {
			// A_InvisibleFilter/reset()
		}
		
		public static function getName():String {
			return "보이게";
		}
	}
}
