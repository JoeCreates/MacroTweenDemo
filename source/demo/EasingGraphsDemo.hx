package demo;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.effects.FlxTrailArea;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lycan.states.LycanState;
import macrotween.Ease;
import macrotween.Timeline;
import macrotween.Tween;
import openfl.Lib;
import openfl.events.MouseEvent;

using flixel.util.FlxSpriteUtil;

class TweenGraph extends FlxSpriteGroup {
	public var description:String;
	public var ease:Float->Float;

	public var box:FlxSprite;
	public var point:FlxSprite;
	public var trailPoint:FlxSprite;

	public var graphX:Float = 0;
	public var graphY:Float = 0;

	public function new(description:String, ease:Float->Float) {
		super();

		this.description = description;
		this.ease = ease;

		box = new FlxSprite().makeGraphic(Std.int(FlxG.width / EasingGraphsDemo.TWEENS_PER_ROW - EasingGraphsDemo.ITEM_SPACING * 2), Std.int(FlxG.height / 11 - EasingGraphsDemo.ITEM_SPACING * 2), FlxColor.WHITE);
		box.drawRect(box.x, box.y, box.width, box.height, FlxColor.TRANSPARENT, { thickness: 2, color: FlxColor.BLACK });
		add(box);

		point = new FlxSprite();
		point.makeGraphic(6, 6, FlxColor.TRANSPARENT);
		point.drawCircle(3, 3, 3, FlxColor.RED);
		add(point);

		trailPoint = new FlxSprite();
		trailPoint.makeGraphic(2, 2, FlxColor.BLUE);
		add(trailPoint);

		var text = new FlxText(0, 0, 0, description, 8);
		text.color = FlxColor.GRAY;
		add(text);
		text.setPosition(width / 2 - text.width / 2, height / 2 - text.height / 2);
	}

	override public function update(dt:Float):Void {
		super.update(dt);

		point.x = graphX + x - point.width / 2;
		point.y = graphY + y - point.height / 2;
		
		trailPoint.x = graphX + x - trailPoint.width / 2;
		trailPoint.y = graphY + y - trailPoint.height / 2;
	}
}

class EasingGraphsDemo extends LycanState {
	public static inline var TWEENS_PER_ROW:Int = 4;
	public static inline var ITEM_SPACING:Int = 4;

	public var rateMultiplier:Float = 1;

	private var timeline:Timeline;
	private var graphs:Array<TweenGraph>;
	private var graphGroup:FlxSpriteGroup;
	private var trailArea:FlxTrailArea;
	private var userControlled:Bool;
	private var reversed:Bool;

	override public function create():Void {
		super.create();

		bgColor = FlxColor.GRAY;

		timeline = new Timeline();
		graphs = new Array<TweenGraph>();
		graphGroup = new FlxSpriteGroup();
		trailArea = new FlxTrailArea(0, 0, FlxG.width, FlxG.height, 0.95, 1);
		userControlled = false;
		reversed = false;
		
		inline function addTween(ease, description) {
			graphs.push(new TweenGraph(description, ease));
		};

		addTween(Ease.quadIn, "Ease.quadIn");
		addTween(Ease.quadOut, "Ease.quadOut");
		addTween(Ease.quadInOut, "Ease.quadInOut");
		addTween(Ease.quadOutIn, "Ease.quadOutIn");

		addTween(Ease.cubicIn, "Ease.cubicIn");
		addTween(Ease.cubicOut, "Ease.cubicOut");
		addTween(Ease.cubicInOut, "Ease.cubicInOut");
		addTween(Ease.cubicOutIn, "Ease.cubicOutIn");

		addTween(Ease.quartIn, "Ease.quartIn");
		addTween(Ease.quartOut, "Ease.quartOut");
		addTween(Ease.quartInOut, "Ease.quartInOut");
		addTween(Ease.quartOutIn, "Ease.quartOutIn");

		addTween(Ease.quintIn, "Ease.quintIn");
		addTween(Ease.quintOut, "Ease.quintOut");
		addTween(Ease.quintInOut, "Ease.quintInOut");
		addTween(Ease.quintOutIn, "Ease.quintOutIN");

		addTween(Ease.sineIn, "Ease.sineIn");
		addTween(Ease.sineOut, "Ease.sineOut");
		addTween(Ease.sineInOut, "Ease.sineInOut");
		addTween(Ease.sineOutIn, "Ease.sineOutIn");

		addTween(Ease.expoIn, "Ease.expoIn");
		addTween(Ease.expoOut, "Ease.expoOut");
		addTween(Ease.expoInOut, "Ease.expoInOut");
		addTween(Ease.expoOutIn, "Ease.expoOutIn");

		addTween(Ease.circIn, "Ease.circIn");
		addTween(Ease.circOut, "Ease.circOut");
		addTween(Ease.circInOut, "Ease.circInOut");
		addTween(Ease.circOutIn, "Ease.circOutIn");

		addTween(Ease.atanIn, "Ease.atanIn");
		addTween(Ease.atanOut, "Ease.atanOut");
		addTween(Ease.atanInOut, "Ease.atanInOut");
		addTween(Ease.linear, "Ease.linear");

		addTween(Ease.backIn, "Ease.backIn");
		addTween(Ease.backOut, "Ease.backOut");
		addTween(Ease.backInOut, "Ease.backInOut");
		addTween(Ease.backOutIn, "Ease.backOutIn");

		addTween(Ease.bounceIn, "Ease.bounceIn");
		addTween(Ease.bounceOut, "Ease.bounceOut");
		addTween(Ease.bounceInOut, "Ease.bounceInOut");
		addTween(Ease.bounceOutIn, "Ease.bounceOutIn");

		addTween(Ease.elasticIn, "Ease.elasticIn(2, 1)");
		addTween(Ease.elasticOut, "Ease.elasticOut(1, 4)");
		addTween(Ease.elasticInOut, "Ease.elasticInOut(2, 1)");
		addTween(Ease.elasticOutIn, "Ease.elasticOutIn(1, 4)");

		addTween(Ease.hermite.bind(_, 0.2, 0.6, 0.2), "Ease.hermite(_, 0.2, 0.6, 0.2)");
		addTween(Ease.hermite.bind(_, 0.4, 0.2, 0.4), "Ease.hermite(_, 0.4, 0.2, 0.4)");
		addTween(Ease.hermite.bind(_, 0.5, 0.3, 0.2), "Ease.hermite(_, 0.5, 0.3, 0.2)");
		addTween(Ease.hermite.bind(_, 0.2, 0.3, 0.5), "Ease.hermite(_, 0.2, 0.3, 0.5)");

		var i:Int = 0;
		var x:Float = 0;
		var y:Float = 0;
		for (graph in graphs) {
			timeline.tween(graph.graphY => graph.height, 1, 0, graph.ease);
			timeline.tween(graph.graphX => graph.width, 1, 0, Ease.linear);

			i++;
			graph.x = x;
			x += graph.width + ITEM_SPACING;
			graph.y = y;
			if (i % EasingGraphsDemo.TWEENS_PER_ROW == 0) {
				x = 0;
				y += graph.height + ITEM_SPACING;
			}
			graphGroup.add(graph);
			trailArea.add(graph.trailPoint);
		}

		graphGroup.screenCenter();
		add(graphGroup);
		add(trailArea);

		for (graph in graphs) {
			add(graph.point);
		}

		Lib.current.stage.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):Void {
			reversed = !reversed;
		});

		Lib.current.stage.addEventListener(MouseEvent.RIGHT_CLICK, function(e:MouseEvent):Void {
			userControlled = !userControlled;
		});

		Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent):Void {
			rateMultiplier += e.delta > 0 ? 0.1 : -0.1;
		});
	}

	override public function update(dt:Float):Void {
		super.update(dt);

		if (!userControlled) {
			if (timeline.currentTime >= 1) {
				timeline.reset();
				timeline.currentTime = 0;
			} else if (timeline.currentTime <= 0) {
				timeline.reset();
				timeline.currentTime = 1;
			}
			timeline.step(reversed ? -dt * rateMultiplier : dt * rateMultiplier);
		} else {
			timeline.stepTo(Math.min(1, Math.max(0, (FlxG.mouse.x / FlxG.width))));
		}
	}
}