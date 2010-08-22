/**
 * LD18 - "Enemies as Weapons"
 * -----------
 * Enemy.as
 * @author Paul S Burgess - 22/08/10
 */

package  
{
	import org.flixel.FlxSprite;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source = '../data/objects/enemy.png')] private var imgEnemy:Class;
		
		private const k_MoveSpeed:int = 80;
		
		private var m_bIsHorizontal:Boolean;
		
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
			
			// Bounding box modifications
			width -= 4;		offset.x = 2;	x += 2;
			height -= 8;	offset.y = 4;	y += 4;
		}
		
		override public function update():void
		{
			super.update();
		}
	}
}