package;

import demo.EasingGraphsDemo;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween.FlxTweenManager;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import macrotween.Ease;
import macrotween.Timeline;
import macrotween.Tween;

class PlayState extends FlxState {
	private var test:FlxSprite;
	private var timeline:Timeline;
	
	private var reversed:Bool;
	private var time:Float;
	
	private var graphsDemoButton:FlxButton;
	
	var flxTweeners:FlxTweenManager = new FlxTweenManager();
	var flixelTweens:Bool = true;
	var text:FlxText;
	
	private function init():Void {
		test = new FlxSprite(100, 100);
		test.makeGraphic(100, 100, FlxColor.RED);
		add(test);
		
		time = 0;
		
		text = new FlxText(20, 40, 0, "Flixel", 24);
		add(text);
		
		var fps = new lycan.system.FpsText();
		add(fps);
		
		timeline = new Timeline();
		timeline.currentTime = 0.1;
		
		var start:Float = 0;
		var duration:Float = 10;
		
		for (i in 0...10000) {
			var spr = new FlxSprite();
			timeline.add(Tween.tween([spr.x => 500], duration, start, Ease.quadInOut));
			flxTweeners.tween(spr, {x: 500}, duration, {ease: FlxEase.quadInOut});
		}
		
		graphsDemoButton = new FlxButton(FlxG.width / 2, FlxG.height / 2, "Graphs Demo", ()-> {
			openSubState(new EasingGraphsDemo());
		});
		add(graphsDemoButton);
		
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