import enthraler.HaxeTemplate;
import enthraler.Environment;
import js.jquery.JQuery;

/**
	Haxe JS Enthraler Component.

	We define `Hello` as the class to export in build.hxml.
	Enthraler components need an AMD definition, and if you implement the `HaxeTemplate` class, it will generate an AMD definition for you.

	It will also take care of loading dependencies if you add `@:enthralDependency('amdPath', HaxeExtern)`.
	Note: the macro will overwrite the `@:native` metadata on any externs to a custom global variable, and set that variable during the define function.
**/
@:enthralerDependency('jquery', JQuery)
@:enthralerDependency('css!hello')
class Hello implements HaxeTemplate<HelloProps> {
	var header:JQuery;
	var environment:Environment;

	public function new(environment:Environment) {
		this.header = new JQuery('<h1>').appendTo(environment.container);
		this.environment = environment;
	}

	public function render(props:HelloProps) {
		header.text('Hello ${props.name}, I am rendered using Haxe!');
		environment.requestHeightChange();
	}
}

typedef HelloProps = {
	name:String
};
