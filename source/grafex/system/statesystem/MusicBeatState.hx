package grafex.system.statesystem;

import grafex.states.playstate.PlayState;
import external.FlxVideo;
import lime.app.Application;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.FlxCamera;
import flixel.FlxState;
import grafex.util.Controls;
import grafex.util.ClientPrefs;
import grafex.util.PlayerSettings;

import openfl.Assets;
import openfl.utils.AssetCache;
import grafex.util.MemoryUtil;

import grafex.system.script.GrfxScriptHandler;

class MusicBeatState extends FlxUIState
{
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	private var controls(get, never):Controls;

	public static var camBeat:FlxCamera;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create() {
		Application.current.window.onFocusOut.add(onFocusLost);
		Application.current.window.onFocusIn.add(onFocus);
		camBeat = FlxG.camera;
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		super.create();


		if(!skip) openSubState(new CustomFadeTransition(0.6, true));
		
		FlxTransitionableState.skipNextTransOut = false;
	}

	#if (VIDEOS_ALLOWED && windows)
	override public function onFocus():Void
	{
		FlxVideo.onFocus();
		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		FlxVideo.onFocusLost();
		super.onFocusLost();
	}
	#end

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		//everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0) stepHit();
	
			if(PlayState.SONG != null) oldStep < curStep ? updateSection() : rollbackSection();
		}
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;

				curSection++;
			}
		}
		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState) {
		// Custom made Trans in
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		if(!FlxTransitionableState.skipNextTransIn) {
			leState.openSubState(new CustomFadeTransition(0.4, false));
			if(nextState == FlxG.state) {
				CustomFadeTransition.finishCallback = function() {
                    clearCache();
					FlxG.resetState();
				};
				//trace('resetted');
			} else {
				CustomFadeTransition.finishCallback = function() {
                    clearCache();
					FlxG.switchState(nextState);
				};
				//trace('changed state');
			}
			return;
		}
        clearCache();
		FlxTransitionableState.skipNextTransIn = false;
		FlxG.switchState(nextState);
	}

    public static function clearCache() {

	    @:privateAccess {
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

	public static function resetState() {
		MusicBeatState.switchState(FlxG.state);
	}

	public static function getState():MusicBeatState {
		var curState:Dynamic = FlxG.state;
		var leState:MusicBeatState = curState;
		return leState;
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void
	{
		//do literally nothing dumbass
	}

	public function sectionHit():Void
	{
		//GrfxLogger.debug('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}
