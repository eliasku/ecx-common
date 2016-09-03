import hxmake.test.TestTask;
import hxmake.haxelib.HaxelibExt;
import hxmake.idea.IdeaPlugin;
import hxmake.haxelib.HaxelibPlugin;

using hxmake.haxelib.HaxelibPlugin;

class EcxCommonMake extends hxmake.Module {

	function new() {
		config.classPath = ["src"];
		config.testPath = ["test"];
		config.dependencies = [
			"ecx" => "haxelib"
		];
		config.devDependencies = [
			"utest" => "haxelib"
		];

		apply(HaxelibPlugin);
		apply(IdeaPlugin);

		library(function(ext:HaxelibExt) {
			ext.config.version = "0.1.0";
			ext.config.description = "Essential utilities for ECX";
			ext.config.url = "https://github.com/eliasku/ecx-common";
			ext.config.tags = ["ecx", "update", "time", "systems", "cross", "fps"];
			ext.config.contributors = ["eliasku"];
			ext.config.license = "MIT";
			ext.config.releasenote = "initial";

			ext.pack.includes = ["src", "haxelib.json", "README.md"];
		});
	}
}
