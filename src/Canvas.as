package
{
	import flash.events.Event;
	
	import spark.components.HSlider;
	import spark.core.SpriteVisualElement;
	
	import graph.Edge;
	import graph.Node;

	public class Canvas extends SpriteVisualElement
	{	
		public static const SIZE:Number = 100;
		
		private var _slider:HSlider, parser:Parser;
		
		private var nodeAlterInfo:Vector.<AlterInfo>, edgeAlterInfo:Vector.<AlterInfo>;
		
		private var lastTime:Number, nodeIndex:uint, edgeIndex:uint;
		
		private var node:Object, edge:Object;
		
		public function Canvas()
		{
		}
		
		public function set slider(slider:HSlider):void {
			_slider = slider;
			parser = new Parser();
			parser.addEventListener(Event.COMPLETE, parseComplete);
			parser.parse();
		}
		
		private function parseComplete(e:Event):void {
			_slider.minimum = parser.minimum;
			_slider.maximum = parser.maximum;
			_slider.stepSize = parser.stepSize;
			
			lastTime = Number.MIN_VALUE;
			nodeIndex = 0;
			edgeIndex = 0;
			
			nodeAlterInfo = parser.nodeAlterInfo;
			edgeAlterInfo = parser.edgeAlterInfo;
			
			node = new Object();
			edge = new Object();
			
			_slider.addEventListener(Event.CHANGE, changeHandler);
			
			_slider.value = _slider.minimum;
			_slider.dispatchEvent(new Event(Event.CHANGE));
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function apply(target:Object, source:Object):void {
			var str:String;
			for(str in source){
				target[str] = source[str];
			}
		}
		
		private function changeHandler(e:Event):void {
			var now:AlterInfo, tEdge:Edge;
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
					if(now.mode == AlterInfo.REMOVE){
						edge[now.hash()].dispose();
						delete edge[now.hash()];
					} else {
						if(now.mode == AlterInfo.ADD){
							tEdge = new Edge(now.node, now.node2);
							edge[now.hash()] = tEdge;
							addChildAt(tEdge, 0);
						}
						apply(edge[now.hash()], now.data);
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
					if(now.mode == AlterInfo.ADD){
						edge[now.hash()].dispose();
						delete edge[now.hash()];
					} else {
						if(now.mode == AlterInfo.REMOVE){
							tEdge = new Edge(now.node, now.node2);
							edge[now.hash()] = tEdge;
							addChildAt(tEdge, 0);
						}
						apply(edge[now.hash()], now.prev);
					}
				}
			}
			adjustEdge();
			
			lastTime = _slider.value;
		}
		
		private function enterFrameHandler(e:Event):void {
			var nowNode:Node, nextNode:Node, nowEdge:Edge;
			
			for each(nowEdge in edge){
				nowNode = node[nowEdge.node1];
				nextNode = node[nowEdge.node2];
				
				nowNode.speedX += Edge.CONSTANT*(nextNode.x-nowNode.x);
				nowNode.speedY += Edge.CONSTANT*(nextNode.y-nowNode.y);
			}
			
			for each(nowNode in node){
				for each(nextNode in node){
					if(nextNode != nowNode){
						nowNode.speedX -= Node.CONSTANT/(nextNode.x-nowNode.x);
						nowNode.speedY -= Node.CONSTANT/(nextNode.y-nowNode.y);
					}
				}
				
				nowNode.update();
			}
			
			adjustEdge();
		}
		
		private function adjustEdge():void {
			var nowEdge:Edge;
			for each(nowEdge in edge){
				nowEdge.x = node[nowEdge.node1].x;
				nowEdge.y = node[nowEdge.node1].y;
				
				nowEdge.scaleX = node[nowEdge.node2].x-node[nowEdge.node1].x;
				nowEdge.scaleY = node[nowEdge.node2].y-node[nowEdge.node1].y;
			}
		}
	}
}