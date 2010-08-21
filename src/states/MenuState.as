/**
 * LD18 - "Enemies as Weapons"
 * -----------
 * MenuState.as
 * @author Paul S Burgess - 21/08/10
 */

package states
{
	// IMPORTS
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class MenuState extends FlxState
	{	
		//Flex v4.x SDK only:
		[Embed(source = "../../data/font/Robotaur Condensed.ttf", fontFamily = "Robotaur", embedAsCFF = "false")] protected var junk:String;
		
		override public function create():void
		{
			// Title text
			var tTxt:FlxText
			tTxt = new FlxText(0, FlxG.height/2 -48, FlxG.width, "The Robots and I")
			tTxt.setFormat("Robotaur", 48, 0xFFFFFFFF, "center")
			this.add(tTxt);
			
			// Instruction text
			tTxt = new FlxText(0, FlxG.height -48, FlxG.width, "Press SPACE to continue")
			tTxt.setFormat("Robotaur", 24, 0xFFFFFFFF, "center");
			this.add(tTxt);
		}
		
		override public function update():void
		{
			if (FlxG.keys.justPressed("SPACE"))
			{
				FlxG.fade.start(0xff000000, 0.5, onFade);
			}            
			super.update();
		}
		
		private function onFade():void
		{
			FlxG.state = new PlayState();
		}
	}
}