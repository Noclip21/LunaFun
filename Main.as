package
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Main extends MovieClip
	{
		public static var gui	:MovieClip;
		public static var game	:MovieClip;
		public static var key	:KeyObject;
		
		
		static var _PAUSE	:Boolean;
		static var _TIME	:Number;
		static var _objects :Array;
		static var _screens	:Array;
		static var _stage	:Object;
		
		
		public static function get PAUSE()	{ return _PAUSE;   }
		public static function get TIME()	{ return _TIME;	   }
		public static function get objects(){ return _objects; }
		public static function get screens(){ return _screens; }
		
		public static function set PAUSE(n)	 { _PAUSE = n;		 }
		public static function set TIME(n)	 { _TIME = n;		 }
		public static function set objects(n){ _objects.push(n); }
		public static function set screens(n){ _screens.push(n); }
		
		public static function get width() { return _stage.stageWidth;  }
		public static function get height(){ return _stage.stageHeight; }
		public static function get mouse(){ return new Point(_stage.mouseX,_stage.mouseY); }
		
		
		public function Main()
		{
			key  = new KeyObject(stage);
								
			_PAUSE 		= false;
			_TIME 		= 1.0;
			_objects 	= new Array();
			_screens	= new Array();
			_stage		= stage;
			
			stage.addEventListener(Event.ENTER_FRAME,eventEnterFrame);
			
			// Begin code
			
			game = new World();
			gui =  new GUI();
				addChild(game);
				addChild(gui);
				
			swapChildren(game,gui);
			
			// End code
		}
		function eventEnterFrame(e :Event)
		{
			for(var i=0; i<_objects.length; i++)
				_objects[i].display();
		}
	}
	
}
