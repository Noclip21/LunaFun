package
{
	import flash.display.MovieClip;
	
	public class Camera extends BaseMc
	{
		var screen  :Screen;
		var _target :MovieClip;
		var _delay	:Number;
		var W		:Number;
		var H		:Number;
		
		public function get target(){ return _target; }
		public function get delay() { return _delay;  }
		
		public function set target(n){ _target = n; }
		public function set delay(n) { _delay = n;  }
		
		
		public function Camera(scr :Screen,obj :MovieClip,del :Number = 0.2)
		{
			
			screen = scr;
			_target = obj;
			_delay = del;
			W = scr.screenW;
			H = scr.screenH;
			
			
			Main.objects = this;
		}
		
		override public function display()
		{
			_avelx = (W/2 - _target.x - screen.x)*_delay;
			_avely = (H/2 - _target.y - screen.y)*_delay;
			
			
			/*if(screen.x + _avelx < -(screen.width - W))
			{
				screen.x = -(screen.width - W);
				_avelx = 0;
			}
			if(screen.x + _avelx > 0)
			{
				screen.x = 0;
				_avelx = 0;
			}
			if(screen.y + _avely < -(screen.height - H))
			{
				screen.y = -(screen.height - H);
				_avely = 0;
			}
			if(screen.y + _avely > 0)
			{
				screen.y = 0;
				_avely = 0;
			}*/
			
			screen.x += _avelx;
			screen.y += _avely;
		}

	}
	
}
