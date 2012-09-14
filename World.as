package
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.BlendMode;
	
	public class World extends Screen
	{
		
		var _front :MovieClip;
		var _mid   :MovieClip;
		var _back  :MovieClip;
		
		public var moon   :Moon;
		public var player :Luna;
		public var camera :MovieClip;
		
		var _stars :Array;
		
		var friction :Number;
		
		
		public function get front(){ return _front }
		public function get mid()  { return _mid   }
		public function get back() { return _back  }
		
		
		public function World()
		{
			_front = new MovieClip();
			_mid = 	 new MovieClip();
			_back =  new MovieClip();
				addChild(_back);
				addChild(_mid);
				addChild(_front);
			
			
			_stars = new Array();
			
			
			moon = new Moon();
				_mid.addChild(moon);
				moon.x = 0;
				moon.y = 0;
				
			player = new Luna(this,_front);
				player.x = moon.x;
				player.y = moon.y - 100;
				player.scaleX = player.scaleY = 0.75;
				
				
			camera = new MovieClip();
				camera.x = moon.x;
				camera.y = moon.y;
				cam = camera;
			
			
			friction = 0.0005;
		}
		function World_display()
		{
			player.avelx *= 1 - friction;
			player.avely *= 1 - friction;
		}
		override public function display()
		{
			World_display();
			BaseMc_display();
		}

	}
	
}
