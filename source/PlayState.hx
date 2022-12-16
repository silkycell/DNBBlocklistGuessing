package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Timer;

class PlayState extends FlxState
{
	var guessedNames:Array<String> = [];
	var names:Array<String>;

	var guesses:Int = 0;
	var guessesText:FlxText = new FlxText(0, 0, 0, "0", 60);
	var guessesDescText:FlxText = new FlxText(0, 0, 0, "Guesses", 25);

	var seconds:Int = 0;
	var timerText:FlxText = new FlxText(0, 0, 0, "0:00", 60);
	var timerDescText:FlxText = new FlxText(0, 0, 0, "Timer", 25);

	var inputGroup:FlxSpriteGroup = new FlxSpriteGroup();
	var guessGroup:FlxSpriteGroup = new FlxSpriteGroup();
	var timerGroup:FlxSpriteGroup = new FlxSpriteGroup();

	var canInputTwn:Bool = true;

	var input:FlxInputText = new FlxInputText(0, 0, 150, "", 8);
	#if web
	var inputHide:FlxInputText = new FlxInputText(0, 0, 150, "", 8);
	#end

	var submitButton:FlxButton;

	var completionAmount:FlxText = new FlxText(0, 0, 0, "0/?", 70);
	var at:FlxText = new FlxText(0, 0, 0, "@", 25);

	var baldiTimer = new FlxTimer();
	var baldiTimerStarted:Bool = false;
	var baldiCount:Int;

	override public function create()
	{
		super.create();

		names = BlockList.blockList.split(",");

		completionAmount.text = guessedNames.length + "/" + names.length;
		completionAmount.screenCenter();
		completionAmount.antialiasing = true;
		add(completionAmount);

		guessesText.text = Std.string(guesses);
		guessesText.screenCenter();
		guessesText.antialiasing = true;
		guessGroup.add(guessesText);

		guessesDescText.screenCenter();
		guessesDescText.y -= 50;
		guessGroup.add(guessesDescText);

		timerText.screenCenter();
		timerText.antialiasing = true;
		timerGroup.add(timerText);

		timerDescText.screenCenter();
		timerDescText.y -= 50;
		timerGroup.add(timerDescText);

		guessGroup.x = -250;
		timerGroup.x = 240;

		add(guessGroup);
		add(timerGroup);

		var timer = new Timer(1000);
		timer.run = function()
		{
			seconds++;
			timerText.text = FlxStringUtil.formatTime(seconds);

			timerGroup.x = 0;
			timerDescText.screenCenter();
			timerDescText.y -= 50;
			timerText.screenCenter();
			timerGroup.x = 240;
		}

		input.screenCenter();
		input.y += 150;
		input.updateHitbox();
		input.callback = onInputTextChanged;
		input.maxLength = 16;
		inputGroup.add(input);

		submitButton = new FlxButton(0, 0, "Submit", submit);
		submitButton.screenCenter();
		submitButton.y += 180;
		submitButton.x -= 5;
		add(submitButton);

		#if web
		inputHide.screenCenter();
		inputHide.y += 150;
		inputHide.updateHitbox();
		inputGroup.add(inputHide);
		#end

		at.x = input.x - input.scale.x - 25;
		at.screenCenter(Y);
		at.y += 150;
		inputGroup.add(at);

		add(inputGroup);

		input.focusGained = function():Void
		{
			FlxG.sound.muteKeys = null;
			FlxG.sound.volumeUpKeys = null;
			FlxG.sound.volumeDownKeys = null;
		}

		input.focusLost = function():Void
		{
			FlxG.sound.muteKeys = [FlxKey.ZERO];
			FlxG.sound.volumeUpKeys = [FlxKey.PLUS];
			FlxG.sound.volumeDownKeys = [FlxKey.MINUS];
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if web
		if (input.text == "")
		{
			input.visible = false;
			inputHide.visible = true;
			if (input.hasFocus)
				inputHide.hasFocus = true;
		}
		else
		{
			input.visible = true;
			inputHide.visible = false;
			inputHide.hasFocus = false;
		}
		inputHide.text = "";
		#end // thanks, haxe!

		inputGroup.y = FlxMath.lerp(inputGroup.y, 0, 0.1);

		if (FlxG.keys.justPressed.ENTER)
		{
			submit();
		}
	}

	function onInputTextChanged(_, type:String)
	{
		FlxG.sound.play(AssetPaths.getSoundFile("assets/sounds/click"), 0.5);

		if (type == "input")
			inputGroup.y = 2;
		else
			inputGroup.y = -2;
	}

	function submit()
	{
		if (input.text != "")
		{
			guessName(input.text);
			input.text = "";
			input.hasFocus = false;
			input.hasFocus = true;
		}
		else
		{
			notif("empty");
		}
	}

	function guessName(input:String)
	{
		var foundName = false;
		var alreadyGuessed = false;

		for (v in names)
		{
			if (v.toLowerCase() == input.toLowerCase())
			{
				foundName = true;
				break;
			}
		}

		for (v in guessedNames)
		{
			if (v.toLowerCase() == input.toLowerCase())
			{
				alreadyGuessed = true;
				break;
			}
		}

		if (foundName && !alreadyGuessed)
		{
			if (input == "evilpassing")
				FlxG.sound.play(AssetPaths.getSoundFile("assets/sounds/la cucaracha horn"));
			notif("found");
			guessedNames.push(input);
		}
		else if (alreadyGuessed)
		{
			notif("alreadyGuessed");
		}
		else
		{
			notif("notInNames");
		}

		completionAmount.text = guessedNames.length + "/" + names.length;
		completionAmount.screenCenter();

		guessesText.text = Std.string(guesses);
		guessGroup.x = 0;
		guessesDescText.screenCenter();
		guessesDescText.y -= 50;
		guessesText.screenCenter();
		guessGroup.x = -250;

		if (guessedNames.length == names.length)
		{
			MainMenuState.music.stop();
			FlxG.switchState(new WinState(FlxStringUtil.formatTime(seconds), guesses));
		}
	}

	function notif(type:String)
	{
		var notifText:FlxText = new FlxText(0, 0, 0, "You shouldn't be able to read this.", 15);

		if (type == "found")
		{
			baldiCount += 1;

			if (baldiTimerStarted == false)
			{
				baldiTimerStarted = true;
				baldiTimer = new FlxTimer().start(6.5, function(timer:FlxTimer)
				{
					baldiCount = 0;
					baldiTimerStarted = false;
				});
			}

			if (baldiCount == 3)
			{
				baldiCount = 0;
				FlxG.sound.play(AssetPaths.getSoundFile("assets/sounds/fantastic"));
				baldiTimer.cancel();
				baldiTimerStarted = false;
			}
		}

		switch type
		{
			case "found":
				guesses += 1;
				FlxG.sound.play(AssetPaths.getSoundFile("assets/sounds/correct"));
				notifText.text = "Correct!";
				notifText.color = FlxColor.GREEN;
			case "alreadyGuessed":
				errTwn();
				FlxG.sound.play(AssetPaths.getSoundFile("assets/sounds/alreadyGuess"));
				notifText.text = "Already Guessed!";
				notifText.color = FlxColor.YELLOW;
			case "notInNames":
				guesses += 1;
				errTwn();
				FlxG.sound.play(AssetPaths.getSoundFile("assets/sounds/incorrect"));
				notifText.text = "Not in Blocklist!";
				notifText.color = FlxColor.RED;
			case "empty":
				errTwn();
				FlxG.sound.play(AssetPaths.getSoundFile("assets/sounds/empty"));
				notifText.text = "You need to type something first, silly!";
				notifText.color = FlxColor.ORANGE;
			default:
				trace("TYPE ERROR: " + type + " not found!");
				notifText.visible = false;
		}

		notifText.screenCenter();
		notifText.y += 130;

		add(notifText);
		FlxTween.tween(notifText, {y: notifText.y - 25, alpha: 0}, 0.8, {
			onComplete: function(twn:FlxTween)
			{
				notifText.destroy();
			}
		});
	}

	function errTwn()
	{
		if (canInputTwn)
		{
			canInputTwn = false;
			FlxTween.tween(inputGroup, {x: 5}, 0.2, {
				ease: FlxEase.quadIn,
				onComplete: function(twn:FlxTween)
				{
					FlxTween.tween(inputGroup, {x: -5}, 0.2, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							FlxTween.tween(inputGroup, {x: 0}, 0.2, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween)
								{
									canInputTwn = true;
								}
							});
						}
					});
				}
			});
		}
	}
}
