package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class BaseMc extends MovieClip
	{
		var _avelx :Number = 0;
		var _avely :Number = 0;
		
		var _lastx :Number = 0;
		var _lasty :Number = 0;
		
		
		var key = Main.key;
		
		
		public function get avelx(){ return _avelx; }
		public function get avely(){ return _avely; }
		public function get lastx(){ return _lastx; }
		public function get lasty(){ return _lasty; }
		
		public function set avelx(n){ _avelx = n; }
		public function set avely(n){ _avely = n; }
		
		
		
		// animation vars
		
		public var locked :Boolean = false;
		
		
		var minAlpha;
		var maxAlpha;
		var offsetAlpha;
		var callbackAlpha;
		var pointMove;
		var easyMove;
		var callbackMove;
		var resizeSize;
		var resizeEasy;
		var resizeCallback;
		var blinkAlpha;
		var blinktimer;
		var blinkCount;
		var blinkCallback;
		
		
		
		public function BaseMc()
		{
			Main.objects = this;
			_lastx = x;
			_lasty = y;
		}
		
		
		public function BaseMc_display()
		{
			if(!locked)
			{
				_lastx = x;
				_lasty = y;
				
				x += _avelx*Main.TIME;
				y += _avely*Main.TIME;
			}
		}
		public function display()
		{
			BaseMc_display();
		}
		
	}
	
}
