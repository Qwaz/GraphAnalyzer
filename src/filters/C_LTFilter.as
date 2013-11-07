package filters 
{
	import utils.TrivialError;
	
	public class C_LTFilter extends ConditionFilter 
	{
		public function C_LTFilter() 
		{
			super();
		}
		
		override public function getParameters():Array
		{
			return [Value, Value];
		}
		
		override public function check(node:String, data:Object):Boolean
		{
			var a:Object, b:Object;
			
			try
			{
				a = (parameter[0] as Value).Get(node, data);
				b = (parameter[1] as Value).Get(node, data);
			}
			catch (e:TrivialError)
			{
				return false;
			}
			
			if (a is int && b is int)
			{
				return (a as int) < (b as int);
			}
			else if (a is Number && b is Number)
			{
				return (a as Number) < (b as Number);
			}
			else if (a is String && b is String)
			{
				return (a as String) < (b as String);
			}
			else
			{
				throw new Error("서로 같은 타입의 크기만 비교할 수 있습니다.");
			}
		}
		
		public static function getName():String {
			return "작은지 비교";
		}
	}
}