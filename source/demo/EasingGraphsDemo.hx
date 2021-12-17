package demo;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrailArea;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Constraints.Function;
import macrotween.Ease;
import macrotween.Timeline;
import macrotween.Tween;
import openfl.Lib;
import openfl.events.MouseEvent;

using flixel.util.FlxSpriteUtil;

class VibrationParticle extends FlxSprite {
	public function new(height:Float) {
		super();
		makeGraphic(1, Std.int(height), FlxColor.GRAY, false);
	}
	
	public function spawn(x:Float, endX:Float, delay:Float, lifeTime:Float = 1) {
		// TODO convert to timeline when we support this use
		this.x = x;
		this.alpha = 1;
		FlxTween.tween(this, {x: endX, alpha: 0}, lifeTime, {startDelay: delay, ease: Ease.quadOut, onComplete: function(_) {kill();}});
	}
}

class TweenGraph extends FlxSpriteGroup {
	public var description:String;
	public var descriptionLabel(default, set):String;
	
	public var ease(get, set):Float->Float;
	
	// The easing functions, encoded signatures and their arguments
	private var easeArgs:String;
	private var easeArgValues:Array<Float>;
	private var ease1:Float->Float;
	private var ease2:Float->Float->Float;
	private var ease3:Float->Float->Float->Float;
	private var ease4:Float->Float->Float->Float->Float;
	private var ease5:Float->Float->Float->Float->Float->Float;
	private var easeArr:Float->Array<Float>->Float;
	
	public var tween:Tween = null;

	public var box:FlxSprite;
	public var point:FlxSprite;
	public var trailPoint:FlxSprite;
	public var descriptionText:FlxText;
	public var valueText:FlxText;

	public var graphX:Float = 0;
	public var graphY:Float = 0;
	
	public var vibrationParticles:FlxTypedSpriteGroup<VibrationParticle>;

	public function new(description:String, ease:Dynamic, args:String, argValues:Array<Float> = null) {
		super();

		this.description = description;
		this.easeArgs = args;
		this.easeArgValues = argValues;
		this.ease = ease;

		box = new FlxSprite().makeGraphic(Std.int(FlxG.width / EasingGraphsDemo.tweensPerRow - EasingGraphsDemo.itemSpacing * 2), Std.int(FlxG.height / 12 - EasingGraphsDemo.itemSpacing * 2), FlxColor.WHITE);
		box.drawRect(box.x, box.y, box.width, box.height, FlxColor.TRANSPARENT, { thickness: 2, color: FlxColor.BLACK });
		add(box);
		
		vibrationParticles = new FlxTypedSpriteGroup<VibrationParticle>();
		add(vibrationParticles);
		
		point = new FlxSprite();
		point.makeGraphic(6, 6, FlxColor.TRANSPARENT);
		point.drawCircle(3, 3, 3, FlxColor.RED);
		add(point);

		trailPoint = new FlxSprite();
		trailPoint.makeGraphic(2, 2, FlxColor.BLUE);
		add(trailPoint);

		descriptionText = new FlxText(0, 0, 0, "", 8);
		descriptionText.color = FlxColor.GRAY;
		descriptionText.setPosition(width / 2 - descriptionText.width / 2, height / 2 - descriptionText.height / 2);
		descriptionLabel = description;
		add(descriptionText);
		
		valueText = new FlxText(0, 0, 0, "", 8);
		valueText.color = FlxColor.GRAY;
		add(valueText);
	}
	
	public function spawnVibration(right:Bool) {
		var startX:Float;
		var endX:Float;
		var time:Float = 0.4;
		
		if (right) {
			startX = this.x + this.width;
			endX = this.x + this.width * 0.9;
		} else {
			startX = this.x;
			endX = this.x + this.width * 0.1;
		}
		
		for (i in 0...3) {
			var p = vibrationParticles.recycle(null, function():VibrationParticle {return new VibrationParticle(box.height);});
			p.spawn(startX, endX, i * 0.08, time);
			p.y = box.y;
		}
	}
	
	override public function update(dt:Float):Void {
		super.update(dt);
		
		if (FlxG.mouse.wheel != 0 && easeArgValues != null && easeArgValues.length > 0 && FlxG.mouse.overlaps(this)) {
			
			var multiplier:Float = FlxG.mouse.wheel > 0 ? 1.1 : 0.9;
			var additive:Float = FlxG.mouse.wheel > 0 ? 0.01 : -0.01;
			
			var mouseX:Int = FlxG.mouse.x;
			var fractionAcrossGraph = Math.min(1, Math.max(0, (mouseX - box.x) / box.width));
			var whichParameter:Int = Math.floor(fractionAcrossGraph * easeArgValues.length);
			this.easeArgValues[whichParameter] = Std.parseFloat(roundFloat(this.easeArgValues[whichParameter] * multiplier + additive, 2));
			
			descriptionLabel = description; // Update label text
			tween.ease = ease; // Rebind easing function with updated parameters
		}

		point.x = graphX + x - point.width / 2;
		point.y = graphY + y - point.height / 2;
		
		trailPoint.x = graphX + x - trailPoint.width / 2;
		trailPoint.y = graphY + y - trailPoint.height / 2;
		
		valueText.text = roundFloat(1.0 - (graphY / box.height), 2);
		valueText.y = graphY + y - valueText.height / 2;
	}
	
	private function get_ease():Float->Float {
		switch(easeArgs) {
			case "f":
				return ease1;
			case "ff":
				return ease2.bind(_, easeArgValues[0]);
			case "fff":
				return ease3.bind(_, easeArgValues[0], easeArgValues[1]);
			case "ffff":
				return ease4.bind(_, easeArgValues[0], easeArgValues[1], easeArgValues[2]);
			case "fffff":
				return ease5.bind(_, easeArgValues[0], easeArgValues[1], easeArgValues[2], easeArgValues[3]);
			case "fa":
				return easeArr.bind(_, easeArgValues);
			default:
				throw "Failed to resolve easing function";
		}
	}
	
	private function set_ease(ease:Dynamic):Dynamic {
		switch(easeArgs.length) {
			case 1:
				ease1 = ease;
			case 2:
				switch(easeArgs) {
					case "ff":
						ease2 = ease;
					case "fa":
						easeArr = ease;
					default:
						throw "Unhandled easing function type";
				}
			case 3:
				ease3 = ease;
			case 4:
				ease4 = ease;
			case 5:
				ease5 = ease;
			default:
				throw "Bad number of easing arguments";
		}
		return null;
	}
	
	private function set_descriptionLabel(s:String):String {
		this.descriptionText.text = s + (easeArgValues == null ? "" : " " + Std.string(easeArgValues));
		descriptionText.setPosition(x + width / 2 - descriptionText.width / 2, descriptionText.y);
		return descriptionText.text;
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

class EasingGraphsDemo extends FlxSubState {
	public static inline var tweensPerRow:Int = 4;
	public static inline var itemSpacing:Int = 4;

	public var rateMultiplier:Float = 1;

	private var timeline:Timeline;
	private var graphs:Array<TweenGraph>;
	private var graphGroup:FlxSpriteGroup;
	private var trailArea:FlxTrailArea;
	private var userControlled:Bool;
	private var reversed:Bool;

	inline private function addTween<T:Function>(ease:T, description:String, args:String = "f", defaults:Array<Float> = null):Void {
		graphs.push(new TweenGraph(description, ease, args, defaults));
	}
	
	override public function create():Void {
		super.create();

		bgColor = FlxColor.GRAY;

		timeline = new Timeline();
		graphs = new Array<TweenGraph>();
		graphGroup = new FlxSpriteGroup();
		trailArea = new FlxTrailArea(0, 0, FlxG.width, FlxG.height, 0.95, 1);
		userControlled = true;
		reversed = false;

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

		addTween(Ease.atanInAdv, "atanIn", "ff", [ 15 ]);
		addTween(Ease.atanOutAdv, "atanOut", "ff", [ 15 ]);
		addTween(Ease.atanInOutAdv, "atanInOut", "ff", [ 15 ]);
		addTween(Ease.linear, "linear");

		addTween(Ease.backInAdv, "backIn", "ff", [ 1.70158 ]);
		addTween(Ease.backOutAdv, "backOut", "ff", [ 1.70158 ]);
		addTween(Ease.backInOutAdv, "backInOut", "ff", [ 1.70158 ]);
		addTween(Ease.backOutInAdv, "backOutIn", "ff", [ 1.70158 ]);

		addTween(Ease.bounceInAdv, "bounceIn", "ff", [ 1.70158 ]);
		addTween(Ease.bounceOutAdv, "bounceOut", "ff", [ 1.70158 ]);
		addTween(Ease.bounceInOutAdv, "bounceInOut", "ff", [ 1.70158 ]);
		addTween(Ease.bounceOutInAdv, "bounceOutIn", "ff", [ 1.70158 ]);

		addTween(Ease.elasticInAdv, "elasticIn", "fff", [ 1, 0.4 ]);
		addTween(Ease.elasticOutAdv, "elasticOut", "fff", [ 1, 0.4 ]);
		addTween(Ease.elasticInOutAdv, "elasticInOut", "fff", [ 1, 0.4 ]);
		addTween(Ease.elasticOutInAdv, "elasticOutIn", "fff", [ 1, 0.4 ]);

		addTween(Ease.hermite, "hermite", "ffff", [ 0.2, 0.6, 0.2 ]);
		addTween(Ease.hermite, "hermite", "ffff", [ 0.4, 0.2, 0.4 ]);
		addTween(Ease.hermite, "hermite", "ffff", [ 0.5, 0.3, 0.2 ]);
		addTween(Ease.hermite, "hermite", "ffff", [ 0.2, 0.3, 0.5 ]);

		addTween(Ease.piecewiseLinear, "piecewise", "fa", [ 0.0, 0.9, 0.0, 0.9, 0.0 ]);
		addTween(Ease.piecewiseLinear, "piecewise", "fa", [ 0.9, 0.1, 0.9, 0.1, 0.9 ]);
		addTween(Ease.piecewiseLinear, "piecewise", "fa", [ 0.5, 0.2, 0.8, 0.2, 0.5 ]);
		addTween(Ease.piecewiseLinear, "piecewise", "fa", [ 0, 1, 0, 1 ]);
		
		var i:Int = 0;
		var x:Float = 0;
		var y:Float = 0;
		for (graph in graphs) {
			var yTween = Tween.tween(graph.graphY => graph.height...0, 1, 0, graph.ease);
			timeline.add(yTween);
			
			var xTween = Tween.tween(graph.graphX => 0...graph.width, 1, 0, Ease.linear);
			xTween.onEndSignal.add(function(rev) {graph.spawnVibration(true);});
			xTween.onStartSignal.add(function(rev) {graph.spawnVibration(false);});
			timeline.add(xTween);
			
			graph.tween = yTween;
			
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
		//Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL, function(e:MouseEvent):Void {
		//	rateMultiplier += e.delta > 0 ? 0.1 : -0.1;
		//});
	}

	override public function update(dt:Float):Void {
		super.update(dt);
		
		if (userControlled) {
			timeline.stepTo(Math.min(1, Math.max(0, (FlxG.mouse.x * 4 / FlxG.width) % 1)));
		} else {
			if (!timeline.isCurrentTimeInBounds()) {
				timeline.currentTime = timeline.currentTime > 0.5 ? 0 : 1;
			}
			timeline.step(reversed ? -dt * rateMultiplier : dt * rateMultiplier, true);
		}
	}
}