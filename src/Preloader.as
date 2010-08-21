/**
 * "Enemies as Weapons"
 * -----------
 * Preloader.as
 * @author Paul S Burgess - 21/08/10
 */

package
{
	// IMPORTS
	import org.flixel.FlxPreloader;
	
	public class Preloader extends FlxPreloader
	{
		public function Preloader() 
		{
			className = "Main";
			super();
			
			// Force at least this much preloader
			minDisplayTime = 3;
		}
	}
}