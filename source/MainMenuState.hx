package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.ui.FlxButton;

class MainMenuState extends FlxState
{
	override public function create()
	{
		super.create();

		FlxG.autoPause = false;

		var music = FlxG.sound.load("assets/music/BGM.ogg", 1, true);
		music.looped = true;
		music.loopTime = 6660;
		music.persist = true;
		music.play();

		var startButton:FlxButton = new FlxButton(0, 0, "Start", onClick);
		startButton.screenCenter(XY);
		add(startButton);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function onClick()
	{
		FlxG.switchState(new PlayState());
	}
}
