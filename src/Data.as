package
{
	public class Data
	{
		public static const
		STRING:String = "s",
		INT:String = "i",
		NUMBER:String = "n";
		
		public var type:String, name:String;
		
		public function Data(type:String, name:String){
			this.type = type;
			this.name = name;
		}
		
		public function parse(target:String):Object {
			if(type == STRING) return target;
			else if(type == INT) return int(target);
			else if(type == NUMBER) return Number(target);
			else
				throw new Error("Type 설정이 잘못되었습니다.");
		}
	}
}