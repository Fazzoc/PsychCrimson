#if !macro
//Discord API
#if desktop
import Discord.DiscordClient;
#end

//Psych
#if LUA_ALLOWED
import FunkinLua;
import llua.Lua;
import llua.State;
import llua.LuaL;
import llua.Convert;
#end

#if ACHIEVEMENTS_ALLOWED
import Achievements;
#end

//Flixel
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

import Paths;
import Controls;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import Alphabet;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;
#end