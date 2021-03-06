package data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Parser extends EventDispatcher
	{
		private static const
		FRAME:String="../frame.txt",
		GRAPH:String="../node.txt",
		EDGE:String="../edge.txt",
		IGNORE:String=".";
		
		private var frameLoader:URLLoader, graphLoader:URLLoader, edgeLoader:URLLoader;
		
		private var numNodeData:uint, numEdgeData:uint;
		private var _nodeDataList:Vector.<Data>, _edgeDataList:Vector.<Data>;
		
		private var nodeDictionary:Object, edgeDictionary:Object;
		private var _nodeAlterInfo:Vector.<AlterInfo>, _edgeAlterInfo:Vector.<AlterInfo>;
		
		private var _timeList:Vector.<Number>;
		
		public var minimum:Number, maximum:Number, stepSize:Number;
		
		private var nodeLoaded:Boolean = false, edgeLoaded:Boolean = false;
		
		public function Parser()
		{
		}
		
		public function parse():void {
			parseFrame();
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			trace('에러가 발생했습니다.');
		}
		
		private function parseFrame():void {
			frameLoader = new URLLoader();
			frameLoader.addEventListener(Event.COMPLETE, frameLoadCompleteHandler);
			frameLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			frameLoader.load(new URLRequest(FRAME));
		}
		
		private function frameLoadCompleteHandler(e:Event):void {
			frameLoader.removeEventListener(Event.COMPLETE, frameLoadCompleteHandler);
			
			_timeList = new Vector.<Number>;
			
			var rawString:String = frameLoader.data;
			var split:Array = rawString.split(/\r?\n/);
			
			var cnt:int = 0;
			
			try {
				var year:Array = split[cnt++].split(' ');
				minimum = Number(year[0]);
				maximum = Number(year[1]);
				stepSize = Number(year[2]);
				
				var i:int, tp:Array;
				
				numNodeData = uint(split[cnt++]);
				_nodeDataList = new Vector.<Data>;
				nodeDictionary = new Object;
				for(i=0; i<numNodeData; i++){
					tp = split[cnt++].split(' ');
					_nodeDataList.push(new Data(tp[0], tp[1]));
					nodeDictionary[tp[1]] = _nodeDataList[_nodeDataList.length-1]; 
				}
				
				numEdgeData = uint(split[cnt++]);
				_edgeDataList = new Vector.<Data>;
				edgeDictionary = new Object;
				for(i=0; i<numEdgeData; i++){
					tp = split[cnt++].split(' ');
					_edgeDataList.push(new Data(tp[0], tp[1]));
					edgeDictionary[tp[1]] = _edgeDataList[_edgeDataList.length-1];
				}
			
				parseGraph();
				parseEdge();
			} catch (e:Error) {
				throw new Error("frame.txt에서 에러 / 현재 줄 수 : " + cnt);
			}
		}
		
		private function parseGraph():void {
			graphLoader = new URLLoader();
			graphLoader.addEventListener(Event.COMPLETE, graphLoadCompleteHandler);
			graphLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			graphLoader.load(new URLRequest(GRAPH));
		}
		
		private function graphLoadCompleteHandler(e:Event):void {
			graphLoader.removeEventListener(Event.COMPLETE, graphLoadCompleteHandler);
			
			var rawString:String = graphLoader.data;
			var split:Array = rawString.split(/\r?\n/);
			
			var cnt:int = 0;
			
			try {
				var i:int, j:int, tp:Array, tInfo:AlterInfo;
				_nodeAlterInfo = new Vector.<AlterInfo>;
				
				var numChange:int = int(split[cnt++]);
				for(i=0; i<numChange; i++){
					tp = split[cnt++].split(' ');
					tInfo = new AlterInfo();
					tInfo.time = Number(tp[0]);
					tInfo.node = tp[1];
					
					tInfo.type = AlterInfo.NODE;
					if(tp[2]){
						if(tp[2] == '+'){
							tInfo.mode = AlterInfo.ADD;
							tp = split[cnt++].split(' ');
							
							tInfo.data[_nodeDataList[0].name] = tInfo.node;
							for(j=1; j<numNodeData; j++){
								if(tp[j-1] != '.')
									tInfo.data[_nodeDataList[j].name] = _nodeDataList[j].parse(tp[j-1]);
							}
						} else if(tp[2] == '-')
							tInfo.mode = AlterInfo.REMOVE;
						else if(tp[2] == 'c'){
							tInfo.mode = AlterInfo.CHANGE;
							tp = split[cnt++].split(' ');
							
							tInfo.data[tp[0]] = nodeDictionary[tp[0]].parse(tp[1]);
						} else
							throw new Error("변경 모드 입력이 잘못되었습니다. Line : "+cnt);
					} else {
						tInfo.mode = AlterInfo.CHANGE;
						tp = split[cnt++].split(' ');
						
						for(j=1; j<numNodeData; j++){
							if(tp[j-1] != '.')
								tInfo.data[_nodeDataList[j].name] = _nodeDataList[j].parse(tp[j-1]);
						}
					}
					
					_timeList.push(tInfo.time);
					_nodeAlterInfo.push(tInfo);
				}
			
				_nodeAlterInfo.sort(AlterInfo.sortFunc);
				
				nodeLoaded = true;
				initCheck();
			} catch (e:Error) {
				throw new Error("node.txt에서 에러 / 현재 줄 수 : " + cnt);
			}
		}
		
		private function parseEdge():void {
			edgeLoader = new URLLoader();
			edgeLoader.addEventListener(Event.COMPLETE, edgeLoadCompleteHandler);
			edgeLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			edgeLoader.load(new URLRequest(EDGE));
		}
		
		private function edgeLoadCompleteHandler(e:Event):void {
			edgeLoader.removeEventListener(Event.COMPLETE, edgeLoadCompleteHandler);
			
			var rawString:String = edgeLoader.data;
			var split:Array = rawString.split(/\r?\n/);
			
			var cnt:int = 0;
			
			try {
				var i:int, j:int, tp:Array, tInfo:AlterInfo;
				_edgeAlterInfo = new Vector.<AlterInfo>;
				
				var numChange:int = int(split[cnt++]);
				
				for(i=0; i<numChange; i++){
					tp = split[cnt++].split(' ');
					tInfo = new AlterInfo();
					tInfo.time = Number(tp[0]);
					tInfo.node = tp[1];
					tInfo.node2 = tp[2];
					
					tInfo.type = AlterInfo.EDGE;
					if(tp[3]){
						if(tp[3] == '+'){
							tInfo.mode = AlterInfo.ADD;
							tp = split[cnt++].split(' ');
							
							for(j=0; j<numEdgeData; j++){
								if(tp[j] != '.')
									tInfo.data[_edgeDataList[j].name] = _edgeDataList[j].parse(tp[j]);
							}
						} else if(tp[3] == '-')
							tInfo.mode = AlterInfo.REMOVE;
						else if(tp[3] == 'c'){
							tInfo.mode = AlterInfo.CHANGE;
							tp = split[cnt++].split(' ');
							
							tInfo.data[tp[0]] = nodeDictionary[tp[0]].parse(tp[1]);
						} else
							throw new Error("변경 모드 입력이 잘못되었습니다. Line : "+cnt);
					} else {
						tInfo.mode = AlterInfo.CHANGE;
						tp = split[cnt++].split(' ');
						
						for(j=0; j<numEdgeData; j++){
							if(tp[j] != '.')
								tInfo.data[_edgeDataList[j].name] = _edgeDataList[j].parse(tp[j]);
						}
					}
					
					_timeList.push(tInfo.time);
					_edgeAlterInfo.push(tInfo);
				}
				
				_edgeAlterInfo.sort(AlterInfo.sortFunc);
				
				edgeLoaded = true;
				initCheck();
			} catch (e:Error) {
				throw new Error("edge.txt에서 에러 / 현재 줄 수 : " + cnt);	
			}
		}
		
		private function initCheck():void {
			if (nodeLoaded && edgeLoaded) {
				var i:int, now:AlterInfo;
				
				_timeList.sort(function(a:Number, b:Number):int { return a == b ? 0 : a < b ? -1 : 1; } );
				
				var nowNode:Object, nowEdge:Object;
				
				nowNode = new Object();
				nowEdge = new Object();
				for(i=0; i<_nodeAlterInfo.length; i++){
					now = _nodeAlterInfo[i];
					if(now.mode == AlterInfo.ADD){
						nowNode[now.node] = new Object();
					}
					overwrite(nowNode[now.node], now);
					if(now.mode == AlterInfo.REMOVE){
						delete nowNode[now.node];
					}
				}
				
				for(i=0; i<_edgeAlterInfo.length; i++){
					now = _edgeAlterInfo[i];
					if(now.mode == AlterInfo.ADD){
						nowEdge[now.hash()] = new Object();
					}
					overwrite(nowEdge[now.hash()], now);
					if(now.mode == AlterInfo.REMOVE){
						delete nowEdge[now.hash()];
					}
				}
				
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function overwrite(target:Object, source:AlterInfo):void {
			var str:String;
			if (source.mode == AlterInfo.REMOVE) {
				for (str in target) {
					source.prev[str] = target[str];
				}
			} else {
				for(str in source.data){
					if(source.mode != AlterInfo.ADD){
						source.prev[str] = target[str];
					}
					target[str] = source.data[str];
				}
			}
		}
		
		public function get nodeAlterInfo():Vector.<AlterInfo> {
			return _nodeAlterInfo;
		}
		
		public function get edgeAlterInfo():Vector.<AlterInfo> {
			return _edgeAlterInfo;
		}
		
		public function get nodeDataList():Vector.<Data> {
			return _nodeDataList;
		}
		
		public function get edgeDataList():Vector.<Data> {
			return _edgeDataList;
		}
		
		public function get timeList():Vector.<Number> {
			return _timeList;
		}
		
	}
}