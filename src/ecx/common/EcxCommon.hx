package ecx.common;

import ecx.common.components.Fsm;
import ecx.common.components.Name;
import ecx.common.systems.FpsMeter;
import ecx.common.systems.FsmSystem;
import ecx.common.systems.SystemRunner;
import ecx.common.systems.TimeSystem;

class EcxCommon extends WorldConfig {

	public function new() {
		super();

		// services
		add(new SystemRunner());

		// systems
		add(new TimeSystem(), -1000);
		add(new FpsMeter(), -999);
		add(new FsmSystem(), 1000);

		// components
		add(new Name());
		add(new Fsm());
	}
}
