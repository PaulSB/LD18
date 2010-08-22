/**
 * LD18 - "Enemies as Weapons"
 * -----------
 * Enemy.as
 * @author Paul S Burgess - 22/08/10
 */

package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source = '../data/objects/enemy.png')] private var imgEnemy:Class;
		
		public const k_ShotPeriod:Number = 2.0;
		private const k_MoveSpeed:int = 80;
		
		public var m_bMoving:Boolean = false;
		public var m_bShotReady:Boolean = false;
		public var m_fShootTimer:Number;
		
		private var m_bIsHorizontal:Boolean;
		private var m_fMoveWaitTimer:Number;
		
		public function Enemy(iX:int, iY:int)
		{
			super(iX, iY);
			loadGraphic(imgEnemy, true, true, 40, 40);
			
			addAnimation("stand_v", [0]);
			addAnimation("stand_h", [1]);
			addAnimation("walk_v", [2,0,3,0], 8);
			addAnimation("walk_h", [4,1,5,1], 8);
			facing = DOWN;
			m_bIsHorizontal = false;
			// Set robot off moving
			velocity.y = k_MoveSpeed;
			play("walk_v");
			m_bMoving = true;
			m_fMoveWaitTimer = 0.5;
			m_fShootTimer = k_ShotPeriod;
			
			// Bounding box modifications
			width -= 4;		offset.x = 2;	x += 2;
			height -= 4;	offset.y = 2;	y += 2;
		}
		
		override public function update():void
		{
			if (!m_bMoving)
			{
				if (m_fMoveWaitTimer > 0)
				{
					m_fMoveWaitTimer -= FlxG.elapsed;
				}
				else
				{
					// We've been stopped but are free to now continue, choose left or right from current direction
					var bLeft:Boolean = (FlxU.random() < 0.5);
					
					// Pick new direction
					switch(facing)
					{
						case LEFT:	facing = (bLeft) ? DOWN : UP;		break;
						case RIGHT:	facing = (bLeft) ? UP : DOWN;		break;
						case UP:	facing = (bLeft) ? LEFT : RIGHT;	break;
						case DOWN:	facing = (bLeft) ? RIGHT : LEFT;	break;
					}
					
					m_bIsHorizontal = (facing == LEFT || facing == RIGHT);
					
					if (m_bIsHorizontal)
					{
						velocity.x = (facing == LEFT) ? -k_MoveSpeed : +k_MoveSpeed;
						play("walk_h");
					}
					else
					{
						velocity.y = (facing == UP) ? -k_MoveSpeed : +k_MoveSpeed;
						play("walk_v");
					}
					
					m_bMoving = true;
					m_fMoveWaitTimer = 0.5;
				}
			}
			else
			{
				// Shooting occurs when moving
				if (m_fShootTimer > 0)
				{
					m_fShootTimer -= FlxG.elapsed;
				}
				else
				{
					m_bShotReady = true;
				}
			}
			
			super.update();
		}
	}
}