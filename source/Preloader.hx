package;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import lime.app.Application;
import flixel.ui.FlxBar;
import haxe.Json;
import flixel.util.FlxCollision;
import options.GraphicsSettingsSubState;
import openfl.display.BitmapData;
import openfl.utils.Assets;
import haxe.Exception; //funi
import flixel.FlxState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.addons.transition.FlxTransitionableState;
#if cpp
import sys.FileSystem;
import sys.io.File;
import sys.thread.Thread;
#end

enum PreloadType {
    atlas;
    image;
    imagealt;
    music;
}

/**
 * Preloading class which loads everything including music (exepting sounds)
 */
class Preloader extends MusicBeatState {

    var globalRescale:Float = 2/3;
    var preloadStart:Bool = false;

    var loadText:FlxText;
    var loadBar:FlxBar;

    public var isMenu:Bool = false;
   
    public static var initialized:Bool = false;

    var assetStack:Map<String, PreloadType> = [

        
        //Preload UI stuff
        'healthBar' => PreloadType.image,
        
        //Icons cause why not?
        'icons/icon-bf' => PreloadType.imagealt,
        
        //Preload countdown assets for better loading time
        'go' => PreloadType.image, 
        'ready' => PreloadType.image, 
        'set' => PreloadType.image,  

        //Preload the entire character roster (Sorry, this doesn't mean no more lag spikes when hardcoded, but it does work if the character change events are in the chart editor)
        'BOYFRIEND' => PreloadType.atlas,
                
        //Menu stuff (atlas: XML files, imagealt: images from the preload folder)
        'MMBar' => PreloadType.imagealt,
        'MMSelectedGlow' => PreloadType.imagealt,
        'MBG' => PreloadType.imagealt,
        
        //songs
        'Test' => PreloadType.music,
        
    ];
    var maxCount:Int;

    public static var preloadedAssets:Map<String, FlxGraphic>;
    //var backgroundGroup:FlxTypedGroup<FlxSprite>;
    
    public var newClass:Any;

    // Made this in case you make some logics of loading state when switching menus like MusicBeatState.switchState(new Preloading(true, new FreeplayState()));
    public function new(?e:Bool = false, ?switchClass:FlxState)
        {
            this.isMenu = e;
            this.newClass = switchClass;

            super();
        }

    override public function create() {
        super.create();
        
        FlxG.drawFramerate = 60;
        FlxG.updateFramerate = 60;

        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;

        FlxG.camera.alpha = 0;

        maxCount = Lambda.count(assetStack);
        trace(maxCount);
        
        FlxG.mouse.visible = false;

        preloadedAssets = new Map<String, FlxGraphic>();

        var leRandom:Int = 2;
    
        FlxTween.tween(FlxG.camera, {alpha: 1}, 0.5, {
            onComplete: function(tween:FlxTween){
                Thread.create(function(){
                    assetGenerate();
                });
            }
        });

        // save bullshit
        PlayerSettings.init();
        FlxG.save.bind('crimson', CoolUtil.getSavePath());
        ClientPrefs.loadPrefs();
        
        #if desktop
        DiscordClient.initialize();
        Application.current.onExit.add (function (exitCode) {
            DiscordClient.shutdown();
        });
        #end

        if(!initialized && FlxG.save.data != null && ClientPrefs.fullscreen)
            {
                FlxG.fullscreen = ClientPrefs.fullscreen;
            }

        loadText = new FlxText(20, FlxG.height - (32 + 60), 0, 'Loading...', 32);
        loadText.setFormat(Paths.font("Brose.ttf"), 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        loadText.alpha = 0;
        add(loadText); 

        loadBar = new FlxBar(-5, 730, LEFT_TO_RIGHT, 1285, 50, this,
        'storedPercentage', 0, 1);
        loadBar.alpha = 0;
        loadBar.angle = 1.4;
        loadBar.createFilledBar(0xFF2E2E2E, FlxColor.WHITE);
        add(loadBar);

        FlxTween.tween(loadText, {alpha: 1,}, 0.5, {startDelay: 0.5});
        FlxTween.tween(loadBar, {alpha: 1, y: 701}, 0.5, {startDelay: 0.5});
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
    }

    var storedPercentage:Float = 0;

    function assetGenerate() {
        //
        var countUp:Int = 0;
        for (i in assetStack.keys()) {
            trace('calling asset $i');

            FlxGraphic.defaultPersist = true;
            switch(assetStack[i]) {
                case PreloadType.imagealt:
                    var menuShit:FlxGraphic = FlxG.bitmap.add(Paths.image(i));
                    preloadedAssets.set(i, menuShit);
                    trace('menu asset is loaded');
                case PreloadType.image:
                    var savedGraphic:FlxGraphic = FlxG.bitmap.add(Paths.image(i, 'shared'));
                    preloadedAssets.set(i, savedGraphic);
                    trace(savedGraphic + ', yeah its working');
                case PreloadType.atlas:
                    var preloadedCharacter:Character = new Character(FlxG.width / 2, FlxG.height / 2, i);
                    preloadedCharacter.visible = false;
                    add(preloadedCharacter);
                    trace('character loaded ${preloadedCharacter.frames}');
                case PreloadType.music:
                    var savedInst:FlxGraphic = FlxG.bitmap.add(Paths.inst(i));
                    var savedVocals:FlxGraphic = FlxG.bitmap.add(Paths.voices(i));
                    preloadedAssets.set(i, savedInst);
                    preloadedAssets.set(i, savedVocals);
                    trace('loaded vocals of $savedVocals');
                    trace('loaded instrumental of $savedInst');
            }
            FlxGraphic.defaultPersist = false;
        
            countUp++;
            storedPercentage = countUp/maxCount;
        }

        ///*
        FlxTween.tween(FlxG.camera, {alpha: 0}, 0.5, {startDelay: 1,
            onComplete: function(tween:FlxTween){
                    if(!isMenu)
                    MusicBeatState.switchState(new TitleState());
                    else
                    MusicBeatState.switchState(newClass);
            }});
            }
        }