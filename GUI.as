package
{
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class GUI extends Screen
	{
		var game 	 :World;
		var stScreen :Screen;
		var dyScreen :Screen;
		
		var back	:MovieClip;
		var path	:MovieClip;
		var counter	:MovieClip;
		var total	:MovieClip;
		
		var pathEnabled		:Boolean;
		var counterEnabled  :Boolean;
		
		var mousePress		:Boolean;
		var mouseMoonOver 	:Boolean;
		var mouseMoonPress 	:Boolean;
		
		var starStack		  :Number;
		var maxTranslations   :Number;
		var pressCounter	  :Number;
		var pressCounterDelay :Number;
		var totalTranslations :Number;
		
		
		public function GUI()
		{
			game = World(Main.game);
			stScreen = new Screen();
			dyScreen = new Screen();
			addChild(dyScreen);
			addChild(stScreen);
			
			pathEnabled =  	 false;
			counterEnabled = false;
			mousePress =	 false;
			mouseMoonOver =  false;
			mouseMoonPress = false;
			
			starStack =		  	0;
			maxTranslations = 	40;
			pressCounter =		0;
			pressCounterDelay = 10;
			totalTranslations = 0;
			
			path = new MovieClip();
				path.alpha = 0;
				dyScreen.addChild(path);
			counter = new RadialCounter(dyScreen,360,game.moon.radius*4/3,5,0xffffff);
				counter.x = game.moon.x;
				counter.y = game.moon.y;
			back = new MovieClip();
				back.alpha = 0;
				back.graphics.lineStyle(1,0x000000);
				back.graphics.beginFill(0x000000);
				back.graphics.drawRect(-Main.width,-Main.height,Main.width*2,Main.height*2);
				back.addEventListener(MouseEvent.MOUSE_DOWN,backgroundPressed);
				back.addEventListener(MouseEvent.MOUSE_UP,backgroundUnpressed);
				dyScreen.addChild(back);
			total = new MovieClip();
				stScreen.addChild(total);
			
			game.moon.addEventListener(MouseEvent.MOUSE_DOWN,moonClicked);
			game.moon.addEventListener(MouseEvent.MOUSE_UP,moonUnclicked);
			game.moon.addEventListener(MouseEvent.MOUSE_OVER,moonOver);
			game.moon.addEventListener(MouseEvent.MOUSE_OUT,moonOut);
			
			dyScreen.cam = game.camera;
		}
		
		function backgroundPressed(e :Event)  { mousePress = true;		}
		function backgroundUnpressed(e :Event){ mousePress = false;		}
		function moonClicked(e :Event)
		{
			mouseMoonPress = true;
			pushStars();
			sitchEnabledPath();
			backgroundUnpressed(null);
		}
		function moonUnclicked(e :Event)	  { mouseMoonPress = false; }
		function moonOver(e :Event)			  { mouseMoonOver = true;	}
		function moonOut(e :Event)			  { mouseMoonOver = false; }
		
		
		function sitchEnabledPath()
		{
			pathEnabled = !pathEnabled;
			
			Utils.blink(game.moon);
			
			if(pathEnabled) Utils.fade(path,0.05);
			else 	Utils.fade(path);
		}
		function pushStars()
		{
			var stars = starStack;
			if(starStack + Star.objects.length > Star.maxObjectsTrail)
				stars -= starStack + Star.objects.length - Star.maxObjectsTrail;
				
			var ang =	 Math.random()*Math.PI*2;
			var angAdd = Math.PI*2/stars;
			
			var baseForce = 50;
			var forceVar =  10;
			
			for(var i=0; i<stars; i++)
			{
				var force = baseForce + Utils.random(-forceVar,forceVar);
				var obj = new Star(true,World(Main.game).player);
					World(Main.game).back.addChild(obj);
					obj.x = World(Main.game).moon.x;
					obj.y = World(Main.game).moon.y;
					obj.avelx = Math.cos(ang + angAdd*i)*force;
					obj.avely = Math.sin(ang + angAdd*i)*force;
			}
			starStack -= stars;
		}
		function pullStars()
		{
			var stars = Star.objects;
			for(var i=0; i<stars.length; i++)
			{
				Star(stars[i]).target =  new Point(game.mouseX,game.mouseY);
				Star(stars[i]).callback = function(){ starStack += 1; }
			}
		}
		function sendToLuna()
		{
			var stars = Star.objects;
			for(var i=0; i<stars.length; i++)
			{
				Star(stars[i]).callback = null;
				if(Star(stars[i]).trailEnabled) Star(stars[i]).target = World(Main.game).player;
				else							Star(stars[i]).target = null;
			}
		}
		function createPath()
		{
			var obj = new MovieClip();
				path.addChild(obj);
				obj.graphics.lineStyle(1,0x9C0AE5);
				obj.graphics.moveTo(game.player.lastx,game.player.lasty);
				obj.graphics.lineTo(game.player.x,game.player.y);
				obj.alpha = 0.9999;
				Utils.fade(obj,-0.001,function(){ Utils.kill(obj); });
		}
		function updateCounter()
		{
			var translations = 	game.player.translations;
			if(translations > maxTranslations) translations = maxTranslations;
			var startingAngle =	game.player.startingAngle;
			var rotationAngle =	game.player.currentAngle;
			var rotatingRight = game.player.rotatingRight;
				
			var number =	rotationAngle - startingAngle;
			if(number < 0)  number = 360 + number;
			if(!rotatingRight) number = 360 - number;
			
			if(rotatingRight) 	counter.scaleX = Math.abs(counter.scaleX);
			else				counter.scaleX = -Math.abs(counter.scaleX);
			
			counter.rotation = startingAngle;
			counter.number = number + translations*360;
		}
		function updateTotalTranslations()
		{
			if(totalTranslations < game.player.totalTranslations)
			{
				var dif = game.player.totalTranslations - totalTranslations;
				
				var lineHeight = 10;
				var lineSpace = 3;
				var space =  4;
				var gutter = 10;
				var maxLines = 200;
				
				for(var i=0; i<dif; i++)
				{
					var n = (totalTranslations+i)%maxLines;
					
					var posx = gutter + n*lineSpace + Math.floor(n/5)*space;
					var posy = gutter + (space+lineHeight)*Math.floor((totalTranslations+i)/maxLines);
					
					var obj = new MovieClip();
						obj.graphics.lineStyle(1,0xffffff);
						obj.graphics.moveTo(posx,posy);
						obj.graphics.lineTo(posx,posy+lineHeight);
						obj.alpha = 0.99;
						total.addChild(obj);
						Utils.fade(obj,-0.05,null,0.5);
				}
				totalTranslations = game.player.totalTranslations;
			}
		}
		function setBackgoundFocus()
		{
			if(pressCounter > 0)
			{
				pressCounter = pressCounterDelay;
				game.camera.x = Main.mouse.x - Main.width/2;
				game.camera.y = Main.mouse.y - Main.height/2;
			}
		}
		function freeWorldCamera()
		{
			pressCounter += 1;
			
			if(pressCounter > pressCounterDelay/2)
			{
				pressCounter = pressCounterDelay;
				
				var mouse = new Point(game.mouseX,game.mouseY);
				var dist = Utils.dist(mouse,game.moon);
				var ang = Utils.ang(mouse,game.moon);
				
				game.camera.x += Math.cos(ang)*dist;
				game.camera.y += Math.sin(ang)*dist;
			}
		}
		function lockWorldCamera()
		{
			pressCounter -= 1;
			if(pressCounter < 0)
			{
				pressCounter = 0;
				
				game.camera.x = game.moon.x;
				game.camera.y = game.moon.y;
			}
		}
		function enableCounter()
		{
			mousePress = 	false;
			counterEnabled = true;
		}
		function disableCounter()
		{
			counterEnabled = false;
		}
		function fadeOutCounter()
		{
			Utils.fade(counter);
		}
		function fadeInCounter()
		{
			Utils.fade(counter,0.05);
		}
		function fadeOutTotalTranslations()
		{
			Utils.fade(total);
		}
		function fadeInTotalTranslations()
		{
			Utils.fade(total,0.05);
		}
		function GUI_display()
		{
			createPath();
			
			if(mouseMoonOver) enableCounter();
			else			  disableCounter();
			
			if(game.player.onGround)
			{
				fadeOutCounter();
				fadeOutTotalTranslations();
			}else{
				if(counterEnabled)
				{
					updateCounter();
					fadeInCounter();
				}else
					fadeOutCounter();
				
				fadeInTotalTranslations();
				updateTotalTranslations();
			}
					
			if(mousePress)
			{
				pullStars();
				Star.drag();
				setBackgoundFocus();
			}else{
				Star.release();
				sendToLuna();
			}
			
			if(mouseMoonPress) freeWorldCamera();
			else			   lockWorldCamera();
		}
		override public function display()
		{
			GUI_display();
			BaseMc_display();
		}
	}
}
