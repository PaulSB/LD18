/**
 * LD18 - "Enemies as Weapons"
 * -----------
 * PlayState.as
 * @author Paul S Burgess - 21/08/10
 */

package
{
	// IMPORTS
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		[Embed(source = '../data/objects/player.png')] private var imgPlayer:Class;
		
		private const k_MoveSpeed:int = 100;
		
		public function Player(iX:int, iY:int)
		{
			super(iX, iY);
			loadGraphic(imgPlayer, true, true, 40, 40);
			
			// Bounding box modifications
			width -= 4;		offset.x = 2;
			height -= 8;	offset.y = 4;
		}
		
		override public function update():void
		{
			if (FlxG.keys.LEFT)
			{
				velocity.x = -k_MoveSpeed;
			}
			else if (FlxG.keys.RIGHT)
			{
				velocity.x = +k_MoveSpeed;
			}
			else
			{
				velocity.x = 0;
			}
			
			if (FlxG.keys.UP)
			{
				velocity.y = -k_MoveSpeed;
			}
			else if (FlxG.keys.DOWN)
			{
				velocity.y = +k_MoveSpeed;
			}
			else
			{
				velocity.y = 0;
			}
			
			super.update();
		}
	}
}
