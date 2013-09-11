package filters 
{
	/**
	 * ...
	 * @author ...
	 */
	public class NandFilter extends ConditionFilter 
	{
		
		public function NandFilter() 
		{
			super();
			
		}
		
		public function getAttribute():Array
		{
			return [ConditionFilter, ConditionFilter];
		}
		
		public function check(obj:Object):Boolean
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
		
	}

}