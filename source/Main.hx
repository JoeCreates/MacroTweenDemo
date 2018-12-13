package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
	public function new() {
		super();
		
		// Disable right click context menu (desirable in browsers)
		stage.showDefaultContextMenu = false;
		
		addChild(new FlxGame(0, 0, PlayState, 1, 60, 60, true));
	}
}
