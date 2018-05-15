package ecx.common.systems;

import ecx.ds.CArray;
import haxe.Timer;

@:final
class SystemRunner extends Service {

	var _profiler:SystemProfiler = new SystemProfiler();
	var _systems:CArray<System>;

	/**
		Update update profiling information
		Note: You could toggle profiling in run-time
	**/
	public var profile:Bool;

	public var profileData(get, never):Array<ProfileInfo>;
	public var profileTotal(get, never):Float;

	public function new(profile:Bool = false) {
		this.profile = profile;
	}

	/**
		Call this method every frame to make world alive
	**/
	public function updateFrame() {
		if(profile) {
			updateAndProfileSystems();
			return;
		}

		// just in case invalidate after system events callbacks
		world.invalidate();
		for(system in world.systems()) {
			@:privateAccess system.update();
			world.invalidate();
		}
	}

	override function initialize() {
		for(system in world.systems()) {
			_profiler.add(system);
		}
	}

	function updateAndProfileSystems() {
		_profiler.prepare();

		// TODO: include zero-invalidation in profiling data
		world.invalidate();

		for(system in world.systems()) {
			_profiler.start();

			@:privateAccess system.update();

			_profiler.trackUpdate();

			_profiler.trackEntities(world);
			world.invalidate();

			_profiler.trackInvalidate();
		}
		_profiler.finish();
	}

	inline function get_profileData() {
		return _profiler.data;
	}

	inline function get_profileTotal() {
		return _profiler.total;
	}
}

private class SystemProfiler {

	public var data(default, null):Array<ProfileInfo> = [];
	public var total(get, never):Float;
	public var updateTotal(default, null):Float = 0;
	public var invalidateTotal(default, null):Float = 0;

	var _updateTimes:Array<Float> = [];
	var _invalidateTimes:Array<Float> = [];
	var _timesCounter:Int = 0;

	var _index:Int = 0;
	var _startTime:Float = 0;
	var _period:Int = 20;

	public function new() {}

	public function add(system:System) {
		var tp = Type.getClassName(Type.getClass(system)).split(".");
		data.push(new ProfileInfo(tp[tp.length - 1]));
		_updateTimes.push(0);
		_invalidateTimes.push(0);
	}

	public function prepare() {
		_index = 0;
	}

	public function finish() {
		++_timesCounter;
		if(_timesCounter >= _period) {
			var updateTimeTotal = 0.0;
			var invalidateTimeTotal = 0.0;
			for(i in 0...data.length) {
				updateTimeTotal += _updateTimes[i];
				invalidateTimeTotal += _invalidateTimes[i];

				data[i].updateTime = _updateTimes[i] / _timesCounter;
				if(data[i].updateTime > data[i].updateTimeMax) {
					data[i].updateTimeMax = data[i].updateTime;
				}
				data[i].invalidateTime = _invalidateTimes[i] / _timesCounter;
				if(data[i].invalidateTime > data[i].invalidateTimeMax) {
					data[i].invalidateTimeMax = data[i].invalidateTime;
				}

				_updateTimes[i] = 0;
				_invalidateTimes[i] = 0;
			}
			updateTotal = updateTimeTotal / _timesCounter;
			invalidateTotal = invalidateTimeTotal / _timesCounter;
			_timesCounter = 0;
		}
	}

	public function start() {
		_startTime = now();
	}

	public function trackUpdate() {
		var time = now();
		_updateTimes[_index] += time - _startTime;
		_startTime = time;
	}

	public function trackInvalidate() {
		var time = now();
		_invalidateTimes[_index] += time - _startTime;
		_startTime = time;
		++_index;
	}

	@:access(ecx.World)
	public function trackEntities(world:World) {
		var changed = world._changedVector.length;
		var removed = world._removedVector.length;
		if(changed > data[_index].changed) {
			data[_index].changed = changed;
		}
		if(removed > data[_index].removed) {
			data[_index].removed = removed;
		}
	}

	function get_total():Float {
		return invalidateTotal + updateTotal;
	}

	inline function now():Float {
		return Timer.stamp();
	}
}

class ProfileInfo {

	public var name:String;
	public var updateTime:Float = 0;
	public var updateTimeMax:Float = 0;
	public var invalidateTime:Float = 0;
	public var invalidateTimeMax:Float = 0;

	public var changed:Int = 0;
	public var removed:Int = 0;

	public function new(name:String) {
		this.name = name;
	}
}