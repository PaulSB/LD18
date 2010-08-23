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
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxText;
	import org.flixel.FlxU;
	
	import Enemy;
	import Player;
	
	public class PlayState extends FlxState
	{	
		//Flex v4.x SDK only:
		[Embed(source = "../../data/font/Robotaur Condensed.ttf", fontFamily = "Robotaur", embedAsCFF = "false")] protected var junk:String;

		// Map data
		[Embed(source = '../../data/world/tiles_main.png')] private var imgTilesMain:Class;
		[Embed(source = '../../data/world/map1_main.txt', mimeType = "application/octet-stream")] private var dataMap1Main:Class;
		[Embed(source = '../../data/world/floor.png')] private var imgFloor:Class;
		[Embed(source = '../../data/world/entry_point.png')] private var imgEnemyPoint:Class;
		
		[Embed(source = '../../data/objects/bullet_v.png')] private var imgBulletVert:Class;
		[Embed(source = '../../data/objects/bullet_h.png')] private var imgBulletHoriz:Class;
		
		// SFX
		[Embed(source = '../../data/sound/shoot.mp3')] private var sfxShoot:Class;
		[Embed(source = '../../data/sound/hurt.mp3')] private var sfxHurt:Class;
		[Embed(source = '../../data/sound/spawn.mp3')] private var sfxSpawn:Class;
		[Embed(source = '../../data/sound/hack.mp3')] private var sfxHack:Class;
		
		// Constants
		private const k_iTileScale:int = 40;
		private const k_iBulletSpeed:int = 200;
		private const k_fHackingRange:Number = 60;
		private const k_iMaxRobots:int = 64;
		
		// Render layers
		static private var s_layerBackground:FlxGroup;			// Floor
		static private var s_layerPlayer:FlxGroup;				// Player
		static private var s_layerForeground:FlxGroup;			// Robots
		static private var s_layerSuperForeground:FlxGroup;		// Bullets, indicators
		
		private var m_iNumKills:int = 0;
		private var m_bEndScreen:Boolean = false;	// Game over
		private var m_tEndText:FlxText;
		private var m_bTriggerEndText:Boolean = false;
		
		private var m_tMapMain:FlxTilemap;
		private var m_tFloor:FlxSprite;
		private var m_tEntryPoints:Array;	// Visible Enemy spawn location
		
		private var m_tPlayer:Player;
		private var m_tEnemies:Array;	// To be filled with Enemy objects
		private var m_tBullets:Array;	// To be filled with FlxSprite objects
		
		private var m_fWaveTimer:Number = 0;
		private var m_fWaveDuration:Number = 10;	// Modify depending on number of bots active at start of wave
		
		// SFX
		private var m_tSFXshoot:FlxSound;
		private var m_tSFXhurt:FlxSound;
		private var m_tSFXspawn:FlxSound;
		private var m_tSFXhack:FlxSound;
		
		override public function create():void
		{
			// Initialisation
			m_tMapMain = new FlxTilemap;
			m_tMapMain.loadMap(new dataMap1Main, imgTilesMain, k_iTileScale);
			
			m_tFloor = new FlxSprite;
			m_tFloor.loadGraphic(imgFloor);
			
			// Robot entry points
			m_tEntryPoints = new Array();
			m_tEntryPoints.push(new FlxSprite(k_iTileScale * 1, k_iTileScale * 1));
			m_tEntryPoints.push(new FlxSprite(k_iTileScale * 7, k_iTileScale * 1));
			m_tEntryPoints.push(new FlxSprite(k_iTileScale * 8, k_iTileScale * 1));
			m_tEntryPoints.push(new FlxSprite(k_iTileScale * 14, k_iTileScale * 1));
			for (var i:int = 0; i < m_tEntryPoints.length; i++)
				m_tEntryPoints[i].loadGraphic(imgEnemyPoint);
			
			m_tPlayer = new Player(k_iTileScale * 8, k_iTileScale * 8);
			
			m_tEnemies = new Array;		
			m_tBullets = new Array;
			
			m_tSFXshoot = new FlxSound;
			m_tSFXshoot.loadEmbedded(sfxShoot);
			m_tSFXhurt = new FlxSound;
			m_tSFXhurt.loadEmbedded(sfxHurt);
			m_tSFXspawn = new FlxSound;
			m_tSFXspawn.loadEmbedded(sfxSpawn);
			m_tSFXhack = new FlxSound;
			m_tSFXhack.loadEmbedded(sfxHack);
			
			// Add objects to layers
			s_layerBackground = new FlxGroup;
			s_layerBackground.add(m_tFloor);
			for (i = 0; i < m_tEntryPoints.length; i++)
				s_layerBackground.add(m_tEntryPoints[i]);
			
			s_layerPlayer = new FlxGroup;
			s_layerPlayer.add(m_tPlayer);
			
			s_layerForeground = new FlxGroup;
			s_layerForeground.add(m_tMapMain);
			
			s_layerSuperForeground = new FlxGroup;
			
			// Add layers
			add(s_layerBackground);
			add(s_layerPlayer);
			add(s_layerForeground);
			add(s_layerSuperForeground);
		}
		
		override public function update():void
		{
			if (m_bEndScreen)
			{
				// HIJAAAACK
				if (m_bTriggerEndText)
				{
					// Score text
					var szText:String = new String;
					szText = szText.concat("You were annihilated after disabling ", m_iNumKills, " machines (hit SPACE to play again)");
					
					m_tEndText = new FlxText(0, FlxG.height * 0.5 -32, FlxG.width, szText);
					m_tEndText.setFormat("Robotaur", 24, 0xFF00FF00, "center"); m_tEndText.shadow = 0xFF000000;
					s_layerSuperForeground.add(m_tEndText);
					
					m_bTriggerEndText = false;
				}
				
				if(FlxG.keys.SPACE)
					FlxG.state = new PlayState();
			}
			
			// Spawn enemies
			if	(m_fWaveTimer > m_fWaveDuration)
			{
				m_fWaveTimer = 0;
				spawnWaves();
				
				if (m_tEnemies.length > 20)
					m_fWaveDuration = 5;
				else if (m_tEnemies.length > 16)
					m_fWaveDuration = 6;
				else if (m_tEnemies.length > 12)
					m_fWaveDuration = 7;
				else if (m_tEnemies.length > 8)
					m_fWaveDuration = 8;
				else if (m_tEnemies.length > 4)
					m_fWaveDuration = 9;
				else if (m_tEnemies.length > 0)
					m_fWaveDuration = 10;
			}
			else
			{
				m_fWaveTimer += FlxG.elapsed;
			}
			
			// Player-world collision
			s_layerPlayer.collide(m_tMapMain);
			
			// Enemies
			m_tPlayer.m_bHacking = false;
			for (var i:int = 0; i < m_tEnemies.length; i++)
			{
				// Player hacking attempt
				if (!m_tEnemies[i].m_bIsTurret)
				{
					var tEnemyPos:Point = new Point(m_tEnemies[i].x + (m_tEnemies[i].width * 0.5), m_tEnemies[i].y + (m_tEnemies[i].height * 0.5));
					if (m_tPlayer.m_bDoingAction && m_tPlayer.isPointInFrontOfPlayer(tEnemyPos)
												&& Point.distance(m_tPlayer.m_tPlayerPos, tEnemyPos) < k_fHackingRange)
					{
						// This enemy is being hacked
						m_tEnemies[i].m_fHackedTime += FlxG.elapsed;
						if (!m_tSFXhack.playing)
							m_tSFXhack.play();
							
						m_tPlayer.m_bHacking = true;
					}
				}
				else
				{
					// Check here for turrets dying from degradation
					if (m_tEnemies[i].health <= 0)
					{
						m_tEnemies[j].kill();
						m_tEnemies[j].m_tHackBar.kill();
						s_layerForeground.remove(m_tEnemies[j]);
						s_layerSuperForeground.remove(m_tEnemies[j].m_tHackBar);
						m_tEnemies.splice(j, 1);
						m_tSFXhurt.play();
						m_iNumKills++;
						break;
					}
				}
				
				// Enemy-world/player/robot collision
				if (m_tEnemies[i].collide(m_tMapMain) || m_tEnemies[i].collide(s_layerPlayer))
					m_tEnemies[i].m_bMoving = false;
				else
				{
					for (var k:int = 0; k < m_tEnemies.length; k++)
					{
						if (m_tEnemies[k].m_bIsTurret && m_tEnemies[i].collide(m_tEnemies[k]))
							m_tEnemies[i].m_bMoving = false;
					}
				}
					
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
					
					if (m_tEnemies[i].m_bIsTurret)
					{
						tNewBullet.color = 0x80ff80;	// Hacked bullet of death
					}
					else
					{
						tNewBullet.health = 0.5;		// Feeble robot bullet
					}
					
					m_tBullets.push(tNewBullet);
					s_layerSuperForeground.add(m_tBullets[m_tBullets.length -1]);
					
					m_tEnemies[i].m_fShootTimer = m_tEnemies[i].k_fShotPeriod;
					m_tEnemies[i].m_bShotReady = false;
					
					m_tSFXshoot.play();
				}
			}
				
			// Bullets
			for (i = 0; i < m_tBullets.length; i++)
			{
				// Bullet-world collision
				if (m_tBullets[i].collide(m_tMapMain))
				{
					m_tBullets[i].kill();
					s_layerSuperForeground.remove(m_tBullets[i]);
					m_tBullets.splice(i, 1);
					break;
				}
				// Bullet-player collision
				else if (m_tBullets[i].collide(s_layerPlayer))
				{
					m_tBullets[i].kill();
					s_layerSuperForeground.remove(m_tBullets[i]);
					m_tBullets.splice(i, 1);
					
					m_tPlayer.kill();
					m_tSFXhurt.play();
					m_bEndScreen = true;
					m_bTriggerEndText = true;
					break;
				}
				else
				{
					// Bullet-robot collision
					if (m_tBullets[i].health > 0.8)
					{
						// Turrets hurt robots
						for (var j:int = 0; j < m_tEnemies.length; j++)
						{
							if (!m_tEnemies[j].m_bIsTurret && m_tBullets[i].collide(m_tEnemies[j]))
							{
								m_tEnemies[j].kill();
								m_tEnemies[j].m_tHackBar.kill();
								s_layerForeground.remove(m_tEnemies[j]);
								s_layerSuperForeground.remove(m_tEnemies[j].m_tHackBar);
								m_tEnemies.splice(j, 1);
								m_tSFXhurt.play();
								m_iNumKills++;
								
								m_tBullets[i].kill();
								s_layerSuperForeground.remove(m_tBullets[i]);
								m_tBullets.splice(i, 1);
								break;
							}
						}
					}
					else
					{
						// Robots hurt turrets (2 hits)
						for (j = 0; j < m_tEnemies.length; j++)
						{
							if (m_tEnemies[j].m_bIsTurret && m_tBullets[i].collide(m_tEnemies[j]))
							{
    							if (m_tEnemies[j].health <= 0.5)
								{
									m_tEnemies[j].kill();
									m_tEnemies[j].m_tHackBar.kill();
									s_layerForeground.remove(m_tEnemies[j]);
									s_layerSuperForeground.remove(m_tEnemies[j].m_tHackBar);
									m_tEnemies.splice(j, 1);
									m_tSFXhurt.play();
									m_iNumKills++;
									
									m_tBullets[i].kill();
									s_layerSuperForeground.remove(m_tBullets[i]);
									m_tBullets.splice(i, 1);
									break;
								}
								else
								{
									m_tEnemies[j].health -= 0.5;
									m_tEnemies[j].m_tHackBar.alpha = (1 - m_tEnemies[j].health);
									m_tSFXhurt.play();
									
									m_tBullets[i].kill();
									s_layerSuperForeground.remove(m_tBullets[i]);
									m_tBullets.splice(i, 1);
									break;
								}
							}
						}
					}
				}
			}
			
			super.update();
		}
		
		private function spawnWaves():void
		{
			if (m_tEnemies.length >= k_iMaxRobots)
				return;
			
			var fEntryPoint:Number = (FlxU.random() * 4);
			var iEntryPoint:int = 0;
			if (fEntryPoint >= 3.0)			iEntryPoint = 3;	// Bleeurgh
			else if (fEntryPoint >= 2.0)	iEntryPoint = 2;
			else if (fEntryPoint >= 1.0)	iEntryPoint = 1;
			
			m_tEnemies.push(new Enemy(m_tEntryPoints[iEntryPoint].x, m_tEntryPoints[iEntryPoint].y));
			
			s_layerForeground.add(m_tEnemies[m_tEnemies.length - 1]);
			s_layerSuperForeground.add(m_tEnemies[m_tEnemies.length - 1].m_tHackBar);
			
			m_tSFXspawn.play();
		}
	}
}