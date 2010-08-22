/**
 * LD18 - "Enemies as Weapons"
 * -----------
 * Player.as
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
		
		private var m_bIsHorizontal:Boolean;
		
		public function Player(iX:int, iY:int)
		{
			super(iX, iY);
			loadGraphic(imgPlayer, true, true, 40, 40);
			
			addAnimation("stand_v", [0]);
			addAnimation("stand_h", [1]);
			addAnimation("walk_v", [2,0,3,0], 10);
			addAnimation("walk_h", [4,1,5,1], 10);
			facing = DOWN;
			m_bIsHorizontal = false;
			
			// Bounding box modifications
			width -= 4;		offset.x = 2;
			height -= 8;	offset.y = 4;
		}
		
		override public function update():void
		{
			var bStopped:Boolean = true;
			if (velocity.y == 0)
			{
				if(FlxG.keys.LEFT || FlxG.keys.A)
				{
					bStopped = false;
					if (velocity.x >= 0)
					{
						velocity.x = -k_MoveSpeed;
						facing = LEFT;
						play("walk_h");
						m_bIsHorizontal = true;
					}
				}
				else if (FlxG.keys.RIGHT || FlxG.keys.D)
				{
					bStopped = false;
					if (velocity.x <= 0)
					{
						velocity.x = +k_MoveSpeed;
						facing = RIGHT;
						play("walk_h");
						m_bIsHorizontal = true;
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
					bStopped = false;
					if (velocity.y >= 0)
					{
						velocity.y = -k_MoveSpeed;
						facing = UP;
						play("walk_v");
						m_bIsHorizontal = false;
					}
				}
				else if (FlxG.keys.DOWN || FlxG.keys.S)
				{
					bStopped = false;
					if (velocity.y <= 0)
					{
						velocity.y = +k_MoveSpeed;
						facing = DOWN;
						play("walk_v");
						m_bIsHorizontal = false;
					}
				}
				else if (velocity.y)
				{
					velocity.y = 0;
				}
			}
			
			if (!bStopped)
			{
				if (m_bIsHorizontal)
					play("stand_h");
				else
					play("stand_v");
			}
				
			
			super.update();
		}
	}
}
