package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import spark.components.HSlider;
	import spark.core.SpriteVisualElement;
	
	import mx.collections.ArrayList;
	
	import data.AlterInfo;
	import data.Data;
	import data.Parser;
	
	import graph.Edge;
	import graph.GraphObject;
	import graph.Node;

	public class Canvas extends SpriteVisualElement
	{	
		public static const SIZE:Number = 100, MIN_DISTANCE:Number = 7;
		
		public static var canvas:Canvas;
		
		private var _slider:HSlider, parser:Parser;
		
		public var nodeAlterInfo:Vector.<AlterInfo>, edgeAlterInfo:Vector.<AlterInfo>;
		private var nodeDataList:Vector.<Data>, edgeDataList:Vector.<Data>;
		
		private var lastTime:Number, nodeIndex:uint, edgeIndex:uint;
		
		public var node:Object, edge:Object;
		
		[Bindable]
		public var dataList:ArrayList, emptyList:ArrayList;
		
		private var nearest:GraphObject, _selected:GraphObject, dragging:GraphObject;
		private var startX:Number, startY:Number;
		public var diffX:Number, diffY:Number;
		
		public function Canvas()
		{
			canvas = this;
			
			emptyList = new ArrayList();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(e:Event):void {
			this.parent.addEventListener(MouseEvent.MOUSE_DOWN, MouseDownHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, MouseUpHandler);
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
			
			nodeDataList = parser.nodeDataList;
			edgeDataList = parser.edgeDataList;
			
			nodeDataList
			
			node = new Object();
			edge = new Object();
			
			_slider.addEventListener(Event.CHANGE, changeHandler);
			
			_slider.value = _slider.minimum;
			_slider.dispatchEvent(new Event(Event.CHANGE));
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public static function apply(target:Object, source:Object):void {
			var str:String;
			for(str in source){
				target[str] = source[str];
			}
		}
		
		private function MouseDownHandler(e:MouseEvent):void {
			if (nearest is Node)
			{
				if (dragging && dragging is Node) (dragging as Node).dragging = false;
				dragging = nearest as Node;
				(dragging as Node).dragging = true;
				diffX = dragging.x - mouseX;
				diffY = dragging.y - mouseY;
			}
			else
			{
				if (dragging && dragging is Node) (dragging as Node).dragging = false;
				dragging = nearest;
			}
			
			startX = mouseX;
			startY = mouseY;
			selected = null;
		}
		
		private function MouseUpHandler(e:MouseEvent):void {
			if ((startX - mouseX) * (startX - mouseX) +
				(startY - mouseY) * (startY - mouseY) <= MIN_DISTANCE * MIN_DISTANCE)
			{
				selected = dragging;
			}
			if (dragging && dragging is Node) (dragging as Node).dragging = false;
			dragging = null;
		}
		
		private function get selected():GraphObject {
			return _selected;
		}
		
		private function set selected(selected:GraphObject):void {
			_selected = selected;
			
			if (_selected) {
				dataList = new ArrayList();
				
				var i:int, str:String;
				if (selected is Node) {
					for (i = 0; i < nodeDataList.length; i++) {
						str = nodeDataList[i].name;
						dataList.addItem( { name:str, value:_selected.data[str] } );
					}
				} else if (selected is Edge) {
					for (i = 0; i < edgeDataList.length; i++) {
						str = edgeDataList[i].name;
						dataList.addItem( { name:str, value:_selected.data[str] } );
					}
				}
			} else {
				dataList = emptyList;
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
						apply(edge[now.hash()].data, now.data);
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
						apply(edge[now.hash()].data, now.prev);
					}
				}
			}
			adjustEdge();
			
			lastTime = _slider.value;
			
			if(FilterPanel.panel) FilterPanel.panel.render();
		}
		
		private function enterFrameHandler(e:Event):void {
			var dist:Number = MIN_DISTANCE;
			var nowNode:Node, nextNode:Node, nowEdge:Edge;
			
			for each(nowEdge in edge){
				nowNode = node[nowEdge.node1];
				nextNode = node[nowEdge.node2];
				
				nowNode.speedX += Edge.CONSTANT * (nextNode.x - nowNode.x);
				nowNode.speedY += Edge.CONSTANT * (nextNode.y - nowNode.y);
				
				nextNode.speedX -= Edge.CONSTANT * (nextNode.x - nowNode.x);
				nextNode.speedY -= Edge.CONSTANT * (nextNode.y - nowNode.y);
			}
			
			var r:Number;
			
			nearest = null;
			
			for each(nowNode in node){
				for each(nextNode in node){
					if (nextNode != nowNode) {
						r = Point.distance(new Point(nextNode.x, nextNode.y), new Point(nowNode.x, nowNode.y));
						r = r * r * r;
						
						nowNode.speedX -= Node.CONSTANT * (nextNode.x - nowNode.x) / r;
						nowNode.speedY -= Node.CONSTANT * (nextNode.y - nowNode.y) / r;
					}
				}
				
				nowNode.highlighted = false;
				
				if(dist > nowNode.distance(mouseX, mouseY)){
					dist = nowNode.distance(mouseX, mouseY);
					nearest = nowNode;
				}
			}
			
			for each(nowNode in node) {
				nowNode.update();
			}
			
			adjustEdge();
			
			for each(nowEdge in edge){
				nowEdge.highlighted = false;
				
				if(dist > nowEdge.distance(mouseX, mouseY)){
					dist = nowEdge.distance(mouseX, mouseY);
					nearest = nowEdge;
				}
			}
			
			if (dragging)
			{
				dragging.highlighted = true;
			}
			else
			{
				if (nearest)
				{
					nearest.highlighted = true;
				}
				
				if (selected)
				{
					selected.highlighted = true;
				}
			}
		}
		
		private function adjustEdge():void {
			const ZERO:Number = 0.001;
			
			var nowEdge:Edge;
			for each(nowEdge in edge){
				nowEdge.x = node[nowEdge.node1].x;
				nowEdge.y = node[nowEdge.node1].y;
				
				nowEdge.scaleX = node[nowEdge.node2].x - node[nowEdge.node1].x;
				if (nowEdge.scaleX == 0) {
					nowEdge.scaleX = ZERO;
				}
				nowEdge.scaleY = node[nowEdge.node2].y - node[nowEdge.node1].y;
				if (nowEdge.scaleY == 0) {
					nowEdge.scaleY = ZERO;
				}
			}
		}
	}
}