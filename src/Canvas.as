package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import spark.core.SpriteVisualElement;
	
	import mx.collections.ArrayList;
	
	import custom.Slider;
	
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
		
		private var _slider:Slider, parser:Parser;
		
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
		
		public function set slider(slider:Slider):void {
			_slider = slider;
			parser = new Parser();
			parser.addEventListener(Event.COMPLETE, parseComplete);
			parser.parse();
		}
		
		private function parseComplete(e:Event):void {
			_slider.minimum = parser.minimum;
			_slider.maximum = parser.maximum;
			_slider.stepSize = parser.stepSize;
			
			var i:int;
			for (i = 0; i < parser.timeList.length; i++) {
				if (i == 0 || parser.timeList[i] != parser.timeList[i - 1]){
					_slider.linePosition.push((parser.timeList[i]-parser.minimum)/(parser.maximum-parser.minimum));
				}
			}
			
			lastTime = Number.MIN_VALUE;
			nodeIndex = 0;
			edgeIndex = 0;
			
			nodeAlterInfo = parser.nodeAlterInfo;
			edgeAlterInfo = parser.edgeAlterInfo;
			
			nodeDataList = parser.nodeDataList;
			edgeDataList = parser.edgeDataList;
			
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
				dragging = nearest;
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
		
		private function UpdateDatalist():void
		{
			var i:int, str:String;
				
			if (selected) {
				dataList = new ArrayList();
				
				if (selected is Node) {
					for (i = 0; i < nodeDataList.length; i++) {
						str = nodeDataList[i].name;
						dataList.addItem( { name:str, value:selected.data[str] } );
					}
				} else if (selected is Edge) {
					dataList.addItem( { name:'식별자', value:Object(selected).node1 + '->' + Object(selected).node2 } );
					for (i = 0; i < edgeDataList.length; i++) {
						str = edgeDataList[i].name;
						dataList.addItem( { name:str, value:selected.data[str] } );
					}
				}
			} else {
				dataList = emptyList;
			}
		}
		
		private function get selected():GraphObject {
			return _selected;
		}
		
		private function set selected(selected:GraphObject):void {
			_selected = selected;
			UpdateDatalist();
		}
		
		public function reDraw():void
		{
			var nowNode:Node, nowEdge:Edge;
			
			for each (nowNode in node)
			{
				nowNode.updateShape();
			}
			
			for each (nowEdge in edge)
			{
				nowEdge.update();
			}
		}
		
		private function changeHandler(e:Event):void {
			var now:AlterInfo, tEdge:Edge, nowEdge:Edge;
			if(lastTime < _slider.value){
				//오른쪽으로 드래그 한 경우
				for(; nodeIndex < nodeAlterInfo.length && nodeAlterInfo[nodeIndex].time <= _slider.value; nodeIndex++){
					now = nodeAlterInfo[nodeIndex];
					if (now.mode == AlterInfo.REMOVE) {
						if (selected && selected is Node && (selected as Node).GetName() == now.node) selected = null;
						node[now.node].dispose();
						delete node[now.node];
					} else {
						if(now.mode == AlterInfo.ADD){
							node[now.node] = new Node(now.node);
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
						if (selected && selected is Edge &&
							(selected as Edge).node1 == now.node && (selected as Edge).node2 == now.node2) selected = null;
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
						if (selected && selected is Node && (selected as Node).GetName() == now.node) selected = null;
						node[now.node].dispose();
						delete node[now.node];
					} else {
						if(now.mode == AlterInfo.REMOVE){
							node[now.node] = new Node(now.node);
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
						if (selected && selected is Edge &&
							(selected as Edge).node1 == now.node && (selected as Edge).node2 == now.node2) selected = null;
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
			
			UpdateDatalist();
			
			lastTime = _slider.value;
			
			if (FilterPanel.panel) FilterPanel.panel.ApplyFilters();
		}
		
		private function enterFrameHandler(e:Event):void {
			var dist:Number = MIN_DISTANCE;
			var nowNode:Node, nextNode:Node, nowEdge:Edge;
			var r:Number;
			
			nearest = null;
			
			for each(nowEdge in edge){
				nowNode = node[nowEdge.node1];
				nextNode = node[nowEdge.node2];
				
				if (nowEdge.consider)
				{
					nowNode.speedX += nowEdge.weight * Edge.CONSTANT * (nextNode.x - nowNode.x);
					nowNode.speedY += nowEdge.weight * Edge.CONSTANT * (nextNode.y - nowNode.y);
					
					nextNode.speedX -= nowEdge.weight * Edge.CONSTANT * (nextNode.x - nowNode.x);
					nextNode.speedY -= nowEdge.weight * Edge.CONSTANT * (nextNode.y - nowNode.y);
				}
				
				nowEdge.highlighted = false;
			}
			
			for each(nowNode in node){
				for each(nextNode in node){
					if (nextNode != nowNode) {
						r = Point.distance(new Point(nextNode.x, nextNode.y), new Point(nowNode.x, nowNode.y));
						if (r < 0.1) r = 0.1;
						r = r * r * r;
						
						if (nowNode.consider && nextNode.consider)
						{
							nowNode.speedX -= nowNode.weight * nextNode.weight * Node.CONSTANT * (nextNode.x - nowNode.x) / r;
							nowNode.speedY -= nowNode.weight * nextNode.weight * Node.CONSTANT * (nextNode.y - nowNode.y) / r;
						}
					}
				}
				
				nowNode.highlighted = false;
				
				if(dist > nowNode.distance(mouseX, mouseY)){
					dist = nowNode.distance(mouseX, mouseY);
					nearest = nowNode;
				}
			}
			
			for each(nowNode in node) {
				nowNode.updatePosition();
			}
			
			for each(nowEdge in edge){
				nowEdge.update();
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
	}
}