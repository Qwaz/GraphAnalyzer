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
			
			if (Canvas.canvas.node[nameList]) {
				Canvas.canvas.node[nameList].visible = false;
			}
		}
		
		override public function reset():void {
			var node:Node;
			for each(node in Canvas.canvas.node) {
				node.visible = true;
			}
		}
		
		public static function getName():String {
			return "보이지 않게";
		}
	}
	
}