package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIButton;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class MainMenuState extends FlxState
{
	var elapsedTime:Float;

	var icon:FlxSprite;

	override public function create()
	{
		super.create();

		FlxG.autoPause = false;

		var text = new FlxText(0, 50, 0, "DNB Blocklist Guesser", 25);
		text.screenCenter(X);
		text.y = -500;
		add(text);

		var music = FlxG.sound.load(AssetPaths.getSoundFile("assets/music/BGM"), 1, true);
		music.looped = true;
		music.loopTime = 6660;
		music.persist = true;
		music.play();

		icon = new FlxSprite().loadGraphic("assets/images/icon.png");
		icon.screenCenter();
		icon.setGraphicSize(Std.int(icon.width * 0.3));
		icon.angle = 25;
		icon.x = 500;
		icon.antialiasing = true;
		add(icon);
		FlxTween.tween(icon, {angle: -25}, 2, {type: PINGPONG, ease: FlxEase.quadInOut});

		var startButton:FlxUIButton = new FlxUIButton(0, 0, "Play", onClick);
		startButton.setGraphicSize(Std.int(startButton.width * 2));
		startButton.updateHitbox();
		startButton.label.fieldWidth *= 2;
		startButton.label.size *= 2;
		startButton.screenCenter();
		startButton.y = 500;
		add(startButton);

		FlxTween.tween(text, {y: 48}, 4, {
			ease: FlxEase.elasticOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(text, {y: 52}, 1.5, {type: PINGPONG, ease: FlxEase.quadInOut});
			}
		});
		FlxTween.tween(icon, {x: -180}, 4, {ease: FlxEase.elasticOut});
		FlxTween.tween(startButton, {y: 402}, 4, {
			ease: FlxEase.elasticOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(startButton, {y: 398}, 1.5, {type: PINGPONG, ease: FlxEase.quadInOut});
			}
		});
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
