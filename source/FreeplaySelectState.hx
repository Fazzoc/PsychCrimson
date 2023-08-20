package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;

class FreeplaySelectState extends MusicBeatState{
	
	public static var curSelected:Int = 0;
	
	var freeplayCats:Array<String> = ['main', 'extras'];
	var grpCats:FlxTypedGroup<FlxSprite>;
	var BG:FlxSprite;
   
	override function create(){
        var bg:FlxBackdrop = new FlxBackdrop(Paths.image('mainmenu/MBG'));
		bg.scrollFactor.set();	
		bg.velocity.set(25);
		bg.screenCenter();
		add(bg);
        
		grpCats = new FlxTypedGroup<FlxSprite>();
		add(grpCats);
		
		var scale:Float = 1;
		
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Menu: Freeplay (Selecting Category)", null);
		#end
		
		for (i in 0...freeplayCats.length)
        {
			var offset:Float = 108 - (Math.max(freeplayCats.length, 4) - 4) * 80;
			var catsAssets:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			catsAssets = new FlxSprite(-80).loadGraphic(Paths.image('freeplayselect/select_' + freeplayCats[i]));
			catsAssets.ID = i;
			grpCats.add(catsAssets);
			var scr:Float = (freeplayCats.length - 4) * 0.135;
			catsAssets.antialiasing = ClientPrefs.globalAntialiasing;
			catsAssets.setGraphicSize(Std.int(catsAssets.width * 0.67));
			catsAssets.updateHitbox();
		
			switch (i)
			{
				case 0: //Main
				catsAssets.y = 20;
				catsAssets.x = 45;
				case 1: //extras
				catsAssets.y = 33;
				catsAssets.x = 647;
		}
        changeSelection();
        super.create();
    }
}

    override function update(elapsed:Float){
        
		if (controls.UI_LEFT_P) 
			changeSelection(-1);
		if (controls.UI_RIGHT_P) 
			changeSelection(1);
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
			Paths.clearUnusedMemory();
		}
        if (controls.ACCEPT){
            switch(curSelected){
				case 0: 
				MusicBeatState.switchState(new FreeplayState());
				Paths.clearUnusedMemory();
				case 1: 
				MusicBeatState.switchState(new FreeplayExtrasState());
				Paths.clearUnusedMemory();
			}
        }
        super.update(elapsed);
    }

    function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = freeplayCats.length - 1;
		if (curSelected >= freeplayCats.length)
			curSelected = 0;

		var bullShit:Int = 0;
		for (item in grpCats.members) {
		{
			bullShit++;
		}
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		grpCats.forEach(function(spr:FlxSprite)
			{	
				var tween:FlxTween = FlxTween.tween(spr.scale, {x: 0.6, y: 0.6}, 0.1);
	
				if (spr.ID == curSelected)
				{
					var tween:FlxTween = FlxTween.tween(spr.scale, {x: 0.7, y: 0.7}, 0.1);
				}
			});
	}
}