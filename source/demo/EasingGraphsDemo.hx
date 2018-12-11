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
	public var valueText:FlxText;

	public var graphX:Float = 0;
	public var graphY:Float = 0;

	public function new(description:String, ease:Float->Float) {
		super();

		this.description = description;
		this.ease = ease;

		box = new FlxSprite().makeGraphic(Std.int(FlxG.width / EasingGraphsDemo.tweensPerRow - EasingGraphsDemo.itemSpacing * 2), Std.int(FlxG.height / 12 - EasingGraphsDemo.itemSpacing * 2), FlxColor.WHITE);
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
		
		valueText = new FlxText(0, 0, 0, "", 8);
		valueText.color = FlxColor.GRAY;
		add(valueText);
	}

	override public function update(dt:Float):Void {
		super.update(dt);

		point.x = graphX + x - point.width / 2;
		point.y = graphY + y - point.height / 2;
		
		trailPoint.x = graphX + x - trailPoint.width / 2;
		trailPoint.y = graphY + y - trailPoint.height / 2;
		
		valueText.text = roundFloat(1.0 - (graphY / box.height), 2);
		valueText.y = graphY + y - valueText.height / 2;
	}
	
	private static function roundFloat(n:Float, prec:Int):String {
		n = Math.round(n * Math.pow(10, prec));
		var str:String = '' + n;
		var len:Int = str.length;
		if(len <= prec) {
			while(len < prec) {
				str = '0' + str;
				len++;
			}
			return '0.' + str;
		} else {
			return str.substr(0, str.length - prec) + '.' + str.substr(str.length - prec);
		}
	}
}

class EasingGraphsDemo extends LycanState {
	public static inline var tweensPerRow:Int = 4;
	public static inline var itemSpacing:Int = 4;

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

		addTween(Ease.quadIn, "quadIn");
		addTween(Ease.quadOut, "quadOut");
		addTween(Ease.quadInOut, "quadInOut");
		addTween(Ease.quadOutIn, "quadOutIn");

		addTween(Ease.cubicIn, "cubicIn");
		addTween(Ease.cubicOut, "cubicOut");
		addTween(Ease.cubicInOut, "cubicInOut");
		addTween(Ease.cubicOutIn, "cubicOutIn");

		addTween(Ease.quartIn, "quartIn");
		addTween(Ease.quartOut, "quartOut");
		addTween(Ease.quartInOut, "quartInOut");
		addTween(Ease.quartOutIn, "quartOutIn");

		addTween(Ease.quintIn, "quintIn");
		addTween(Ease.quintOut, "quintOut");
		addTween(Ease.quintInOut, "quintInOut");
		addTween(Ease.quintOutIn, "quintOutIn");

		addTween(Ease.sineIn, "sineIn");
		addTween(Ease.sineOut, "sineOut");
		addTween(Ease.sineInOut, "sineInOut");
		addTween(Ease.sineOutIn, "sineOutIn");

		addTween(Ease.expoIn, "expoIn");
		addTween(Ease.expoOut, "expoOut");
		addTween(Ease.expoInOut, "expoInOut");
		addTween(Ease.expoOutIn, "expoOutIn");

		addTween(Ease.circIn, "circIn");
		addTween(Ease.circOut, "circOut");
		addTween(Ease.circInOut, "circInOut");
		addTween(Ease.circOutIn, "circOutIn");

		addTween(Ease.atanIn, "atanIn");
		addTween(Ease.atanOut, "atanOut");
		addTween(Ease.atanInOut, "atanInOut");
		addTween(Ease.linear, "linear");

		addTween(Ease.backIn, "backIn");
		addTween(Ease.backOut, "backOut");
		addTween(Ease.backInOut, "backInOut");
		addTween(Ease.backOutIn, "backOutIn");

		addTween(Ease.bounceIn, "bounceIn");
		addTween(Ease.bounceOut, "bounceOut");
		addTween(Ease.bounceInOut, "bounceInOut");
		addTween(Ease.bounceOutIn, "bounceOutIn");

		addTween(Ease.elasticIn, "elasticIn(1, 0.4)");
		addTween(Ease.elasticOut, "elasticOut(1, 0.4)");
		addTween(Ease.elasticInOut, "elasticInOut(1, 0.4)");
		addTween(Ease.elasticOutIn, "elasticOutIn(1, 0.4)");

		addTween(Ease.hermite.bind(_, 0.2, 0.6, 0.2), "hermite(_, 0.2, 0.6, 0.2)");
		addTween(Ease.hermite.bind(_, 0.4, 0.2, 0.4), "hermite(_, 0.4, 0.2, 0.4)");
		addTween(Ease.hermite.bind(_, 0.5, 0.3, 0.2), "hermite(_, 0.5, 0.3, 0.2)");
		addTween(Ease.hermite.bind(_, 0.2, 0.3, 0.5), "hermite(_, 0.2, 0.3, 0.5)");
		
		addTween(Ease.piecewiseLinear.bind(_, [ 0.0, 0.9, 0.0, 0.9, 0.0 ]), "piecewise(0.0, 0.9, 0.0, 0.9, 0.0)");
		addTween(Ease.piecewiseLinear.bind(_, [ 0.9, 0.1, 0.9, 0.1, 0.9 ]), "piecewise(0.9, 0.1, 0.9, 0.1, 0.9)");
		addTween(Ease.piecewiseLinear.bind(_, [ 0.5, 0.2, 0.8, 0.2, 0.5 ]), "piecewise(0.5, 0.2, 0.8, 0.2, 0.5)");
		addTween(Ease.piecewiseLinear.bind(_, [ 0.1, 0.5, 0.6, 0.5, 0.1 ]), "piecewise(0.1, 0.5, 0.6, 0.5, 0.1)");

		var i:Int = 0;
		var x:Float = 0;
		var y:Float = 0;
		for (graph in graphs) {
			timeline.tween(graph.graphY => graph.height...0, 1, 0, graph.ease);
			timeline.tween(graph.graphX => graph.width, 1, 0, Ease.linear);

			i++;
			graph.x = x;
			x += graph.width + itemSpacing;
			graph.y = y;
			if (i % EasingGraphsDemo.tweensPerRow == 0) {
				x = 0;
				y += graph.height + itemSpacing;
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
		
		if (userControlled) {
			timeline.stepTo(Math.min(1, Math.max(0, (FlxG.mouse.x / FlxG.width))));
		} else {
			if (!timeline.isCurrentTimeInBounds()) {
				timeline.currentTime = timeline.currentTime > 0.5 ? 0 : 1;
			}
			timeline.step(reversed ? -dt * rateMultiplier : dt * rateMultiplier);
		}
	}
}