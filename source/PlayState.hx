package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

import macrotween.Ease;
import macrotween.Timeline;
import macrotween.Tween;
import macrotween.Tween.Tweener;
import macrotween.TimelineItem;

class PlayState extends FlxState {
	private var test:FlxSprite;
	private var timeline:Timeline;
	
	private var tlBegin:Float;
	private var tlEnd:Float;
	private var reversed:Bool;
	private var time:Float;
	
	private function init():Void {
		test = new FlxSprite(100, 100);
		test.makeGraphic(100, 100, FlxColor.RED);
		add(test);
		
		tlBegin = 0;
		tlEnd = 1;
		time = 0;
		
		timeline = new Timeline();
		var tween:Tween = Tween.tween(tlBegin, tlEnd, [test.x => 500], Ease.quadInOut);
		timeline.add(tween);
		
		reversed = false;
	}
	
	override public function create():Void {
		super.create();
		init();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.R) {
			reversed = !reversed;
		}
		
		time += reversed ? -elapsed : elapsed;
		timeline.stepTo(time);
	}
}