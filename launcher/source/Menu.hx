#if html5
import js.Browser;
import js.Lib in JsLib;
#end
import Paths;
import TechnicFunctions;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxExtendedSprite;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.system.FlxSound;
import flixel.system.frontEnds.SoundFrontEnd;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import lime.net.HTTPRequest;
import openfl.display.BitmapData;
import openfl.ui.Mouse;

enum MenuType
{
	main;
	settings;
	controlsPC;
	controlsGamepad;
	controlsMobile;
}

// Hello fellow developer! Thanks for stopping by.
// You can do what ever you want with this code. A credit is encouraged but optional.
class Menu extends FlxState
{
	/* VERSION */
	var version:Array<Int> = [2, 0, 0];
	#if html5
	var platform:String = "web";
	#else
	#if windows
	var platform:String = "windows";
	#else
	#if linux
	var platform:String = "linux";
	#else
	var platform:String = "unknown";
	#end
	#end
	#end
	/* GAME DATA */
	/* CHANGE THESE VALUES */
	var gameStringID:Array<String> = [
		'sm64pcport',
		'superhot',
		'subwaySurfers',
		'doomjscompressed',
		'doomjscompressed',
		'half-life',
		'mcEagler',
		'mari0'
	];
	var gameSupportsPlatforms:Array<Array<Bool>> = [
		// PC  Mobile Gamepad
		[true, false, true],
		[true, false, false],
		[true, true, false],
		[true, true, false],
		[true, true, false],
		[true, false, false],
		[true, false, false],
		[true, false, false]
	];
	var gameLinkEndTags:Array<String> = [
		'/',
		'/',
		'/',
		'/?bundleUrl=/d?anonymous=1',
		'/?bundleUrl=/d2?anonymous=1',
		'/',
		'/',
		'/'
	];
	/* */
	var gameDevImagePaths:Array<String> = [""];
	var gameID:Int = 0;
	var _save:FlxSave = new FlxSave();
	// UI
	var title:FlxSprite = new FlxSprite();
	var clicktostart:FlxSprite = new FlxSprite();
	var bg:FlxSprite = new FlxSprite();
	var gameCover:FlxSprite = new FlxSprite();
	var gameChar:FlxSprite = new FlxSprite();
	var leftArrow:FlxExtendedSprite = new FlxExtendedSprite();
	var rightArrow:FlxExtendedSprite = new FlxExtendedSprite();
	var playButton:FlxExtendedSprite = new FlxExtendedSprite();
	var platPC:FlxExtendedSprite = new FlxExtendedSprite();
	var platMobile:FlxExtendedSprite = new FlxExtendedSprite();
	var platGamepad:FlxExtendedSprite = new FlxExtendedSprite();
	var settingsIcon:FlxExtendedSprite = new FlxExtendedSprite();
	var settingsMenu:FlxExtendedSprite = new FlxExtendedSprite();
	var controls:FlxExtendedSprite = new FlxExtendedSprite();
	var discord:FlxExtendedSprite = new FlxExtendedSprite();
	// Tweens
	var coverFadeIn:FlxTween;
	var charFadeIn:FlxTween;
	var pcIn:FlxTween;
	var mobileIn:FlxTween;
	var gamepadIn:FlxTween;
	var fader:FlxExtendedSprite = new FlxExtendedSprite();
	var faderIn:FlxTween;
	var faderOut:FlxTween;

	// Settings Stuffs
	var set_antiAliasingSwitch = new FlxExtendedSprite();
	var set_antiAliasingText = new FlxText();
	var set_windowSwitch:FlxExtendedSprite = new FlxExtendedSprite();
	var set_windowText:FlxText = new FlxText();
	var versionText:FlxText = new FlxText();
	// Flixel
	var gamepad:FlxGamepad;
	// Booleans
	var started:Bool = false;
	var menuLoaded:Bool = false;
	var maxClickAlpha:Bool = false;
	var clicksoundstarted:Bool = false;
	var mouseDown:Bool;
	var touchingui:Bool = false;
	var gamepad_left:Bool = false;
	var gamepad_right:Bool = false;
	var startButtonFix:Bool = false;
	var inSecondaryMenu:Bool = false;
	// Float
	var titlesize:Float = 0.5;
	// Ints
	var downloadTimesClicked:Int = 0;
	// Strings
	var currentGame:String = "";
	var fontFix:String = "";

	#if html5
	var website:String = Browser.window.location.href;
	var browserwindow = Browser.window;
	#end
	// Other
	var s:FlxSound;
	var download:FlxExtendedSprite = new FlxExtendedSprite();
	var loading:Bool = false;
	var menuType:EnumValue = main;

	override public function create()
	{
		// SoundFrontEnd.soundTrayEnabled = false;
		Mouse.cursor = "arrow";
		_save.bind("settingsData");
		if (_save.data.lastgameid == null)
		{
			gameID = 0;
		}
		else
		{
			gameID = _save.data.lastgameid;
		}
		if ((_save.data.antialiasing != true) || (_save.data.antialiasing != false))
		{
			_save.data.antialiasing = true;
		}
		else
		{
			_save.data.antialiasing = false;
		}
		if ((_save.data.openInWindow != true) || (_save.data.openInWindow != false))
		{
			_save.data.openInWindow = true;
		}
		else
		{
			_save.data.openInWindow = false;
		}
		_save.data.lastgameid = gameID;
		_save.flush();
		#if !mobile
		FlxG.mouse.useSystemCursor = true;
		FlxG.mouse.visible = true;
		#end
		FlxG.autoPause = false;
		bgColor = 0;
		FlxMouseEventManager.add(bg);
		super.create();
		title.alpha = 1;
		title.loadGraphic('assets/images/gamesandstuff.png');
		title.scale.set(0.5, 0.5);
		title.screenCenter();
		add(title);
		clicktostart.alpha = 1;
		clicktostart.loadGraphic('assets/images/clicktostart.png');
		clicktostart.scale.set(0.25, 0.25);
		clicktostart.screenCenter();
		clicktostart.y += 85;
		add(clicktostart);
		TechnicFunctions.spritesheet(gameCover, Paths.Images('gameCovers'));
		var i:Int = 0;
		for (gameName in gameStringID)
		{
			TechnicFunctions.staticSpritesheetAnimAdd(gameCover, "gameCovers", i + "game");
			i++;
		}
		gameCover.x = -283;
		gameCover.y = -146;
		gameCover.scale.set(0.25, 0.25);
		TechnicFunctions.spritesheet(gameChar, Paths.Images('characters'));
		var i:Int = 0;
		for (gameName in gameStringID)
		{
			TechnicFunctions.staticSpritesheetAnimAdd(gameChar, "characters", i + "game");
			i++;
		}
		gameChar.x = 57;
		gameChar.y = -100;
		gameChar.scale.set(0.4, 0.4);
		leftArrow.loadGraphic('assets/images/triangle.png'); // sprite image
		leftArrow.alpha = 1; // opacity
		leftArrow.angle = -135; // rotation of sprite
		leftArrow.screenCenter(Y); // center on the Y axis
		leftArrow.x = 75;
		leftArrow.height += 55;
		leftArrow.centerOffsets(true);
		leftArrow.offset.x -= 35;
		FlxMouseEventManager.add(leftArrow);
		FlxMouseEventManager.setMouseClickCallback(leftArrow, leftArrowClick);
		rightArrow.loadGraphic('assets/images/triangle.png');
		rightArrow.alpha = 1;
		rightArrow.angle = 45;
		rightArrow.screenCenter(Y);
		rightArrow.x = 1110;
		rightArrow.height += 55;
		rightArrow.centerOffsets(true);
		rightArrow.offset.x -= -45;
		FlxMouseEventManager.add(rightArrow);
		FlxMouseEventManager.setMouseClickCallback(rightArrow, rightArrowClick);
		playButton.alpha = 1;
		playButton.loadGraphic('assets/images/play.png');
		playButton.scale.set(0.5069420, 0.5069420); // funni moment AMO-*vine boom* x1 x2 x1000000
		playButton.updateHitbox();
		playButton.screenCenter(X);
		playButton.y = 522.292;
		FlxMouseEventManager.add(playButton);
		FlxMouseEventManager.setMouseClickCallback(playButton, playButtonClick); // basically "when playButton clicked -> run playButtonClick function"
		#if html5
		fontFix = "assets/fonts/FuturaWeb.woff";
		#else
		fontFix = "assets/fonts/Futura.ttf";
		#end
		TechnicFunctions.spritesheet(platPC, Paths.Images('platforms'));
		TechnicFunctions.staticSpritesheetAnimAdd(platPC, "platforms", "pc");
		platPC.x = 207;
		platPC.y = 407;
		TechnicFunctions.spritesheet(platMobile, Paths.Images('platforms'));
		TechnicFunctions.staticSpritesheetAnimAdd(platMobile, "platforms", "mobile");
		platMobile.x = 307;
		platMobile.y = 407;
		platMobile.scale.set(0.83, 0.83);
		TechnicFunctions.spritesheet(platGamepad, Paths.Images('platforms'));
		TechnicFunctions.staticSpritesheetAnimAdd(platGamepad, "platforms", "gamepad");
		platGamepad.x = 407;
		platGamepad.y = 398;
		settingsIcon.loadGraphic(Paths.Images('settings.png'));
		settingsIcon.screenCenter();
		settingsIcon.alpha = 0;
		settingsIcon.x = 1124;
		settingsIcon.y = 557;
		add(settingsIcon);
		FlxG.watch.add(this._save.data, "antialiasing", "antialiasing");
		FlxG.watch.add(this.gameCover, "x", "gameCover.x");
		FlxG.watch.add(this.gameCover, "y", "gameCover.y");
		FlxG.watch.add(this.gameChar, "x", "gameChar.x");
		FlxG.watch.add(this.gameChar, "y", "gameChar.y");
		FlxG.watch.add(this, "gameID", "gameID");
		FlxG.watch.add(this, "currentGame");
		FlxG.watch.add(this.gameStringID, "length", "amount of games");
		download.loadGraphic(Paths.Images('download.png'));
		download.x = 1124;
		download.y = 457;
		download.alpha = 0;
		add(download);
		FlxMouseEventManager.add(download);
		FlxMouseEventManager.setMouseClickCallback(download, downloadClicked);
		discord.loadGraphic(Paths.Images('discord.png'));
		discord.x = 1014;
		discord.y = 560;
		discord.alpha = 0;
		add(discord);
		add(gameCover);
		gameCover.alpha = 0;
		add(gameChar);
		gameChar.alpha = 0;
		add(leftArrow);
		leftArrow.alpha = 0;
		add(rightArrow);
		rightArrow.alpha = 0;
		add(playButton);
		playButton.alpha = 0;
		add(platPC);
		platPC.animation.play("pc");
		add(platMobile);
		platMobile.animation.play("mobile");
		add(platGamepad);
		platGamepad.animation.play("gamepad");
		fader.makeGraphic(1280, 720, FlxColor.BLACK);
		fader.screenCenter();
		fader.alpha = 0;
		FlxMouseEventManager.add(fader);
		FlxMouseEventManager.setMouseClickCallback(fader, exitSecondaryMenu);
		add(fader);
		settingsMenu.loadGraphic(Paths.Images("settingsMenu.png"));
		settingsMenu.alpha = 0;
		settingsMenu.screenCenter();
		add(settingsMenu);
		set_antiAliasingSwitch.alpha = 0;
		set_antiAliasingSwitch.x = 742;
		set_antiAliasingSwitch.y = 95;
		TechnicFunctions.spritesheet(set_antiAliasingSwitch, Paths.Images('switch'));
		TechnicFunctions.staticSpritesheetAnimAdd(set_antiAliasingSwitch, "switch", "on");
		TechnicFunctions.staticSpritesheetAnimAdd(set_antiAliasingSwitch, "switch", "off");
		add(set_antiAliasingSwitch);
		set_antiAliasingText.text = "Antialiasing";
		set_antiAliasingText.font = "Monsterrat";
		set_antiAliasingText.color = FlxColor.WHITE;
		set_antiAliasingText.size = 40;
		set_antiAliasingText.alpha = 0;
		set_antiAliasingText.x = 410;
		set_antiAliasingText.y = 95;
		add(set_antiAliasingText);
		set_windowSwitch.alpha = 0;
		set_windowSwitch.x = 742;
		set_windowSwitch.y = 150;
		TechnicFunctions.spritesheet(set_windowSwitch, Paths.Images('switch'));
		TechnicFunctions.staticSpritesheetAnimAdd(set_windowSwitch, "switch", "on");
		TechnicFunctions.staticSpritesheetAnimAdd(set_windowSwitch, "switch", "off");
		add(set_windowSwitch);
		set_windowText.text = "Open Game In Window";
		set_windowText.font = "Monsterrat";
		set_windowText.color = FlxColor.WHITE;
		set_windowText.size = 40;
		set_windowText.alpha = 0;
		set_windowText.x = 410;
		set_windowText.y = 150;
		add(set_antiAliasingText);
		controls.loadGraphic(Paths.Images("spinner.png"));
		controls.alpha = 0;
		controls.antialiasing = _save.data.antialiasing;
		add(controls);
		#if debug
		versionText.text = "launch-v" + version[0] + "." + version[1] + "." + version[2] + " (Debug Build)\n" + platform;
		#else
		versionText.text = "launch-v" + version[0] + "." + version[1] + "." + version[2] + "\n" + platform;
		#end
		versionText.font = "Monsterrat";
		versionText.color = FlxColor.WHITE;
		versionText.size = 15;
		versionText.alpha = 0.5;
		versionText.x = 5;
		versionText.y = 0;
		add(versionText);
	}

	function discordClicked(?_:FlxExtendedSprite)
	{
		if (!inSecondaryMenu)
		{
			redirect("https://discord.gg/up7VmmCPhn");
		}
	}

	function antialiasingSet():Void
	{
		title.antialiasing = _save.data.antialiasing;
		leftArrow.antialiasing = _save.data.antialiasing;
		rightArrow.antialiasing = _save.data.antialiasing;
		settingsIcon.antialiasing = _save.data.antialiasing;
		download.antialiasing = _save.data.antialiasing;
		gameCover.antialiasing = _save.data.antialiasing;
		gameChar.antialiasing = _save.data.antialiasing;
		settingsMenu.antialiasing = _save.data.antialiasing;
		platMobile.antialiasing = _save.data.antialiasing;
		platGamepad.antialiasing = _save.data.antialiasing;
		controls.antialiasing = _save.data.antialiasing;
		discord.antialiasing = _save.data.antialiasing;
	}

	function uiFaderIn(alphaVal:Float):Void
	{
		faderIn = FlxTween.tween(fader, {
			alpha: alphaVal
		}, 0.15, {
			type: FlxTweenType.ONESHOT
		});
		inSecondaryMenu = true;
	}

	function uiFaderOut():Void
	{
		faderOut = FlxTween.tween(fader, {
			alpha: 0,
		}, 0.15, {
			type: FlxTweenType.ONESHOT,
			onComplete: canClick
		});
	}

	function canClick(?_:FlxTween)
	{
		inSecondaryMenu = false;
		menuType = main;
	}

	function exitSecondaryMenu(?fader:FlxExtendedSprite):Void
	{
		if (menuType == settings)
		{
			if (!(settingsMenu.mouseOver || set_antiAliasingSwitch.mouseOver))
			{
				uiFaderOut();
				_save.flush();
				settingsMenu.alpha = 0;
				set_antiAliasingSwitch.alpha = 0;
				set_antiAliasingText.alpha = 0;
				// set_windowText.alpha = 0;
				// set_windowSwitch.alpha = 0;
			}
		}
		else if (menuType == controlsPC || menuType == controlsGamepad || menuType == controlsMobile)
		{
			if (!(controls.mouseOver))
			{
				uiFaderOut();
				loading = false;
				controls.alpha = 0;
			}
		}
	}

	function settingsIconClicked():Void
	{
		menuType = settings;
		if (!inSecondaryMenu)
		{
			uiFaderIn(0.45);
			settingsMenu.alpha = 1;
			set_antiAliasingSwitch.alpha = 1;
			set_antiAliasingText.alpha = 1;
			// set_windowText.alpha = 1;
			// set_windowSwitch.alpha = 1;
		}
	}

	function downloadClicked(download:FlxExtendedSprite):Void
	{
		if (!inSecondaryMenu)
		{
			downloadTimesClicked++;
			if (downloadTimesClicked == 1)
			{
				alert("This will download the latest version of the games and stuff shortcut. It is only availible for Windows and does not work on iPad. \nFor iPad users, click the share button and click on Add to Home Screen. \nClick the download button again to download the launcher for windows. Drag the file to your desktop for easy access and double click to run.\nIf a menu shows up saying \"Do you want to run?\", turn off Always Ask before opening this file and click run. \nDownload menu coming soon.");
			}
			else
			{
				redirect("https://gamesandstuffdl--letsgoaway.repl.co");
			}
		}
	}

	function currentGameSupportsPC():Bool
	{
		return gameSupportsPlatforms[gameID][0];
	}

	function currentGameSupportsMobile():Bool
	{
		return gameSupportsPlatforms[gameID][1];
	}

	function currentGameSupportsGamepad():Bool
	{
		return gameSupportsPlatforms[gameID][2];
	}

	function triggerPlatforms():Void
	{
		if (currentGameSupportsPC())
		{
			if (platPC.alpha == 1)
			{
				mobileInAnim();
			}
			else
			{
				platPC.alpha = 0;
				platPC.x = 107;
				platPC.y = 407;
				pcIn = FlxTween.tween(platPC, {
					alpha: 1,
					x: 207
				}, 0.20, {
					type: FlxTweenType.ONESHOT,
					onComplete: mobileInAnim
				});
				pcIn.start();
			}
		}
		else
		{
			platPC.x = 0;
			platPC.y = 0;
			mobileInAnim();
		}
	}

	function mobileInAnim(?_:FlxTween):Void
	{
		if (currentGameSupportsMobile())
		{
			if (platMobile.alpha == 1)
			{
				gamepadInAnim();
			}
			else
			{
				if (currentGameSupportsPC())
				{
					platMobile.x = 207;
					platMobile.y = 407;
					platMobile.alpha = 0;

					mobileIn = FlxTween.tween(platMobile, {
						alpha: 1,
						x: 307
					}, 0.20, {
						type: FlxTweenType.ONESHOT,
						onComplete: gamepadInAnim
					});
					mobileIn.start();
				}
				else
				{
					gamepadInAnim();
				}
			}
		}
		else
		{
			platMobile.x = 0;
			platMobile.y = 0;
			platMobile.alpha = 0;
			gamepadInAnim();
		}
	}

	function gamepadInAnim(?_:FlxTween):Void
	{
		if (currentGameSupportsGamepad())
		{
			if (platGamepad.alpha == 1) {}
			else
			{
				if (currentGameSupportsPC())
				{
					if (currentGameSupportsMobile())
					{
						platGamepad.x = 307;
						platGamepad.y = 398;
						platGamepad.alpha = 0;
						gamepadIn = FlxTween.tween(platGamepad, {
							alpha: 1,
							x: 407
						}, 0.20, {
							type: FlxTweenType.ONESHOT
						});
						gamepadIn.start();
					}
					else
					{
						platGamepad.x = 207;
						platGamepad.y = 398;
						platGamepad.alpha = 0;
						gamepadIn = FlxTween.tween(platGamepad, {
							alpha: 1,
							x: 307
						}, 0.20, {
							type: FlxTweenType.ONESHOT
						});
						gamepadIn.start();
					}
				}
			}
		}
		else
		{
			platGamepad.x = 0;
			platGamepad.y = 0;
			platGamepad.alpha = 0;
		}
	}

	function sound(i:String, ?wav:Bool):Void
	{
		if (!wav || wav == null)
		{
			if (s != null)
			{
				s.stop();
			}
			#if html5
			s = FlxG.sound.load(i + ".mp3"); // ogg files dont play on ios for some reason. at least for me they dont.
			s.play();
			#else
			#if flash
			s = FlxG.sound.load(i + "-flash.mp3"); // flash is wack and needs a specific sample rate
			s.play();
			#else
			s = FlxG.sound.load(i + ".ogg");
			s.play();
			#end
			#end
		}
		else
		{
			s = FlxG.sound.load(i + ".wav");
			s.play();
		}
	}

	function buttonClickFixFunc(tween:FlxTween):Void
	{
		startButtonFix = true;
	}

	function redirect(url:String):Void
	{
		#if html5
		Browser.window.location.href = url;
		#else
		FlxG.openURL(url);
		#end
	}

	// Mouse Related Scripts
	// Click
	function leftArrowClick(?leftArrow:FlxExtendedSprite):Void
	{
		if (!inSecondaryMenu)
		{
			if (gameID == 0)
			{
				gameID = gameStringID.length - 1;
			}
			else
			{
				gameID--;
			}
			gameID = gameID % gameStringID.length;
			togglePositions();
			sound("assets/sounds/left");
		}
	}

	function rightArrowClick(?rightArrow:FlxExtendedSprite):Void
	{
		if (!inSecondaryMenu)
		{
			sound("assets/sounds/right");
			gameID++;
			gameID = gameID % gameStringID.length;
			togglePositions();
		}
	}

	function goToGame(?_:Bool):Void
	{
		redirect("https://" + gameStringID[gameID] + ".letsgoaway.repl.co" + gameLinkEndTags[gameID]);
	}

	function playButtonClick(playButton:FlxExtendedSprite):Void
	{
		if (!inSecondaryMenu && startButtonFix && playButton.mouseOver)
		{
			sound("assets/sounds/play");
			_save.data.lastgameid = gameID;
			_save.flush(0, goToGame);
		}
	}

	function pcControlsMenu():Void
	{
		#if !html5
		menuType = controlsPC;
		uiFaderIn(0.45);
		loading = true;
		loadImageFromUrltoSprite(controls, "https://" + gameStringID[gameID] + ".letsgoaway.repl.co" + "/gasDATA/pc.png");
		#else
		JsLib.eval("openURL('https://" + gameStringID[gameID] + ".letsgoaway.repl.co" + "/gasDATA/pc.png', true, 'PC Controls')");
		#end
	}

	function mobileControlsMenu():Void
	{
		#if !html5
		menuType = controlsMobile;
		uiFaderIn(0.45);
		loading = true;
		loadImageFromUrltoSprite(controls, "https://" + gameStringID[gameID] + ".letsgoaway.repl.co" + "/gasDATA/mobile.png");
		#else
		JsLib.eval("openURL('https://" + gameStringID[gameID] + ".letsgoaway.repl.co" + "/gasDATA/mobile.png', true, 'Mobile Controls')");
		#end
	}

	function gamepadControlsMenu():Void
	{
		#if !html5
		menuType = controlsGamepad;
		uiFaderIn(0.45);
		loading = true;
		loadImageFromUrltoSprite(controls, "https://" + gameStringID[gameID] + ".letsgoaway.repl.co" + "/gasDATA/gamepad.png");
		#else
		JsLib.eval("openURL('https://" + gameStringID[gameID] + ".letsgoaway.repl.co" + "/gasDATA/gamepad.png', true, 'Gamepad Controls')");
		#end
	}

	function fadeChar(?_:FlxTween):Void
	{
		charFadeIn = FlxTween.tween(gameChar, {
			alpha: 1
		}, 0.25, {
			type: FlxTweenType.ONESHOT,
			onComplete: fadeCover
		});
		charFadeIn.start();
	}

	function fadeCover(?_:FlxTween):Void
	{
		coverFadeIn = FlxTween.tween(gameCover, {
			alpha: 1
		}, 0.25, {
			type: FlxTweenType.ONESHOT
		});
		coverFadeIn.start();
	}

	function togglePositions(?dontDoFades:Bool):Void
	{
		gameCover.alpha = 0;
		gameChar.alpha = 0;

		if (!dontDoFades || dontDoFades == null)
		{
			fadeChar();
		}
		else // EXTREMELY LARGE PERFORMANCE BOOST for when you click to start. I dont know why, i dont know why half of this stuff works but it just does.
			// Thats just the laws of programming i guess
		{
			gameChar.alpha = 1;
			gameCover.alpha = 1;
		}
		if (!(gamepadIn == null))
		{
			gamepadIn.cancel();
		}
		if (!(mobileIn == null))
		{
			mobileIn.cancel();
		}
		if (!(pcIn == null))
		{
			pcIn.cancel();
		}
		triggerPlatforms();
		gameCover.animation.play(gameID + "game");
		gameChar.animation.play(gameID + "game");
		if (gameID == 0) // sm64
		{
			gameCover.x = -243;
			gameCover.y = -118;
			gameChar.x = 57;
			gameChar.y = -100;
		}
		else if (gameID == 1)
		{
			gameCover.x = -170;
			gameCover.y = -92;
			gameChar.x = 29;
			gameChar.y = -100;
		}
		else if (gameID == 2)
		{
			gameCover.x = -244;
			gameCover.y = -86;
			gameChar.x = 121;
			gameChar.y = -94;
		}
		else if (gameID == 3)
		{
			gameCover.x = -243;
			gameCover.y = -114;
			gameChar.x = 178;
			gameChar.y = -114;
		}
		else if (gameID == 4) // doom 2
		{
			gameCover.screenCenter(X);
			gameCover.y = -114;
		}
		else if (gameID == 5)
		{
			gameCover.x = -465;
			gameCover.y = -101;
			gameChar.x = 543;
			gameChar.y = -143;
		}
		else if (gameID == 6) // mc
		{
			gameCover.x = -232;
			gameCover.y = -116;
			gameChar.x = 11;
			gameChar.y = -99;
		}
		else if (gameID == 7)
		{
			gameCover.x = -176;
			gameCover.y = -113;
			gameChar.x = 40;
			gameChar.y = -110;
		}
		else
		{
			gameCover.x = -243;
			gameCover.y = -114;
			gameChar.x = 178;
			gameChar.y = -114;
		}
	}

	// Hover

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		currentGame = gameStringID[gameID];
		gamepad = FlxG.gamepads.lastActive;
		if (gamepad != null && !inSecondaryMenu)
		{
			if (gamepad.justReleased.DPAD_LEFT)
			{
				leftArrowClick(leftArrow);
			}
			if (gamepad.pressed.DPAD_LEFT)
			{
				gamepad_left = true;
			}
			else
			{
				gamepad_left = false;
			}
			if (gamepad.justReleased.DPAD_RIGHT)
			{
				rightArrowClick(rightArrow);
			}
			if (gamepad.pressed.DPAD_RIGHT)
			{
				gamepad_right = true;
			}
			else
			{
				gamepad_right = false;
			}
			if (gamepad.justReleased.A)
			{
				if (started)
				{
					playButtonClick(playButton);
					_save.flush();
				}
				else
				{
					mouseDown = true;
					started = true;
				}
			}
		}
		else
		{
			gamepad_left = false;
			gamepad_right = false;
		}
		if (FlxG.mouse.justReleased)
		{
			mouseDown = true;
			started = true;
		}
		else
		{
			mouseDown = false;
		}
		if (FlxG.keys.justReleased.LEFT)
		{
			if (started && !inSecondaryMenu)
			{
				leftArrowClick();
			}
		}
		if (FlxG.keys.justReleased.F)
		{
			#if windows
			winAlert("test", "please", "error");
			#end
		}
		if (FlxG.keys.justReleased.D)
		{
			#if html5
			JsLib.eval("openURL('https://gamesandstuffdevver.letsgoaway.repl.co', true);");
			#end
		}
		if (FlxG.keys.justReleased.RIGHT)
		{
			if (started && !inSecondaryMenu)
			{
				rightArrowClick();
			}
		}
		if (FlxG.keys.justReleased.ENTER || FlxG.keys.justReleased.SPACE)
		{
			if (started && !inSecondaryMenu)
			{
				playButtonClick(playButton);
				_save.flush();
			}
		}

		/**
		 * nice feedback thingy just test it trust me
		 */
		function uiGrowThingy(sprite:FlxExtendedSprite, maxGrow:Float, bool:Bool)
		{
			if (bool)
			{
				if (((sprite.scale.x + sprite.scale.y) / 2) < maxGrow)
				{
					sprite.scale.x += (elapsed * (0.11 * 60));
					sprite.scale.y += (elapsed * (0.11 * 60));
				}
			}
			else
			{
				if (((sprite.scale.x + sprite.scale.y) / 2) > 1)
				{
					sprite.scale.x -= (elapsed * (0.11 * 60));
					sprite.scale.y -= (elapsed * (0.11 * 60));
				}
				else
				{
					sprite.scale.x = 1;
					sprite.scale.y = 1;
				}
			}
		}

		if (started)
		{
			uiGrowThingy(leftArrow, 1.15, !inSecondaryMenu ? (FlxG.keys.pressed.LEFT || gamepad_left || leftArrow.mouseOver) : false);
			uiGrowThingy(rightArrow, 1.15, !inSecondaryMenu ? (FlxG.keys.pressed.RIGHT || gamepad_right || rightArrow.mouseOver) : false);
			uiGrowThingy(platGamepad, 1.1, !inSecondaryMenu ? (platGamepad.mouseOver) : false);
			uiGrowThingy(platPC, 1.1, !inSecondaryMenu ? (platPC.mouseOver) : false);
			uiGrowThingy(platMobile, 1.1, !inSecondaryMenu ? (platMobile.mouseOver) : false);
			uiGrowThingy(download, 1.05, !inSecondaryMenu ? (download.mouseOver) : false);
			uiGrowThingy(settingsIcon, 1.05, !inSecondaryMenu ? (settingsIcon.mouseOver) : false);
			uiGrowThingy(discord, 1.05, !inSecondaryMenu ? (discord.mouseOver) : false);
			if (!inSecondaryMenu)
			{
				if (leftArrow.mouseOver || rightArrow.mouseOver || playButton.mouseOver || download.mouseOver)
				{
					Mouse.cursor = "button";
				}
				else if (discord.mouseOver)
				{
					Mouse.cursor = "button";
					if (FlxG.mouse.justReleased)
					{
						discordClicked();
					}
				}
				else if (settingsIcon.mouseOver)
				{
					Mouse.cursor = "button";
					if (FlxG.mouse.justReleased)
					{
						settingsIconClicked();
					}
				}
				else if (platPC.mouseOver)
				{
					if (currentGameSupportsPC())
					{
						Mouse.cursor = "button";
					}
					if (FlxG.mouse.justReleased)
					{
						pcControlsMenu();
						controls.loadGraphic(Paths.Images("spinner.png"));
					}
				}
				else if (platMobile.mouseOver)
				{
					if (currentGameSupportsMobile())
					{
						Mouse.cursor = "button";
					}
					if (FlxG.mouse.justReleased)
					{
						mobileControlsMenu();
						controls.loadGraphic(Paths.Images("spinner.png"));
					}
				}
				else if (platGamepad.mouseOver)
				{
					if (currentGameSupportsGamepad())
					{
						Mouse.cursor = "button";
					}
					if (FlxG.mouse.justReleased)
					{
						gamepadControlsMenu();
						controls.loadGraphic(Paths.Images("spinner.png"));
					}
				}
				else
				{
					Mouse.cursor = "arrow";
				}
			}
			else
			{
				if (set_antiAliasingSwitch.mouseOver)
				{
					Mouse.cursor = "button";
					if (FlxG.mouse.justReleased)
					{
						_save.data.antialiasing = !(_save.data.antialiasing);
					}
				}
				else
				{
					Mouse.cursor = "arrow";
				}
			}
			if (!menuLoaded)
			{
				menuLoaded = true;
			}
			if (!clicksoundstarted)
			{
				// clickedToStart
				sound("assets/sounds/click");
				togglePositions(true);
				FlxTween.tween(title, {y: 0, "scale.x": 0.3, "scale.y": 0.3}, 0.5, {type: FlxTweenType.PERSIST, onComplete: buttonClickFixFunc});
				clicksoundstarted = true;
				leftArrow.alpha = 1;
				rightArrow.alpha = 1;
				playButton.alpha = 1;
				download.alpha = 1;
				settingsIcon.alpha = 1;
				discord.alpha = 1;
			}
			// else
			// {
			// if (titlesize > 0.3)
			// {
			// titlesize = titlesize - 0.01;
			// title.scale.set(titlesize, titlesize);
			// }
			// }

			if (!maxClickAlpha) // fade out animation for the "click to start" text. smexy ui = smooth experience. (hopefully)
			{
				if (!(clicktostart.alpha == 0))
				{
					clicktostart.alpha -= 0.05;
				}
				else
				{
					maxClickAlpha = true;
					remove(clicktostart); // cleans up memory by juuust a little but performance is cool
				}
			}
		}
		else
		{
			platPC.alpha = 0;
			platMobile.alpha = 0;
			platGamepad.alpha = 0;
		}
		if (settingsMenu.alpha == 1)
		{
			if (_save.data.antialiasing)
			{
				set_antiAliasingSwitch.animation.play('on');
			}
			else
			{
				set_antiAliasingSwitch.animation.play('off');
			}
			if (_save.data.openInWindow)
			{
				set_windowSwitch.animation.play('on');
			}
			else
			{
				set_windowSwitch.animation.play('off');
			}
		}

		if (loading)
		{
			if (controls.width == 64 && controls.height == 64)
			{
				controls.angle = (controls.angle + 10) % 360;
			}
			else if (controls.width == 0 && controls.height == 0)
			{
				winAlert("The image failed to load.\nYou are not connected to the internet, or we stuffed something up.\nIn that case, let us know at https://discord.com/invite/up7VmmCPhn.",
					"Error", "error");
			}
			else
			{
				loading = false;
				controls.angle = 0;
			}
			controls.screenCenter();
			controls.alpha = 1;
		}

		TechnicFunctions.checkForFullScreenToggle();
		antialiasingSet();
	}
}
