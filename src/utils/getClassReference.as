package utils 
{
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	public function getClassReference(target:Object):Class
	{
		return getDefinitionByName(getQualifiedClassName(target)) as Class;
	}
}