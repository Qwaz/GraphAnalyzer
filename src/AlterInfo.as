package
{
	public class AlterInfo
	{
		//Type
		public static const
		NODE:int = 0,
		EDGE:int = 1;
		
		//Mode
		public static const
		ADD:int = 0,
		REMOVE:int = 1,
		CHANGE:int = 2;
		
		public var time:Number, type:int, mode:int, data:Object, prev:Object;
		public var node:String, node2:String;
		
		public function AlterInfo()
		{
			data = new Object();
			prev = new Object();
		}
		
		public static function sortFunc(p:AlterInfo, q:AlterInfo):int {
			if(p.time == q.time) return 0;
			else if(p.time < q.time) return -1;
			else return 1;
		}
	}
}