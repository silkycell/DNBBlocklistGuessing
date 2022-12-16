package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
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
			trace("Found!");
			notif("found");
			guessedNames.push(input);
		}
		else if (alreadyGuessed)
		{
			notif("alreadyGuessed");
			trace("Already Guessed!");
		}
		else
		{
			notif("notInNames");
			trace("Not in names!");
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
				notifText.text = "Found!";
				notifText.color = FlxColor.GREEN;
			case "alreadyGuessed":
				notifText.text = "Already Guessed!";
				notifText.color = FlxColor.YELLOW;
			case "notInNames":
				notifText.text = "Not in Blocklist!";
				notifText.color = FlxColor.RED;
			default:
				trace("TYPE ERROR! " + type + " not found!", "warning");
				notifText.visible = false;
		}

		notifText.screenCenter();
		notifText.y += 150;

		add(notifText);
		FlxTween.tween(notifText, {y: notifText.y - 25, alpha: 1}, 0.8, {
			onComplete: function(twn:FlxTween)
			{
				notifText.destroy();
			}
		});
	}
}
