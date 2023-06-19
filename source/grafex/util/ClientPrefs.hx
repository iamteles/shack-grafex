package grafex.util;

import grafex.states.substates.PrelaunchingState;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import grafex.util.Controls;
import external.FPSMem;

class ClientPrefs {
	public static var enableTimeBar:Bool = true;
	public static var noteSplashesScale:Float = 1;
	public static var lightCpuStrums:Bool = true;
	public static var classicScoreTxt:Bool = true;
    public static var playMissSounds:Bool = true;
	public static var countDownPause:Bool = true;
    public static var hitSound:Bool = false;
    public static var shouldCameraMove:Bool = true;
    public static var hsvol:Float = 0;
    public static var instantRespawn:Bool = false;
    public static var autoPause:Bool = false;
	public static var visibleHealthbar:Bool = true;
	public static var ColorBlindType:String = 'None';
	public static var ColorBlindTypeNum:Int = 0;
	public static var hideOpponenStrums:Bool = false;
	public static var chartAutoSaveInterval:Int = 5;
	public static var chartAutoSave:Bool = true;
    public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var showFPS:Bool = true;
    public static var showMEM:Bool = true;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var shaders:Bool = true;
	public static var framerate:Int = 120;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var hideHud:Bool = false;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
	public static var imagesPersist:Bool = false;
	public static var ghostTapping:Bool = false;
	public static var scoreZoom:Bool = true;
	public static var noReset:Bool = false;
	public static var controllerMode:Bool = false;
	public static var comboStacking = false;
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false,
		'healthdrainpercent' => 0
	];
	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	
	public static var ratingOffset:Int = 0;
	public static var sickWindow:Int = 45;
	public static var goodWindow:Int = 90;
	public static var badWindow:Int = 135;
	public static var safeFrames:Float = 10;

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_left'		=> [A, LEFT],
		'note_down'		=> [S, DOWN],
		'note_up'		=> [W, UP],
		'note_right'	=> [D, RIGHT],
		
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_up'			=> [W, UP],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R, NONE],
		
		'volume_mute'	=> [ZERO, NONE],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN, NONE],
		'debug_2'		=> [EIGHT, NONE]
	];

	public static var gpuRender:Bool = true;

	public static var defaultKeys:Map<String, Array<FlxKey>> = null;

	public static var achievements:Map<String, Bool> = new Map<String, Bool>();

	public static var hellAssTips:Map<String, Bool> = new Map<String, Bool>();

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		//trace(defaultKeys);
	}

	public static function saveSettings() {
		FlxG.save.data.enableTimeBar = enableTimeBar;
		FlxG.save.data.noteSplashesScale = noteSplashesScale;
		FlxG.save.data.achievements = achievements;
		FlxG.save.data.hellAssTips = hellAssTips;
		FlxG.save.data.lightCpuStrums = lightCpuStrums;
        FlxG.save.data.autoPause = autoPause;
		FlxG.save.data.visibleHealthbar = visibleHealthbar;
        FlxG.save.data.instantRespawn = instantRespawn;
        FlxG.save.data.playMissSounds = playMissSounds;
        FlxG.save.data.hitSound = hitSound;
        FlxG.save.data.shouldCameraMove = shouldCameraMove;
		FlxG.save.data.chartAutoSaveInterval = chartAutoSaveInterval;
		FlxG.save.data.chartAutoSave = chartAutoSave;
        FlxG.save.data.downScroll = downScroll;
        FlxG.save.data.classicScoreTxt = classicScoreTxt;
    	FlxG.save.data.shaders = shaders;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.countDownPause = countDownPause;
		FlxG.save.data.showFPS = showFPS;
        FlxG.save.data.showMEM = showMEM;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.framerate = framerate;
		FlxG.save.data.ColorBlindType = ColorBlindType;
		FlxG.save.data.comboStacking = comboStacking;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.hideOpponenStrums = hideOpponenStrums;
        FlxG.save.data.hsvol = hsvol;
		FlxG.save.data.comboOffset = comboOffset;
		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.controllerMode = controllerMode;
	
		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'PurSnake'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		trace("Settings saved!");
	}

	public static function loadPrefs() {
		if(FlxG.save.data.enableTimeBar != null) enableTimeBar = FlxG.save.data.enableTimeBar;

		if(FlxG.save.data.noteSplashesScale != null) noteSplashesScale = FlxG.save.data.noteSplashesScale;

		if(FlxG.save.data.achievements != null) achievements = FlxG.save.data.achievements;
		if(FlxG.save.data.hellAssTips != null) hellAssTips = FlxG.save.data.hellAssTips;

		if(FlxG.save.data.lightCpuStrums != null) lightCpuStrums = FlxG.save.data.lightCpuStrums;

		FlxG.save.data.classicScoreTxt != null ? classicScoreTxt = FlxG.save.data.classicScoreTxt : classicScoreTxt = true;
		FlxG.save.data.comboStacking != null ? comboStacking = FlxG.save.data.comboStacking : comboStacking = true;
		FlxG.save.data.ColorBlindType != null ? ColorBlindType = FlxG.save.data.ColorBlindType : ColorBlindType = 'None';
		FlxG.save.data.ColorBlindTypeNum != null ? ColorBlindTypeNum = FlxG.save.data.ColorBlindTypeNum : ColorBlindTypeNum = 0;
		FlxG.save.data.hideOpponenStrums != null ? hideOpponenStrums = FlxG.save.data.hideOpponenStrums : hideOpponenStrums = false;
		FlxG.save.data.chartAutoSaveInterval != null ? chartAutoSaveInterval = FlxG.save.data.chartAutoSaveInterval : chartAutoSaveInterval = 5;
		FlxG.save.data.chartAutoSave != null ? chartAutoSave = FlxG.save.data.chartAutoSave : chartAutoSave = true;
		FlxG.save.data.countDownPause != null ? countDownPause = FlxG.save.data.countDownPause : countDownPause = true;
		FlxG.save.data.visibleHealthbar != null ? visibleHealthbar = FlxG.save.data.visibleHealthbar : visibleHealthbar = true;
		FlxG.save.data.shouldCameraMove != null ? shouldCameraMove = FlxG.save.data.shouldCameraMove : shouldCameraMove = true;
		FlxG.save.data.autoPause != null ? {
			autoPause = FlxG.save.data.autoPause;
			FlxG.autoPause = autoPause;
		} : {
			autoPause = false;
			FlxG.autoPause = autoPause;
		};
		FlxG.save.data.hitSound != null ? hitSound = FlxG.save.data.hitSound : hitSound = false;
		FlxG.save.data.playMissSounds != null ? playMissSounds = FlxG.save.data.playMissSounds : playMissSounds = true;
		FlxG.save.data.hitSound != null ? hitSound = FlxG.save.data.hitSound : hitSound = false;
		FlxG.save.data.instantRespawn != null ? instantRespawn = FlxG.save.data.instantRespawn : instantRespawn = false;
		FlxG.save.data.downScroll != null ? downScroll = FlxG.save.data.downScroll : downScroll = false;
		FlxG.save.data.middleScroll != null ? middleScroll = FlxG.save.data.middleScroll : middleScroll = false;
		FlxG.save.data.showFPS != null ? {
			showFPS = FlxG.save.data.showFPS; 
			FPSMem.showFPS = showFPS;
		} : showFPS = true;
		FlxG.save.data.showMEM != null ? {
			showMEM = FlxG.save.data.showMEM; 
			FPSMem.showMem = showMEM;
		} : showMEM = false;
		FlxG.save.data.flashing != null ? flashing = FlxG.save.data.flashing : flashing = true;
		FlxG.save.data.noteSplashes != null ? noteSplashes = FlxG.save.data.noteSplashes : noteSplashes = true;
		FlxG.save.data.lowQuality != null ? lowQuality = FlxG.save.data.lowQuality : lowQuality = false;
		FlxG.save.data.shaders != null ? shaders = FlxG.save.data.shaders : shaders = true;
		FlxG.save.data.camZooms != null ? camZooms = FlxG.save.data.camZooms : camZooms = true;
		FlxG.save.data.hideHud != null ? hideHud = FlxG.save.data.hideHud : hideHud = false;
		FlxG.save.data.noteOffset != null ? noteOffset = FlxG.save.data.noteOffset : noteOffset = 0;
		FlxG.save.data.arrowHSV != null ? arrowHSV = FlxG.save.data.arrowHSV : arrowHSV = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
		FlxG.save.data.imagesPersist != null ? {
			imagesPersist = FlxG.save.data.imagesPersist; 
			FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;
		} : {
			imagesPersist = false; 
			FlxGraphic.defaultPersist = ClientPrefs.imagesPersist;
		};
		FlxG.save.data.ghostTapping != null ? ghostTapping = FlxG.save.data.ghostTapping : ghostTapping = false;
		FlxG.save.data.scoreZoom != null ? scoreZoom = FlxG.save.data.scoreZoom : scoreZoom = true;
		FlxG.save.data.noReset != null ? noReset = FlxG.save.data.noReset : noReset = false;
		FlxG.save.data.hsvol != null ? hsvol = FlxG.save.data.hsvol : hsvol = 0;
		FlxG.save.data.comboOffset != null ? comboOffset = FlxG.save.data.comboOffset : comboOffset = [0, 0, 0, 0];
		FlxG.save.data.ratingOffset != null ? ratingOffset = FlxG.save.data.ratingOffset : ratingOffset = 0;
		FlxG.save.data.sickWindow != null ? sickWindow = FlxG.save.data.sickWindow : sickWindow = 45;
		FlxG.save.data.goodWindow != null ? goodWindow = FlxG.save.data.goodWindow : goodWindow = 90;
		FlxG.save.data.badWindow != null ? badWindow = FlxG.save.data.badWindow : badWindow = 135;
		FlxG.save.data.safeFrames != null ? safeFrames = FlxG.save.data.safeFrames : safeFrames = 10;
		FlxG.save.data.controllerMode != null ? controllerMode = FlxG.save.data.controllerMode : controllerMode = false;
		FlxG.save.data.volume != null ? FlxG.sound.volume = FlxG.save.data.volume : FlxG.sound.volume = 1;
		FlxG.save.data.mute != null ? FlxG.sound.muted = FlxG.save.data.mute : FlxG.sound.muted = false;
		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}

		if(FlxG.save.data.gameplaySettings != null)
			{
				var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
				for (name => value in savedMap)
				{
					gameplaySettings.set(name, value);
				}
			}

		if(FlxG.save.data.framerate == null) {
			framerate = 120;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'AnimaniaCrew');
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);

		PrelaunchingState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		PrelaunchingState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		PrelaunchingState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = PrelaunchingState.muteKeys;
		FlxG.sound.volumeDownKeys = PrelaunchingState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = PrelaunchingState.volumeUpKeys;
	}

	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}
