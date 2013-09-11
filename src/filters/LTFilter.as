package filters 
{
	/**
	 * ...
	 * @author 함도영
	 */
	public class LTFilter extends ConditionFilter 
	{
		
		public function LTFilter() 
		{
			super();
			
		}
		
		override public function getAttribute():Array
		{
			return [Value, Value];
		}
		
		override public function check(obj:Object):Boolean
		{
			var a:Object, b:Object;
			
			if (parameter[0] is Value && parameter[1] is Value)
			{
				a = (parameter[0] as Value).Get(obj);
				b = (parameter[1] as Value).Get(obj);
			}
			else
			{
				throw new Error("LTFilter.check() : Type mismatch!");
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
				throw new Error("LTFilter.check() : Type mismatch!");
			}
		}
		
	}

}