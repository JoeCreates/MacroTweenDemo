package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;

import macrotween.Cue;
import macrotween.Timeline;
import macrotween.Tween;
import macrotween.Tween.Tweener;
import macrotween.TimelineItem;
import macrotween.TimelineItem.Boundary;

class PlayState extends FlxState {
	private var test:FlxSprite;
	
	private var timeline:Timeline;
	
	override public function create():Void {
		super.create();
		
		test = new FlxSprite(100, 100);
		test.makeGraphic(100, 100, FlxColor.RED);
		add(test);
		
		timeline = new Timeline();
		var tween:Tween = Tween.tween(0, 1, [test.x => 500], FlxEase.linear);
		
		timeline.add(tween);
		
		tween.onUpdate(0.5);
		Sure.sure(test.x == 250); // Should evaluate to 250
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}