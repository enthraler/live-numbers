import enthraler.HaxeTemplate;
import enthraler.Environment;
import js.jquery.JQuery;
import motion.Actuate;
import haxe.Timer;
import js.Browser.document;
using StringTools;
using thx.Dates;

/**
	Haxe JS Enthraler Component.

	We define `Hello` as the class to export in build.hxml.
	Enthraler components need an AMD definition, and if you implement the `HaxeTemplate` class, it will generate an AMD definition for you.

	It will also take care of loading dependencies if you add `@:enthralDependency('amdPath', HaxeExtern)`.
	Note: the macro will overwrite the `@:native` metadata on any externs to a custom global variable, and set that variable during the define function.
**/
@:enthralerDependency('jquery', JQuery)
@:enthralerDependency('css!live-numbers')
class LiveNumbers implements HaxeTemplate<LiveNumberProps> {
	var container:JQuery;
	var environment:Environment;
	var props:LiveNumberProps;
	var timeAtOpen:Float;
	var timer:Timer;
	var targetNumber = null;

	public function new(environment:Environment) {
		this.container = new JQuery(environment.container);
		this.environment = environment;
		this.timeAtOpen = Date.now().getTime();
		this.timer = new Timer(100);
		timer.run = function () {
			var oldNumber = targetNumber;
			targetNumber = getTargetNumber();
			if (oldNumber != targetNumber) {
				if (oldNumber == null) {
					oldNumber = 0;
				}
				var tween = Actuate.update(renderText, 1, [oldNumber], [targetNumber]);
				tween.ease(motion.easing.Linear.easeNone);
			}
			// Resize the iframe, but not too often.
			environment.requestHeightChange();
		}
	}

	public function render(props:LiveNumberProps) {
		this.props = props;
		if (props.bgColor != null) {
			document.body.style.backgroundColor = props.bgColor;
		}
		if (props.textColor != null) {
			document.body.style.color = props.textColor;
		}
	}

	function getTargetNumber():Int {
		if (this.props == null) {
			return 0;
		}
		var startTime = switch this.props.since {
			case Open: timeAtOpen;
			case Midnight: Date.now().snapPrev(Day).getTime();
			case Sunday: Date.now().snapPrevWeekDay(Sunday).snapPrev(Day).getTime();
			case Monday: Date.now().snapPrevWeekDay(Monday).snapPrev(Day).getTime();
			case StartOfMonth: Date.now().snapPrev(Month).getTime();
			case StartOfYear: Date.now().snapPrev(Year).getTime();
		};
		var now = Date.now().getTime();
		var timeElapsed = now - startTime;
		var frequencyInSeconds = switch this.props.every {
			case Second: 1;
			case Minute: 60;
			case Hour: 3600;
			case Day: 86400;
			case Week: 86400*7;
			case Month: 86400*30.43;
			case Year: 86400*365.25;
		}
		var amountPerSecond = this.props.amount / frequencyInSeconds;
		return Math.round((timeElapsed / 1000) * amountPerSecond);
	}

	function renderText(number:Float) {
		var number = Math.round(number);
		var html = this.props.template.replace('{{NUMBER}}', '<span class="number">$number</span>');
		container.html(html);
	}
}

typedef LiveNumberProps = {
	amount:Int,
	every:Frequency,
	since:TimePeriod,
	template:String,
	?bgColor:String,
	?textColor:String
};

@:enum abstract Frequency(String) {
	var Second = "second";
	var Minute = "minute";
	var Hour = "hour";
	var Day = "day";
	var Week = "week";
	var Month = "month";
	var Year = "year";
}

@:enum abstract TimePeriod(String) {
	var Open = "open";
	var Midnight = "midnight";
	var Sunday = "sunday";
	var Monday = "monday";
	var StartOfMonth = "start_of_month";
	var StartOfYear = "start_of_year";
}
