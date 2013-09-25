package 
{
	import graph.Node;
	
	public class InvisibleFilter extends ApplyFilter
	{
		public function InvisibleFilter() {
			super();
		}
		
		override public function getAttribute():Array {
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
			return "보이지 않게 하기";
		}
	}
	
}