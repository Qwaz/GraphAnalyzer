package
{
	import flash.events.Event;
	
	import spark.components.HSlider;
	import spark.core.SpriteVisualElement;

	public class Canvas extends SpriteVisualElement
	{	
		public static const SIZE:Number = 100;
		
		private var _slider:HSlider, parser:Parser;
		
		private var nodeAlterInfo:Vector.<AlterInfo>, edgeAlterInfo:Vector.<AlterInfo>;
		
		private var lastTime:Number, nodeIndex:uint, edgeIndex:uint;
		
		private var node:Object;
		
		public function Canvas()
		{
		}
		
		public function set slider(slider:HSlider):void {
			_slider = slider;
			parser = new Parser(_slider);
			parser.addEventListener(Event.COMPLETE, parseComplete);
			parser.parse();
		}
		
		private function parseComplete(e:Event):void {
			lastTime = _slider.minimum;
			nodeIndex = 0;
			edgeIndex = 0;
			
			nodeAlterInfo = parser.nodeAlterInfo;
			edgeAlterInfo = parser.edgeAlterInfo;
			
			node = new Object();
			
			_slider.addEventListener(Event.CHANGE, changeHandler);
		}
		
		private function apply(target:Object, source:Object):void {
			var str:String;
			for(str in source){
				target[str] = source[str];
			}
		}
		
		private function changeHandler(e:Event):void {
			var now:AlterInfo;
			if(lastTime < _slider.value){
				//오른쪽으로 드래그 한 경우
				for(; nodeIndex < nodeAlterInfo.length && nodeAlterInfo[nodeIndex].time <= _slider.value; nodeIndex++){
					now = nodeAlterInfo[nodeIndex];
					if(now.mode == AlterInfo.REMOVE){
						node[now.node].dispose();
						delete node[now.node];
					} else {
						if(now.mode == AlterInfo.ADD){
							node[now.node] = new Node();
							addChild(node[now.node]);
							node[now.node].x = Math.random()*SIZE-SIZE/2;
							node[now.node].y = Math.random()*SIZE-SIZE/2;
						}
						apply(node[now.node].data, now.data);
					}
				}
				
				for(; edgeIndex < edgeAlterInfo.length && edgeAlterInfo[edgeIndex].time <= _slider.value; edgeIndex++){
					now = edgeAlterInfo[edgeIndex];
					if(now.type == AlterInfo.REMOVE){
						if(node[now.node])
							delete node[now.node].to[now.node2];
					} else {
						if(now.type == AlterInfo.ADD){
							node[now.node].to[now.node2] = new Object();
						}
						apply(node[now.node].to[now.node2], now.data);
					}
				}
			} else if(lastTime > _slider.value) {
				//왼쪽으로 드래그 한 경우
				for(; nodeIndex > 0 && nodeAlterInfo[nodeIndex-1].time > _slider.value; nodeIndex--){
					now = nodeAlterInfo[nodeIndex-1];
					if(now.mode == AlterInfo.ADD){
						node[now.node].dispose();
						delete node[now.node];
					} else {
						if(now.mode == AlterInfo.REMOVE){
							node[now.node] = new Node();
							addChild(node[now.node]);
							node[now.node].x = Math.random()*SIZE-SIZE/2;
							node[now.node].y = Math.random()*SIZE-SIZE/2;
						}
						apply(node[now.node].data, now.prev);
					}
				}
				
				for(; edgeIndex > 0 && edgeAlterInfo[edgeIndex-1].time > _slider.value; edgeIndex--){
					now = edgeAlterInfo[edgeIndex-1];
					if(now.type == AlterInfo.ADD){
						if(node[now.node])
							delete node[now.node].to[now.node2];
					} else {
						if(now.type == AlterInfo.REMOVE){
							node[now.node].to[now.node2] = new Object();
						}
						apply(node[now.node].to[now.node2], now.prev);
					}
				}
			}
			lastTime = _slider.value;
		}
	}
}