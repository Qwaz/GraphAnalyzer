package filters 
{
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
			var nameList:Vector.<String> = parameter[0].getNodeList();
			var node:Node;
			
			for (var i:int = 0; i < nameList.length; ++i)
			{
				if (Canvas.canvas.node[nameList[i]]) {
					Canvas.canvas.node[nameList[i]].visible = true;
				}
			}
		}
		
		override public function reset():void {
			// A_InvisibleFilter의 reset()이 처리함
		}
		
		public static function getName():String {
			return "보이게";
		}
	}
}
