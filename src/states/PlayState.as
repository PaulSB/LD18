/**
 * LD18 - "Enemies as Weapons"
 * -----------
 * PlayState.as
 * @author Paul S Burgess - 21/08/10
 */

package states
{
	// IMPORTS
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	//import org.flixel.FlxText;
	
	import Player;
	
	public class PlayState extends FlxState
	{	
		//Flex v4.x SDK only:
		//[Embed(source = "../../data/font/Robotaur Condensed.ttf", fontFamily = "Robotaur", embedAsCFF = "false")] protected var junk:String;

		// Map data
		[Embed(source = '../../data/world/tiles_main.png')] private var imgTilesMain:Class;
		[Embed(source = '../../data/world/map1_main.txt', mimeType = "application/octet-stream")] private var dataMap1Main:Class;
		
		// Render layers
		static private var s_layerBackground:FlxGroup;
		static private var s_layerPlayer:FlxGroup;
		static private var s_layerForeground:FlxGroup;
		
		public static var m_tMapMain:FlxTilemap;
		
		private var m_tPlayer:Player;
		
		override public function create():void
		{
			m_tMapMain = new FlxTilemap;
			m_tMapMain.loadMap(new dataMap1Main, imgTilesMain, 40);
			
			m_tPlayer = new Player(40, 320);
			
			s_layerPlayer = new FlxGroup;
			s_layerPlayer.add(m_tPlayer);
			s_layerForeground = new FlxGroup;
			s_layerForeground.add(m_tMapMain);
			
			add(s_layerPlayer);
			add(s_layerForeground);
		}
		
		override public function update():void
		{
			s_layerPlayer.collide(m_tMapMain);
			
			super.update();
		}
	}
}