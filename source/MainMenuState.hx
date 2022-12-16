package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.ui.FlxUIButton;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class MainMenuState extends FlxState
{
	var elapsedTime:Float;

	var icon:FlxSprite;
	var github:FlxSprite;

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

		github = new FlxSprite().loadGraphic("assets/images/github.png");
		github.setGraphicSize(Std.int(icon.width * 0.05));
		github.updateHitbox();
		github.antialiasing = true;
		github.y -= 100;
		github.x = 5;
		add(github);

		FlxTween.tween(text, {y: 48}, 4, {
			ease: FlxEase.elasticOut,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.tween(text, {y: 52}, 1.5, {type: PINGPONG, ease: FlxEase.quadInOut});
			}
		});
		FlxTween.tween(icon, {x: -180}, 4, {ease: FlxEase.elasticOut});
		FlxTween.tween(github, {y: 5}, 4, {ease: FlxEase.elasticOut});
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

		if (FlxG.mouse.overlaps(github))
		{
			github.color = FlxColor.WHITE;
			github.scale.x = (FlxMath.lerp(github.scale.x, 0.12, 0.1));
			github.scale.y = (FlxMath.lerp(github.scale.y, 0.12, 0.1));

			if (FlxG.mouse.justPressed)
				FlxG.openURL("https://github.com/FoxelTheFennic/DNBBlocklistGuessing");
		}
		else
		{
			github.color = FlxColor.GRAY;
			github.scale.x = (FlxMath.lerp(github.scale.x, 0.098, 0.1));
			github.scale.y = (FlxMath.lerp(github.scale.y, 0.098, 0.1));
		}
	}

	function onClick()
	{
		FlxG.switchState(new PlayState());
	}
}
