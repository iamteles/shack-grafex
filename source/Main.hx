package;

import flixel.addons.transition.FlxTransitionableState;
import grafex.util.PlayerSettings;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import grafex.util.ClientPrefs;
import openfl.text.TextFormat;

import openfl.Assets;
import openfl.utils.AssetCache;

import flixel.util.FlxSave;

import grafex.windows.WindowsAPI;

import grafex.system.script.GrfxScriptHandler;

import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import grafex.states.substates.PrelaunchingState;
import external.FPSMem;
#if debug
import grafex.states.TitleState;
#end

import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

import haxe.Json;
import haxe.format.JsonParser;

using StringTools;

typedef ConfigFile = {
	var appName:String;
	var appUpSound:String;
	var appDownSound:String;
}

class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: PrelaunchingState, // initial game state
		zoom: -1.0, // game state bounds
		framerate: 120, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var appTitle:String = "The Funk Shack: DEMO";

	public static var appConfig:ConfigFile;

	public function getConfigFile()
	{
		appConfig = Json.parse(Assets.getText('config.json'));
                if(appConfig == null) {
                       appConfig = {
                              appName: "The Funk Shack: DEMO",
                              appUpSound: "volume/vol_up2",
                              appDownSound: "volume/vol_down2"
                       } 
                }
		appTitle = appConfig.appName;
	}

	public static var achievementToatManager:AchievementsToastManager; 
        
	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{	
		Lib.current.addChild(new Main());	
	}

	public function new()
	{
		super();

		stage != null ? init() : addEventListener(Event.ADDED_TO_STAGE, init);

		Application.current.window.onFocusOut.add(onWindowFocusOut);
		Application.current.window.onFocusIn.add(onWindowFocusIn);
		Application.current.window.onClose.add(onWindowClose);
	}

	function onWindowClose()
	{
		trace('Application closed by Player');
	}

	function onWindowFocusOut()
	{
		trace("Game unfocused"); //fr - PurSnake
	}
	
	function onWindowFocusIn()
	{
		trace("Game focused"); //fr - PurSnake
	}

	private function init(?E:Event):Void
	{
		FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;

		Application.current.window.focus();
		
		trace('Game launched');

		if (hasEventListener(Event.ADDED_TO_STAGE)) removeEventListener(Event.ADDED_TO_STAGE, init);
		
		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (game.zoom == -1.0)
		{
			var ratioX:Float = stageWidth / game.width;
			var ratioY:Float = stageHeight / game.height;
			game.zoom = Math.min(ratioX, ratioY);
			game.width = Math.ceil(stageWidth / game.zoom);
			game.height = Math.ceil(stageHeight / game.zoom);
		}

		getConfigFile();

		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.0.0") game.zoom, #end game.framerate, game.framerate, game.skipSplash, game.startFullscreen));

		initBaseGameSettings();

		#if !mobile
		FPSMem = new FPSMem(10, 3, 0xFFFFFF);
		addChild(FPSMem.shadow);
		addChild(FPSMem);
		#end

		achievementToatManager = new AchievementsToastManager();
		addChild(achievementToatManager);

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#if DEVS_BUILD
		trace('Dev Build');
		#else
		trace('Release Build');
		#end

		#if html5
		FlxG.mouse.visible = false;
		#end
	}
 
	var FPSMem:FPSMem;

	public static var changeID:Int = 0;

	public static function initBaseGameSettings() {
		WindowsAPI.setDarkMode(true);
		ClientPrefs.loadDefaultKeys();
		GrfxScriptHandler.initialize();

		final bgColor = 0xFF0D1211;
		//FlxG.cameras.bgColor = bgColor;
		FlxG.stage.color = bgColor;

		/*#if (flixel >= "5.1.0")
		FlxG.game.soundTray.volumeDownSound = Paths.getPath('sounds/volume/vol_down2.ogg', SOUND);
		FlxG.game.soundTray.volumeUpSound = Paths.getPath('sounds/volume/vol_up2.ogg', SOUND);
		#end*/

		#if (flixel >= "5.1.0")
		FlxG.game.soundTray.volumeUpSound = Paths.getPath('sounds/'+appConfig.appUpSound+'.ogg', SOUND);
		FlxG.game.soundTray.volumeDownSound = Paths.getPath('sounds/'+appConfig.appDownSound+'.ogg', SOUND);
		#end

		FlxG.signals.postStateSwitch.add(clearCache);
	}

    public static function clearCache() {

		@:privateAccess {
			// clear uint8 pools
			for(length=>pool in openfl.display3D.utils.UInt8Buff._pools) {
				for(b in pool.clear())
					b.destroy();
			}
			openfl.display3D.utils.UInt8Buff._pools.clear();
		}

        var cache = cast(Assets.cache, AssetCache);
		for (key=>_ in cache.font)
			cache.removeFont(key);
		for (key=>_ in cache.sound)
			cache.removeSound(key);

		FlxG.bitmap.dumpCache();

    }

	public function getFPS():Float
	{
		return FPSMem.currentFPS;
	}

	function onCrash(e:UncaughtErrorEvent):Void
		{
			var errMsg:String = "";
			var path:String;
			var callStack:Array<StackItem> = CallStack.exceptionStack(true);
			var dateNow:String = Date.now().toString().replace(" ", "_").replace(":", "-");

			path = './crash/Grafex_$dateNow.txt';
	
			for (stackItem in callStack)
			{
				switch (stackItem)
				{
					case FilePos(s, file, line, column):
						errMsg += file + " (line " + line + ")\n";
					default:
						Sys.println(stackItem);
				}
			}
	
			errMsg += "\nUncaught Error: "
				+ e.error
				+ "\nPlease report this error to the PurSnake#4389 in Discord\n";
				//+ "\nPlease report this error to #playtest-qa-testing.\n\n>Crash Handler written by: sqirra-rng";
	
			if (!FileSystem.exists("./crash/"))
				FileSystem.createDirectory("./crash/");
	
			File.saveContent(path, errMsg + "\n");
	
			Sys.println(errMsg);
			Sys.println("Crash dump saved in " + Path.normalize(path));
	
			Application.current.window.alert(errMsg, "Critical Error!");
			DiscordClient.shutdown();
			Sys.exit(1);
		}
}
