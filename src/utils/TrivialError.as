package utils 
{
	public class TrivialError extends Error 
	{
		public function TrivialError(message:*="", id:*=0) 
		{
			super(message, id);
		}
	}
}
