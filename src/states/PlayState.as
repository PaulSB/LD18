/**
 * LD18 - "Enemies as Weapons"
 * -----------
 * PlayState.as
 * @author Paul S Burgess - 21/08/10
 */

package states
{
	// IMPORTS
	import flash.geom.Point;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	//import org.flixel.FlxText;
	
	import Enemy;
	import Player;
	
	public class PlayState extends FlxState
	{	
		//Flex v4.x SDK only:
		//[Embed(source = "../../data/font/Robotaur Condensed.ttf", fontFamily = "Robotaur", embedAsCFF = "false")] protected var junk:String;

		// Map data
		[Embed(source = '../../data/world/tiles_main.png')] private var imgTilesMain:Class;
		[Embed(source = '../../data/world/map1_main.txt', mimeType = "application/octet-stream")] private var dataMap1Main:Class;
		[Embed(source = '../../data/world/floor.png')] private var imgFloor:Class;
		[Embed(source = '../../data/world/entry_point.png')] private var imgEnemyPoint:Class;
		
		[Embed(source = '../../data/objects/bullet_v.png')] private var imgBulletVert:Class;
		[Embed(source = '../../data/objects/bullet_h.png')] private var imgBulletHoriz:Class;
		
		// Constants
		private const k_iTileScale:int = 40;
		private const k_iBulletSpeed:int = 200;
		
		// Render layers
		static private var s_layerBackground:FlxGroup;
		static private var s_layerPlayer:FlxGroup;
		static private var s_layerForeground:FlxGroup;
		
		private var m_tMapMain:FlxTilemap;
		private var m_tFloor:FlxSprite;
		private var m_tEntryPoint:FlxSprite;	// Visible Enemy spawn location (just 1 for now at least)
		
		private var m_tPlayer:Player;
		private var m_tEnemies:Array;	// To be filled with Enemy objects
		private var m_tBullets:Array;	// To be filled with FlxSprite objects
		
		override public function create():void
		{
			// Initialisation
			m_tMapMain = new FlxTilemap;
			m_tMapMain.loadMap(new dataMap1Main, imgTilesMain, k_iTileScale);
			
			m_tFloor = new FlxSprite;
			m_tFloor.loadGraphic(imgFloor);
			
			var tSpawnLoc:Point = new Point(k_iTileScale * 8, k_iTileScale * 1);
			m_tEntryPoint = new FlxSprite(tSpawnLoc.x, tSpawnLoc.y);
			m_tEntryPoint.loadGraphic(imgEnemyPoint);
			
			m_tPlayer = new Player(k_iTileScale * 1, k_iTileScale * 8);
			
			m_tEnemies = new Array;
			m_tEnemies.push(new Enemy(tSpawnLoc.x, tSpawnLoc.y));
			
			m_tBullets = new Array;
			
			// Add objects to layers
			s_layerBackground = new FlxGroup;
			s_layerBackground.add(m_tFloor);
			s_layerBackground.add(m_tEntryPoint);
			
			s_layerPlayer = new FlxGroup;
			s_layerPlayer.add(m_tPlayer);
			
			s_layerForeground = new FlxGroup;
			s_layerForeground.add(m_tEnemies[m_tEnemies.length-1]);	// TEMP, will be done as enemies spawn
			s_layerForeground.add(m_tMapMain);
			
			// Add layers
			add(s_layerBackground);
			add(s_layerPlayer);
			add(s_layerForeground);
		}
		
		override public function update():void
		{
			// Player-world collision
			s_layerPlayer.collide(m_tMapMain);
			
			// Enemies
			for (var i:int = 0; i < m_tEnemies.length; i++)
			{
				// Enemy-world collision
				if (m_tEnemies[i].collide(m_tMapMain) || m_tEnemies[i].collide(s_layerPlayer))
					m_tEnemies[i].m_bMoving = false;
					
				// Enemy bullet spawning
				if (m_tEnemies[i].m_bShotReady)
				{
					var tNewBullet:FlxSprite = new FlxSprite;
					tNewBullet.fixed = true;
					switch(m_tEnemies[i].facing)
					{
						case FlxSprite.LEFT:
							tNewBullet.loadGraphic(imgBulletHoriz);
							tNewBullet.x = m_tEnemies[i].x - tNewBullet.width;
							tNewBullet.y = m_tEnemies[i].y + (m_tEnemies[i].height - tNewBullet.height) * 0.5;
							tNewBullet.velocity.x = -k_iBulletSpeed;
							break;
						case FlxSprite.RIGHT:
							tNewBullet.loadGraphic(imgBulletHoriz);
							tNewBullet.x = m_tEnemies[i].x + m_tEnemies[i].width;
							tNewBullet.y = m_tEnemies[i].y + (m_tEnemies[i].height - tNewBullet.height) * 0.5;
							tNewBullet.velocity.x = +k_iBulletSpeed;
							break;
						case FlxSprite.UP:
							tNewBullet.loadGraphic(imgBulletVert);
							tNewBullet.x = m_tEnemies[i].x + (m_tEnemies[i].width - tNewBullet.width) * 0.5;
							tNewBullet.y = m_tEnemies[i].y - tNewBullet.height;
							tNewBullet.velocity.y = -k_iBulletSpeed;
							break;
						case FlxSprite.DOWN:
							tNewBullet.loadGraphic(imgBulletVert);
							tNewBullet.x = m_tEnemies[i].x + (m_tEnemies[i].width - tNewBullet.width) * 0.5;
							tNewBullet.y = m_tEnemies[i].y + m_tEnemies[i].height;
							tNewBullet.velocity.y = +k_iBulletSpeed;
							break;
					}
					
					m_tBullets.push(tNewBullet);
					s_layerBackground.add(m_tBullets[m_tBullets.length -1]);
					
					m_tEnemies[i].m_fShootTimer = m_tEnemies[i].k_ShotPeriod;
					m_tEnemies[i].m_bShotReady = false;
				}
			}
				
			// Bullets
			for (i = 0; i < m_tBullets.length; i++)
			{
				// Bullet-world collision
				if (m_tBullets[i].collide(m_tMapMain))
				{
					m_tBullets[i].kill();
					s_layerBackground.remove(m_tBullets[i]);
					m_tBullets.splice(i, 1);
				}
				// Bullet-player collision
				else if (m_tBullets[i].collide(s_layerPlayer))
				{
					m_tPlayer.kill();
				}
			}
			
			super.update();
		}
	}
}