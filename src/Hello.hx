import js.html.*;
import enthral.HaxeComponent;
import js.jquery.JQuery;

/**
	Haxe JS Enthraler Component.

	We define `Hello` as the class to export in build.hxml.
	Enthraler components need an AMD definition, and if you implement the `HaxeComponent` class, it will generate an AMD definition for you.

	It will also take care of loading dependencies if you add `@:enthralDependency('amdPath', HaxeExtern)`.
	Note: the macro will overwrite the `@:native` metadata on any externs to a custom global variable, and set that variable during the define function.
**/
@:enthralerDependency('jquery', JQuery)
class Hello implements HaxeComponent<HelloProps> {
	var container:JQuery;

	public function new(config) {
		this.container = new JQuery(config.container);
	}

	public function render(props:HelloProps) {
		container.text('Hello ${props.name}, I am rendered using Haxe!');
	}
}

typedef HelloProps = {
	name:String
};
