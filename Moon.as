package
{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class Moon extends BaseMc
	{
		var _radius		  :Number;
		var _gravity	  :Number;
		var _quitDistance :Number;
		
		
		public function get radius()	  { return _radius;		  }
		public function get quitDistance(){ return _quitDistance; }
		
		
		public function Moon()
		{
			_radius = 		60;
			_gravity =		0.75;
			_quitDistance = _radius*3;
		}
		
				
		public function gravity(p :Point)
		{
			var ang = Utils.ang(p,this);
			return new Point(_gravity*Math.cos(ang),_gravity*Math.sin(ang));
		}
		public function onSurface(obj :BaseMc)
		{
			return Utils.dist(this,new Point(obj.x+avelx,obj.y+avely)) <= _radius;
		}
		public function landPoint(obj :MovieClip)
		{
			var ang = Utils.ang(this,obj);
				var posx = x + _radius*Math.cos(ang);
				var posy = y + _radius*Math.sin(ang);
			return new Point(posx,posy);
		}
	}
	
}
