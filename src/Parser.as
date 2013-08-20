package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Parser extends EventDispatcher
	{
		private static const
		FRAME:String="../frame.txt",
		GRAPH:String="../graph.txt",
		EDGE:String="../edge.txt",
		IGNORE:String=".";
		
		private var frameLoader:URLLoader, graphLoader:URLLoader, edgeLoader:URLLoader;
		
		private var numNodeData:uint, numEdgeData:uint;
		private var nodeDataList:Vector.<Data>, edgeDataList:Vector.<Data>;
		
		private var nodeDictionary:Object, edgeDictionary:Object;
		private var _nodeAlterInfo:Vector.<AlterInfo>, _edgeAlterInfo:Vector.<AlterInfo>;
		
		public var minimum:Number, maximum:Number, stepSize:Number;
		
		private var nodeLoaded:Boolean = false, edgeLoaded:Boolean = false;
		
		public function Parser()
		{
		}
		
		public function parse():void {
			parseFrame();
		}
		
		private function parseFrame():void {
			frameLoader = new URLLoader();
			frameLoader.addEventListener(Event.COMPLETE, frameLoadCompleteHandler);
			frameLoader.load(new URLRequest(FRAME));
		}
		
		private function frameLoadCompleteHandler(e:Event):void {
			var rawString:String = frameLoader.data;
			var split:Array = rawString.split(/\r?\n/);
			
			var cnt:int = 0;
			
			var year:Array = split[cnt++].split(' ');
			minimum = Number(year[0]);
			maximum = Number(year[1]);
			stepSize = Number(year[2]);
			
			var i:int, tp:Array;
			
			numNodeData = uint(split[1]);
			nodeDataList = new Vector.<Data>;
			nodeDictionary = new Object;
			for(i=0; i<numNodeData; i++){
				tp = split[cnt++].split(' ');
				nodeDataList.push(new Data(tp[0], tp[1]));
				nodeDictionary[tp[1]] = nodeDataList[nodeDataList.length-1]; 
			}
			
			numEdgeData = uint(split[cnt++]);
			edgeDataList = new Vector.<Data>;
			edgeDictionary = new Object;
			for(i=0; i<numEdgeData; i++){
				tp = split[cnt++].split(' ');
				edgeDataList.push(new Data(tp[0], tp[1]));
				edgeDictionary[tp[1]] = edgeDataList[edgeDataList.length-1];
			}
			
			parseGraph();
			parseEdge();
		}
		
		private function parseGraph():void {
			graphLoader = new URLLoader();
			graphLoader.addEventListener(Event.COMPLETE, graphLoadCompleteHandler);
			graphLoader.load(new URLRequest(GRAPH));
		}
		
		private function graphLoadCompleteHandler(e:Event):void {
			var rawString:String = graphLoader.data;
			var split:Array = rawString.split(/\r?\n/);
			
			var cnt:int = 0;
			
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
						
						for(j=1; j<numNodeData; j++){
							if(tp[j-1] != '.')
								tInfo.data[nodeDataList[j].name] = nodeDataList[j].parse(tp[j-1]);
						}
					} else if(tp[2] == '-')
						tInfo.mode = AlterInfo.REMOVE;
					else if(tp[2] == 'c'){
						tInfo.mode = AlterInfo.CHANGE;
						tp = split[cnt++].split(' ');
						
						tInfo[tp[0]] = nodeDictionary[tp[0]].parse(tp[1]);
					} else
						throw new Error("변경 모드 입력이 잘못되었습니다. Line : "+cnt);
				} else {
					tInfo.mode = AlterInfo.CHANGE;
					tp = split[cnt++].split(' ');
					
					for(j=1; j<numNodeData; j++){
						if(tp[j-1] != '.')
							tInfo.data[nodeDataList[j].name] = nodeDataList[j].parse(tp[j-1]);
					}
				}
				
				_nodeAlterInfo.push(tInfo);
			}
			
			_nodeAlterInfo.sort(AlterInfo.sortFunc);
			
			nodeLoaded = true;
			initCheck();
		}
		
		private function parseEdge():void {
			edgeLoader = new URLLoader();
			edgeLoader.addEventListener(Event.COMPLETE, edgeLoadCompleteHandler);
			edgeLoader.load(new URLRequest(EDGE));
		}
		
		private function edgeLoadCompleteHandler(e:Event):void {
			var rawString:String = edgeLoader.data;
			var split:Array = rawString.split(/\r?\n/);
			
			var cnt:int = 0;
			
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
								tInfo.data[edgeDataList[j].name] = edgeDataList[j].parse(tp[j]);
						}
					} else if(tp[3] == '-')
						tInfo.mode = AlterInfo.REMOVE;
					else if(tp[3] == 'c'){
						tInfo.mode = AlterInfo.CHANGE;
						tp = split[cnt++].split(' ');
						
						tInfo[tp[0]] = nodeDictionary[tp[0]].parse(tp[1]);
					} else
						throw new Error("변경 모드 입력이 잘못되었습니다. Line : "+cnt);
				} else {
					tInfo.mode = AlterInfo.CHANGE;
					tp = split[cnt++].split(' ');
					
					for(j=0; j<numEdgeData; j++){
						if(tp[j] != '.')
							tInfo.data[edgeDataList[j].name] = edgeDataList[j].parse(tp[j]);
					}
				}
				
				_edgeAlterInfo.push(tInfo);
			}
			
			_edgeAlterInfo.sort(AlterInfo.sortFunc);
			
			edgeLoaded = true;
			initCheck();
		}
		
		private function initCheck():void {
			if(nodeLoaded && edgeLoaded){
				var nowNode:Object, nowEdge:Object;
				
				nowNode = new Object();
				nowEdge = new Object();
				
				var i:int, now:AlterInfo;
				for(i=0; i<_nodeAlterInfo.length; i++){
					now = _nodeAlterInfo[i];
					if(now.mode == AlterInfo.ADD){
						nowNode[now.node] = new Object();
					}
					overwrite(nowNode[now.node], now, now.mode != AlterInfo.ADD);
					if(now.mode == AlterInfo.REMOVE){
						delete nowNode[now.node];
					}
				}
				
				for(i=0; i<_edgeAlterInfo.length; i++){
					now = _edgeAlterInfo[i];
					if(now.mode == AlterInfo.ADD){
						nowEdge[hash(now)] = new Object();
					}
					overwrite(nowEdge[hash(now)], now, now.mode != AlterInfo.ADD);
					if(now.mode == AlterInfo.REMOVE){
						delete nowEdge[hash(now)];
					}
				}
				
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function hash(target:AlterInfo):String {
			return target.node+'$$$$$'+target.node2;
		}
		
		private function overwrite(target:Object, source:AlterInfo, savePrev:Boolean):void {
			var str:String;
			for(str in source.data){
				if(savePrev){
					source.prev[str] = target[str];
				}
				target[str] = source.data[str];
			}
		}
		
		public function get nodeAlterInfo():Vector.<AlterInfo>{
			return _nodeAlterInfo;
		}
		
		public function get edgeAlterInfo():Vector.<AlterInfo>{
			return _edgeAlterInfo;
		}
	}
}