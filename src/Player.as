/**
 * LD18 - "Enemies as Weapons"
 * -----------
 * PlayState.as
 * @author Paul S Burgess - 21/08/10
 */

package
{
	// IMPORTS
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		[Embed(source = '../data/objects/player.png')] private var imgPlayer:Class;
		
		public function Player(iX:int, iY:int)
		{
			super(iX, iY);
			loadGraphic(imgPlayer, true, true, 40, 40);
		}
	}
}
