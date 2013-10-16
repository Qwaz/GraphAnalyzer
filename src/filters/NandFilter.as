package filters 
{
	public class NandFilter extends ConditionFilter 
	{
		public function NandFilter() 
		{
			super();
		}
		
		override public function getParameters():Array
		{
			return [ConditionFilter, ConditionFilter];
		}
		
		override public function check(obj:Object):Boolean
		{
			if (parameter[0] is ConditionFilter && parameter[1] is ConditionFilter)
			{
				return !(parameter[0] as ConditionFilter).check(obj) || !(parameter[1] as ConditionFilter).check(obj);
			}
			else
			{
				throw new Error("NandFilter.check() : Type mismatch!");
			}
		}
		
		public static function getName():String {
			return "NAND";
		}
	}
}