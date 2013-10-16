package filters 
{
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
			var nameList:Vector.<String> = parameter[0].getNodeList();
			var node:Node;
			
			for each(node in Canvas.node) {
				node.visible = true;
			}
			
			if (Canvas.node[nameList]) {
				Canvas.node[nameList].visible = false;
			}
		}
		
		public static function getName():String {
			return "보이지 않게";
		}
	}
	
}