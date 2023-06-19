package grafex.states.substates;

import flixel.tweens.FlxTween;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import grafex.system.Paths;
import grafex.system.statesystem.MusicBeatState;
import grafex.util.PlayerSettings;
import grafex.util.ClientPrefs;
import grafex.util.Highscore;
import sys.Http;
import sys.io.File;
import sys.FileSystem;
import grafex.data.EngineData;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import grafex.util.Utils;

// TODO: rewrite this, maybe?

using StringTools;

class PrelaunchingState extends MusicBeatState
{
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

    public static var leftState:Bool = false;
    private static var alreadySeen:Bool = false;

    var connectionFailed:Bool = false;

    var curSelected = 0;

    public var arrowSine:Float = 0;
	public var arrowTxt:FlxText;

    var txt:FlxText;
    var txts:Array<Array<String>> = [
        [
            "Disclaimer!\nThis game contains some flashing lights!\nYou've been warned!\n\nYou can disable them in Options Menu", ""
        ]
    ];

    override function create()
    {
        super.create();

        Application.current.window.title = Main.appTitle;
        
		FlxG.mouse.visible = false;
        FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];
        FlxG.camera.zoom = 1;

		PlayerSettings.init();

        FlxG.save.bind('game', Utils.getSavePath());
		ClientPrefs.loadPrefs();

		Highscore.load();

        connectionFailed = false;

        if(Utils.getUsername() == 'georg' && FlxG.random.bool(30)) {
            Utils.browserLoad('https://www.youtube.com/watch?v=oZAGNaLrTd0');
            FlxG.camera.flash(FlxColor.WHITE, 0.1, function() {
                Sys.exit(0);
            });
        }
        
        var version:Array<Int> = null;
        
        if(FlxG.save.data.noLaunchScreen == null)
            FlxG.save.data.noLaunchScreen = false;

        if(FlxG.save.data.noLaunchScreen == true/* && Utils.getUsername() != 'georg'*/)
            MusicBeatState.switchState(new TitleState());


        txt = new FlxText(0, 300, FlxG.width, '', 32);
        txt.borderColor = FlxColor.BLACK;
        txt.borderSize = 3;
        txt.borderStyle = FlxTextBorderStyle.OUTLINE;
        txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        txt.screenCenter(X);
        add(txt);

        arrowTxt = new FlxText(txt.x + 300, txt.y + 300, FlxG.width, '', 32);
        arrowTxt.borderColor = FlxColor.BLACK;
        arrowTxt.borderSize = 3;
        arrowTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
        arrowTxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        add(arrowTxt);       
        
        changeSelection();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(controls.ACCEPT)
            makeCoolTransition();
    }

	function changeSelection(?pos:Int)
    {
        if(leftState)
            return;

        curSelected += pos;
    
        if (curSelected <= 0)
			curSelected = 0;
		if (curSelected >= txts.length + 1)
			curSelected = txts.length - 1;    

        if(txts != null && curSelected < txts.length)
        {
            txt.text = txts[curSelected][0];
            if(txts.length != 1)
                {
                    if(curSelected > 0 && curSelected < txts.length)
                        arrowTxt.text = "< - >";
                    if(curSelected == 0)
                        arrowTxt.text = ">";
                    if(curSelected == txts.length - 1)
                        arrowTxt.text = "<";
                }
        }

        if(curSelected == txts.length)
            makeCoolTransition();
            
        FlxG.sound.play(Paths.sound('scrollMenu'));
    }

    function makeCoolTransition()
    {
        arrowTxt.alpha = 1;
        leftState = true;
        alreadySeen = true;
        //FlxG.camera.fade(FlxColor.BLACK, 3, true);
        FlxTween.tween(txt, {alpha: 0}, 3);
        FlxTween.tween(arrowTxt, {alpha: 0}, 3);
        FlxG.sound.play(Paths.sound('titleShoot'), 0.8).fadeOut(4, 0);
        FlxG.camera.flash(FlxColor.WHITE, 3, function() {
            FlxTransitionableState.skipNextTransIn = false;
            FlxTransitionableState.skipNextTransOut = false;
            FlxG.save.data.noLaunchScreen = true;
            FlxG.save.flush();
            MusicBeatState.switchState(new TitleState());
        });
    }
}