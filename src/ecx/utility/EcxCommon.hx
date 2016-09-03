package ecx.utility;

import ecx.utility.components.Name;
import ecx.utility.systems.FpsMeter;
import ecx.utility.systems.TimeSystem;
import ecx.utility.systems.SystemRunner;

class EcxCommon extends WorldConfig {

	public function new() {
		super();

		// services
		add(new SystemRunner());

		// systems
		add(new TimeSystem(), -1000);
		add(new FpsMeter(), -999);

		// components
		add(new Name());
	}
}
