/**
 * "Enemies as Weapons"
 * -----------
 * Main.as
 * @author Paul S Burgess - 21/08/10
 */

package  
{
	// IMPORTS
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import states.MenuState;
	
	// Display properties
	[SWF(width = "640", height = "640", backgroundColor = "#000000")]
	// Prep preloader
	[Frame(factoryClass="Preloader")]
	
	public class Main extends FlxGame
	{
		public function Main()
		{
			// Entry - invoke FlxGame constructor
			super(640, 640, MenuState, 1);
		}
	}
}