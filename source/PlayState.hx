package;

import flixel.text.FlxText;
import flixel.tweens.FlxTween.FlxTweenManager;
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
	
	var flxTweeners:FlxTweenManager = new FlxTweenManager();
	var flixelTweens:Bool = true;
	var text:FlxText;
	
	private function init():Void {
		test = new FlxSprite(100, 100);
		test.makeGraphic(100, 100, FlxColor.RED);
		add(test);
		
		tlBegin = 0;
		tlEnd = 10;
		time = 0;
		
		text = new FlxText(20, 40, 0, "Flixel", 24);
		add(text);
		
		var fps = new lycan.system.FpsText();
		add(fps);
		
		timeline = new Timeline();
		timeline.currentTime = 0.1;
		
		for (i in 0...10000) {
			var spr = new FlxSprite();
			timeline.add(Tween.tween(tlBegin, tlEnd, [spr.x => 500], Ease.quadInOut));
			flxTweeners.tween(spr, {x: 500}, tlEnd, {ease: FlxEase.quadInOut});
			//add(spr);
		}
		
		reversed = false;
	}
	
	override public function create():Void {
		super.create();
		init();
	}

	override public function update(dt:Float):Void {
		super.update(dt);
		
		if (FlxG.keys.justPressed.R) {
			reversed = !reversed;
		}
		
		if (FlxG.keys.justPressed.SPACE) {
			flixelTweens = !flixelTweens;
			text.text = flixelTweens? "Flixel" : "MacroTween";
			
		}
		
		if (flixelTweens) {
			flxTweeners.update(dt);
		} else {
			timeline.step(dt);
		}
	}
}