/**
 * LD18 - "Enemies as Weapons"
 * -----------
 * PlayState.as
 * @author Paul S Burgess - 21/08/10
 */

package
{
	// IMPORTS
	import Math;
	
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
			addAnimation("stand_v", [0]);
			addAnimation("stand_h", [1]);
			facing = UP;
			
			// Bounding box modifications
			width -= 4;		offset.x = 2;
			height -= 8;	offset.y = 4;
		}
		
		override public function update():void
		{
			if (velocity.y == 0)
			{
				if(FlxG.keys.LEFT || FlxG.keys.A)
				{
					if (velocity.x >= 0)
					{
						velocity.x = -k_MoveSpeed;
						facing = LEFT;
						play("stand_h");
					}
				}
				else if (FlxG.keys.RIGHT || FlxG.keys.D)
				{
					if (velocity.x <= 0)
					{
						velocity.x = +k_MoveSpeed;
						facing = RIGHT;
						play("stand_h");
					}
				}
				else if (velocity.x)
				{
					velocity.x = 0;
				}
			}
			if (velocity.x == 0)
			{
				if (FlxG.keys.UP || FlxG.keys.W)
				{
					if (velocity.y >= 0)
					{
						velocity.y = -k_MoveSpeed;
						facing = UP;
						play("stand_v");
					}
				}
				else if (FlxG.keys.DOWN || FlxG.keys.S)
				{
					if (velocity.y <= 0)
					{
						velocity.y = +k_MoveSpeed;
						facing = DOWN;
						play("stand_v");
					}
				}
				else if (velocity.y)
				{
					velocity.y = 0;
				}
			}
			
			super.update();
		}
	}
}
