import enthraler.HaxeEnthralerTemplate;
import enthraler.EnthralerEnvironment;
import js.jquery.JQuery;

/**
	Haxe JS Enthraler Component.

	We define `Hello` as the class to export in build.hxml.
	Enthraler components need an AMD definition, and if you implement the `HaxeComponent` class, it will generate an AMD definition for you.

	It will also take care of loading dependencies if you add `@:enthralDependency('amdPath', HaxeExtern)`.
	Note: the macro will overwrite the `@:native` metadata on any externs to a custom global variable, and set that variable during the define function.
**/
@:enthralerDependency('jquery', JQuery)
@:enthralerDependency('css!hello')
class Hello implements HaxeEnthralerTemplate<HelloProps> {
	var header:JQuery;
	var environment:EnthralerEnvironment;

	public function new(config) {
		this.header = new JQuery('<h1>').appendTo(config.container);
		this.environment = config.environment;
	}

	public function render(props:HelloProps) {
		header.text('Hello ${props.name}, I am rendered using Haxe!');
		environment.requestHeightChange();
	}
}

typedef HelloProps = {
	name:String
};
