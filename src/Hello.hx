import js.html.*;

/**
	Haxe JS Enthral Component.

	Haxe's default JS output is compatible with Common JS, and will be loaded by Enthral as a Common JS file.

	See https://github.com/systemjs/systemjs/blob/master/docs/module-formats.md#amd

	You can use the `js.Lib.require()` function to import a dependency using SystemJS.
	You can also add `@:jsRequire` to an extern to import a dependency using SystemJS.

	We define `Hello` as the class to export in build.hxml.
**/
// TODO: create a macro that generates an enthralPropTypes value based on HelloProps.
@:expose
class Hello {
	var props:HelloProps;

	public function new(authorData:HelloProps) {
		this.props = authorData;
	}

	public function setupView(container:Element) {
		container.innerHTML = 'Hello ${props.name}, I am rendered using Haxe!';
	}
}

typedef HelloProps = {
	name:String
};
