package
{
	import flash.display.MovieClip;
	
	public class Screen extends BaseMc
	{
		var _screenW :Number;
		var _screenH :Number;
		var _cam 	 :Camera;
		
		
		public function get screenW(){ return _screenW;   }
		public function get screenH(){ return _screenH;   }
		public function get cam()	 { return _cam;		  }
		public function get camDel() { return _cam.delay; }
		
		public function set camDel(n){ _cam.delay = n; }
		public function set cam(n)
		{
			Utils.kill(_cam);
			_cam = new Camera(this,n);
		}
											   
											   
		public function Screen(w :Number = -1,h :Number = -1)
		{
			if(w < 0 || h < 0)
			{
				w = Main.width;
				h = Main.height;
			}
			
			_screenW = w;
			_screenH = h;
			
			var msk = new MovieClip();
				with(msk)
				{
					graphics.beginFill(0x333333);
					graphics.drawRect(0,0,w,h);
					graphics.endFill();
				}
			mask = msk;
				
			Main.screens = this;
		}
	}
	
}
