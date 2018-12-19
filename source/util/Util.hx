package util;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

/**
 * A mapping of basic Haxe types to single character ids.
 * This is used for converting basic Haxe parameter types to a shorthand string, a little like a JNI function signature.
 */
@:enum abstract TypeMapping(String) from (String) {
    var FLOAT = "f";
    var ARRAY = "a";
}

class Util
{
	/**
	 * Macro that returns a string representing the given function's type signature.
	 * Only works for types or abstracts extending the types in the TypeMapping enum. Throws a compile time error for unsupported types.
	 * @param	f	The function to extract function parameter types from.
	 * @return	A string, where each character represents the type of the nth function parameter.
	 */
	public macro static function getFunctionSignature(f:ExprOf<Function>):ExprOf<String> {
		var type:haxe.macro.Type = Context.typeof(f);
		
		var params:Array<Dynamic> = type.getParameters();
		
		var args:Dynamic = params[0];
		
		var signature:String = "";
		
		var len:Int = args.length;
		
		for (i in 0...len) {
			var arg:Dynamic = args[i];
			var name = arg.name;
			var argType = arg.t;
			
			if (name == null || argType == null) {
				throw "Arg name or type shouldn't be null...";
			}
			
			switch(argType) {
				case TAbstract(underlying, params):
					var underlyingTypeName = Std.string(underlying);
					switch(underlyingTypeName) {
						case "Float":
							signature += TypeMapping.FLOAT;
						case _:
							throw "Unhandled abstract function parameter type: " + underlyingTypeName;
					}
				case TInst(t, params):
					var stringifedTypeName = Std.string(t);
					switch(stringifedTypeName) {
						case "Array":
							signature += TypeMapping.ARRAY;
						case _:
							throw "Unhandled class instance type: " + stringifedTypeName;
					}
				default:
					throw "Unhandled function parameter type: " + arg;
			}
		}
		
		return macro $v{signature};
	}
}