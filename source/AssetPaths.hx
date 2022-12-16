package;

@:build(flixel.system.FlxAssets.buildFileReferences("assets", true))
class AssetPaths
{
	static public function getSoundFile(soundPath:String)
	{
		#if desktop
		return soundPath + ".ogg";
		#else
		return soundPath + ".mp3";
		#end
	}
}
