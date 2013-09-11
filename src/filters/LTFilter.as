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
		
		public function getAttribute():Array
		{
			return [Value, Value];
		}
		
		public function check(obj:Object):Boolean
		{
			if (parameter[0] is int && parameter[1] is int)
			{
				return (parameter[0] as int) < (parameter[1] as int);
			}
			else if (parameter[0] is Number && parameter[1] is Number)
			{
				return (parameter[0] as Number) < (parameter[1] as Number);
			}
			else if (parameter[0] is String && parameter[1] is String)
			{
				return (parameter[0] as String) < (parameter[1] as String);
			}
			else
			{
				throw new Error("LTFilter.check() : Type mismatch!");
			}
		}
		
	}

}