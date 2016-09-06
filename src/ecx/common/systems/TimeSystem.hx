package ecx.common.systems;

@:final
class TimeSystem extends System {

	public var deltaTime(default, null):Float = 0;
	public var totalTime(default, null):Float = 0;
	public var currentFrame(default, null):Int = 0;

	var _lastTime:Float;
	var _startTime:Float;

	public function new() {}

	override function initialize() {
		_lastTime = _startTime = now();
	}

	override function update() {
		var time = now();

		deltaTime = time - _lastTime;
		totalTime = time - _startTime;
		++currentFrame;

		_lastTime = time;
	}

	inline function now() {
		return haxe.Timer.stamp();
	}
}
