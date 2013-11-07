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
			return !(parameter[0] as ConditionFilter).check(obj);
		}
		
		public static function getName():String {
			return "NOT";
		}
	}
}