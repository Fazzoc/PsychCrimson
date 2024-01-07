# Psych Crimson - Source
Psych Crimson is a **Template Engine** based on a fork of Psych Engine (0.6.3/Legacy). An Engine originally used on [Mind Games Mod](https://gamebanana.com/mods/301107), intended to be a fix for the vanilla version's many issues while keeping the casual play aspect of it. 

Crimson's mission aim is to be a simpler alternative to Source code development by providing the essentials only, to have the game running, while also providing quality of life improvements for the user.

This does things such as
- Remove vanilla weeks + contents from them (such as code and assets)
- No mod folder functionality, while manintaning COMPLETE Lua capabilities (as it's source focused)
- AND MORE TO COME!!!
  
- Indev builds coming soon! (Atm you can test the engine via the ![image](https://github.com/Fazzoc/PsychCrimson/assets/87571200/9abd7b89-3b31-4c5e-ace7-335f123bfca7) tab) 

![Crimson-Logo (4)](https://github.com/Fazzoc/PsychCrimson/assets/87571200/bd341f11-1921-4d2f-ad8f-b939265b8103)

* (go on their GitHub for more info and Documentation: https://github.com/ShadowMario/FNF-PsychEngine)

# The goals
For this engine, the goal is to implement and change a few things to improve the experience:

- better crash prevention + handler
- stage editor
- better caching system (automatic caching rather than the current manual one)
- improved category select (in week editor you'll be able to select either which songs or weeks you want to have in those categories) 
- general optimization
- crimson UI
- bug fixes (ofc) 
- chart editor improvements 

# How to Compile?

To be able to build our mod, it requires these dependencies and libraries:

**Haxe 4.2.5 or newer (4.3.2 is recommended or use 4.2.5 if you also compile fnf mods that don't support newer haxe builds)**

lime : haxelib install lime

flixel addons : haxelib install flixel-addons

flixel tools : haxelib install flixel-tools

flixel ui : haxelib install flixel-ui

flixel : haxelib install flixel

hscript : haxelib install hscript

openfl : haxelib install openfl 9.3.1 (newer versions create errors)

hxcpp [Git] : haxelib git hxcpp https://github.com/HaxeFoundation/hxcpp.git

hxCodec [Git] : haxelib git hxCodec https://github.com/polybiusproxy/hxCodec.git

linc_luajit [Git] : haxelib git linc_luajit https://github.com/superpowers04/linc_luajit

Discord RPC [Git] : haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc.git
