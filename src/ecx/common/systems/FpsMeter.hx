package ecx.common.systems;

class FpsMeter extends System {

	public var framesPerSecond(default, null):Float = 0;
	public var frameTimeAverage(default, null):Float = 0;
	public var inverval:Float = 0.25;

	var _time:Wire<TimeSystem>;

	var _frames:Int = 0;
	var _lastTime:Float = 0;
	var _accDeltaTime:Float = 0;

	public function new() {}

	override function update() {
		++_frames;
		_accDeltaTime += _time.deltaTime;
		var now = _time.totalTime;
		if(now - _lastTime >= inverval) {
			framesPerSecond = _frames / inverval;
			frameTimeAverage = _accDeltaTime / _frames;
			_lastTime = now;
			_frames = 0;
			_accDeltaTime = 0;
		}
	}
}