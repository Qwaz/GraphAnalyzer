package filters 
{
	public class ConditionFilter extends Filter
	{
		
		public function ConditionFilter() 
		{
			super();
		}
		
		public function check(node:String, data:Object):Boolean
		{
			return false;
		}
	}
}