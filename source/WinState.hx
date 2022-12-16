package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

class WinState extends FlxState
{
	var time:String;
	var guessCount:Int;

	public function new(timer:String, guesses:Int)
	{
		super();

		time = timer;
		guessCount = guesses;
	}

	override public function create()
	{
		super.create();

		var text:FlxText = new FlxText(0, 0, 500,
			"Congratulations! You just wasted "
			+ time
			+ " of your life guessing fucking twitter @s "
			+ guessCount
			+ " times!", 30);
		text.alignment = CENTER;
		text.screenCenter();
		trace(text.y);
		text.y = 0 - text.textField.height - 50;
		add(text);

		FlxTween.tween(text, {y: 162}, 7);

		FlxG.sound.playMusic(AssetPaths.getSoundFile("assets/music/win"), 1, false);

		trace(time);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
