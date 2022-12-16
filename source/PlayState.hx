package;

import flixel.FlxState;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	var names:Array<String>;

	var completionAmount:FlxText = new FlxText(0, 0, 0, "0/?", 50);

	override public function create()
	{
		super.create();

		var content:String = sys.io.File.getContent('assets/data/blocklist.txt');
		names = content.split("\n");

		completionAmount.text = "0/" + names.length;
		completionAmount.screenCenter();

		add(completionAmount);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
