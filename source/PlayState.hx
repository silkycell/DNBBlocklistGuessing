package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	var guessedNames:Array<String> = [];
	var names:Array<String>;

	var input:FlxInputText = new FlxInputText(0, 0, 150, "", 8);

	var completionAmount:FlxText = new FlxText(0, 0, 0, "0/?", 50);

	override public function create()
	{
		super.create();

		var content:String = sys.io.File.getContent('assets/data/blocklist.txt');
		names = content.split(",");

		completionAmount.text = guessedNames.length + "/" + names.length;
		completionAmount.screenCenter();

		input.screenCenter();
		input.y += 150;
		add(input);

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
		trace(input);

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

		switch type
		{
			case "found":
				FlxG.sound.play("assets/sounds/correct.ogg");
				notifText.text = "Found!";
				notifText.color = FlxColor.GREEN;
			case "alreadyGuessed":
				notifText.text = "Already Guessed!";
				notifText.color = FlxColor.YELLOW;
			case "notInNames":
				notifText.text = "Not in Blocklist!";
				notifText.color = FlxColor.RED;
			case "empty":
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
