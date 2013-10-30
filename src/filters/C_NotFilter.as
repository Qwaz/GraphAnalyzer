package filters 
{
	public class C_NotFilter extends ConditionFilter 
	{
		public function C_NotFilter() 
		{
			super();
		}
		
		override public function getParameters():Array
		{
			return [ConditionFilter];
		}
		
		override public function check(obj:Object):Boolean
		{
			if (parameter[0] is ConditionFilter)
			{
				return !(parameter[0] as ConditionFilter).check(obj);
			}
			else
			{
				throw new Error("NotFilter.check() : Type mismatch!");
			}
		}
		
		public static function getName():String {
			return "NOT";
		}
	}
}