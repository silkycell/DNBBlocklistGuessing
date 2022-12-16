package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	var guessedNames:Array<String> = [];
	var names:Array<String>;

	var inputGroup:FlxSpriteGroup = new FlxSpriteGroup();

	var input:FlxInputText = new FlxInputText(0, 0, 150, "", 8);

	var completionAmount:FlxText = new FlxText(0, 0, 0, "0/?", 50);
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

		input.screenCenter();
		input.y += 150;
		input.updateHitbox();
		inputGroup.add(input);

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

		add(completionAmount);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
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
			notif("found");
			guessedNames.push(input);
		}
		else if (alreadyGuessed)
		{
			notif("alreadyGuessed");
			trace(input);
		}
		else
		{
			notif("notInNames");
		}

		completionAmount.text = guessedNames.length + "/" + names.length;
		completionAmount.screenCenter();
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
				FlxG.sound.play("assets/sounds/fantastic.ogg");
				baldiTimer.cancel();
				baldiTimerStarted = false;
			}
		}

		switch type
		{
			case "found":
				FlxG.sound.play("assets/sounds/correct.ogg");
				notifText.text = "Correct!";
				notifText.color = FlxColor.GREEN;
			case "alreadyGuessed":
				FlxG.sound.play("assets/sounds/alreadyGuess.ogg");
				notifText.text = "Already Guessed!";
				notifText.color = FlxColor.YELLOW;
			case "notInNames":
				FlxG.sound.play("assets/sounds/incorrect.ogg");
				notifText.text = "Not in Blocklist!";
				notifText.color = FlxColor.RED;
			case "empty":
				FlxG.sound.play("assets/sounds/empty.ogg");
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
}
