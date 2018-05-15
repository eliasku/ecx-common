package ecx.common.components;

import ecx.AutoComp;
import ecx.Entity;
import ecx.World;

typedef FsmCallback = World -> Entity -> Void;

class Fsm extends AutoComp<FsmData> {}

class FsmData {

	public var state(default, null):String;

	var _next:String;
	var _enter:Map<String, FsmCallback> = new Map();
	var _exit:Map<String, FsmCallback> = new Map();

	public function new() {}

	public function addState(name:String, enter:FsmCallback, exit:FsmCallback) {
		_enter.set(name, enter);
		_exit.set(name, exit);
	}

	public function setState(name:String) {
		_next = name;
	}
}
