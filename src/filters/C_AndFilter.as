package filters 
{
	public class C_AndFilter extends ConditionFilter 
	{
		public function C_AndFilter() 
		{
			super();
		}
		
		override public function getParameters():Array
		{
			return [ConditionFilter, ConditionFilter];
		}
		
		override public function check(node:String, data:Object):Boolean
		{
			return (parameter[0] as ConditionFilter).check(node, data) && (parameter[1] as ConditionFilter).check(node, data);
		}
		
		public static function getName():String {
			return "AND";
		}
	}
}