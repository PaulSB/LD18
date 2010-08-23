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
	import flash.geom.Point
	
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		[Embed(source = '../data/objects/player.png')] private var imgPlayer:Class;
		
		private const k_MoveSpeed:int = 100;
		
		public var m_tPlayerPos:Point;
		public var m_bDoingAction:Boolean = false;
		public var m_bIsHorizontal:Boolean;
		public var m_bHacking:Boolean = false;
		
		public function Player(iX:int, iY:int)
		{
			super(iX, iY);
			loadGraphic(imgPlayer, true, true, 40, 40);
			
			m_tPlayerPos = new Point(x + (width * 0.5), y + (height * 0.5));
			
			addAnimation("stand_v", [0]);
			addAnimation("stand_h", [1]);
			addAnimation("walk_v", [2,0,3,0], 10);
			addAnimation("walk_h", [4,1,5,1], 10);
			addAnimation("use_v", [6]);
			addAnimation("use_h", [8]);
			addAnimation("hack_v", [7]);
			addAnimation("hack_h", [9]);
			addAnimation("usewalk_v", [10,6,14,6], 10);
			addAnimation("usewalk_h", [12,8,16,8], 10);
			addAnimation("hackwalk_v", [11,7,15,7], 10);
			addAnimation("hackwalk_h", [13,9,17,9], 10);
			facing = UP;
			m_bIsHorizontal = false;
			
			// Bounding box modifications
			width -= 4;		offset.x = 2;	x += 2;
			height -= 8;	offset.y = 4;	y += 4;
		}
		
		override public function update():void
		{
			var bStopped:Boolean = true;
			if (velocity.y == 0)
			{
				if(FlxG.keys.LEFT || FlxG.keys.A)
				{
					bStopped = false;
					if (m_bDoingAction)
					{
						if (m_bHacking)
							play("hackwalk_h");
						else
							play("usewalk_h");
					}
					else
						play("walk_h");
						
					if (velocity.x >= 0)
					{
						velocity.x = -k_MoveSpeed;
						facing = LEFT;
						
						m_bIsHorizontal = true;
					}
				}
				else if (FlxG.keys.RIGHT || FlxG.keys.D)
				{
					bStopped = false;
					if (m_bDoingAction)
					{
						if (m_bHacking)
							play("hackwalk_h");
						else
							play("usewalk_h");
					}
					else
						play("walk_h");
						
					if (velocity.x <= 0)
					{
						velocity.x = +k_MoveSpeed;
						facing = RIGHT;
						
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
					if (m_bDoingAction)
					{
						if (m_bHacking)
							play("hackwalk_v");
						else
							play("usewalk_v");
					}
					else
						play("walk_v");
						
					if (velocity.y >= 0)
					{
						velocity.y = -k_MoveSpeed;
						facing = UP;
						
						m_bIsHorizontal = false;
					}
				}
				else if (FlxG.keys.DOWN || FlxG.keys.S)
				{
					bStopped = false;
					if (m_bDoingAction)
					{
						if (m_bHacking)
							play("hackwalk_v");
						else
							play("usewalk_v");
					}
					else
						play("walk_v");
						
					if (velocity.y <= 0)
					{
						velocity.y = +k_MoveSpeed;
						facing = DOWN;
						
						m_bIsHorizontal = false;
					}
				}
				else if (velocity.y)
				{
					velocity.y = 0;
				}
			}
			
			if (bStopped)
			{
				if (m_bDoingAction)
				{
					if (m_bHacking)
					{
						if (m_bIsHorizontal)
							play("hack_h");
						else
							play("hack_v");
					}
					else
					{
						if (m_bIsHorizontal)
							play("use_h");
						else
							play("use_v");
					}
				}
				else
				{
					if (m_bIsHorizontal)
						play("stand_h");
					else
						play("stand_v");
				}
			}

			// "Action" command
			if (FlxG.keys.SPACE)
			{
				m_bDoingAction = true;
			}
			else
			{
				m_bDoingAction = false;
			}
			
			super.update();
			
			// Update centre-position
			m_tPlayerPos.x = x + (width * 0.5);
			m_tPlayerPos.y = y + (height * 0.5);
		}
		
		public function isPointInFrontOfPlayer(tPoint:Point):Boolean
		{
			var bRet:Boolean = false;
			switch(facing)
			{
				case LEFT:	bRet = (tPoint.x < m_tPlayerPos.x);	break;
				case RIGHT:	bRet = (tPoint.x > m_tPlayerPos.x);	break;
				case UP:	bRet = (tPoint.y < m_tPlayerPos.y);	break;
				case DOWN:	bRet = (tPoint.x > m_tPlayerPos.y);	break;
			}
			
			return bRet;
		}
	}
}
