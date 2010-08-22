/**
 * LD18 - "Enemies as Weapons"
 * -----------
 * Enemy.as
 * @author Paul S Burgess - 22/08/10
 */

package  
{
	import flash.geom.Rectangle;
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxU;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source = '../data/objects/enemy.png')] private var imgEnemy:Class;
		[Embed(source = '../data/objects/hackbar.png')] private var imgHackBar:Class;
		[Embed(source = '../data/objects/damagebar.png')] private var imgDmgBar:Class;
		
		public const k_fShotPeriod:Number = 2.0;
		private const k_iMoveSpeed:int = 80;
		private const k_fHackTimeReq:Number = 2.0;
		private const k_fDegradePeriod:Number = 1.0;
		
		public var m_bMoving:Boolean = false;
		public var m_bShotReady:Boolean = false;
		public var m_fShootTimer:Number;
		public var m_fHackedTime:Number = 0;
		public var m_bIsTurret:Boolean = false;
		public var m_tHackBar:FlxSprite;
		
		private var m_bIsHorizontal:Boolean;
		private var m_fMoveWaitTimer:Number;
		private var m_fDegradeTimer:Number = 0;
		
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
			velocity.y = k_iMoveSpeed;
			play("walk_v");
			m_bMoving = true;
			m_fMoveWaitTimer = 0.5;
			m_fShootTimer = k_fShotPeriod;
			
			// Bounding box modifications
			width -= 4;		offset.x = 2;	x += 2;
			height -= 4;	offset.y = 2;	y += 2;
			
			// Hack progress bar
			m_tHackBar = new FlxSprite(x, y + height);
			m_tHackBar.loadGraphic(imgHackBar);
			m_tHackBar.y -= m_tHackBar.height;
			m_tHackBar.alpha = 0;
		}
		
		override public function update():void
		{
			if (!m_bMoving && !m_bIsTurret)
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
						velocity.x = (facing == LEFT) ? -k_iMoveSpeed : +k_iMoveSpeed;
						play("walk_h");
					}
					else
					{
						velocity.y = (facing == UP) ? -k_iMoveSpeed : +k_iMoveSpeed;
						play("walk_v");
					}
					
					m_bMoving = true;
					m_fMoveWaitTimer = 0.5;
				}
			}
			else
			{
				// Shooting occurs when moving or after conversion to turret
				if (m_fShootTimer > 0)
				{
					m_fShootTimer -= FlxG.elapsed;
				}
				else
				{
					m_bShotReady = true;
				}
			}
			
			// Hacked?
			if (!m_bIsTurret)
			{
				m_tHackBar.alpha = Math.min((m_fHackedTime / k_fHackTimeReq), 1);
				if (m_fHackedTime > k_fHackTimeReq)
				{
					// Become turret
					m_bIsTurret = true;
					fixed = true;
					m_bMoving = false;
					velocity.x = velocity.y = 0;
					if (m_bIsHorizontal)	play("stand_h");	// TO DO - distinct turret animation
					else 					play("stand_v");
					color = 0x80ff80;
					health = 1;
					m_tHackBar.loadGraphic(imgDmgBar);
					m_tHackBar.alpha = 0;
				}
			}
			else
			{
				// Degrade turrets over time
				if (m_fDegradeTimer > k_fDegradePeriod)
				{
					health -= 0.01;
					m_tHackBar.alpha = (1 - health);
					m_fDegradeTimer = 0;
				}
				else
				{
					m_fDegradeTimer += FlxG.elapsed;
				}
			}
			
			super.update();
			
			// Stick hack/status bar to correct position post-update
			m_tHackBar.x = x;
			m_tHackBar.y = y + height;
		}
	}
}