package 
{

	import flash.display.MovieClip;
	import flash.geom.Point;


	public class Star extends BaseMc
	{

		public static var objects :Array = new Array();
		public static var maxObjects 	  :Number  = 150;
		public static var maxObjectsTrail :Number = 50;
		
		public static var starMinAlpha    :Number = 0.5;
		public static var starMaxAlpha    :Number = 1;
		public static var starBaseAlphaVar:Number = 0.2;

		var baseAlpha			:Number;
		public var trailEnabled	:Boolean;
		public var target		:Object;
		public var callback 	:Function;


		static var maxVel:Number = 10;
		static var friction:Number = 0.1;
		static var maxDist:Number = 1000;
		static var minDist:Number = 100;

		static var onDrag:Boolean = false;
		
		public static function get limit(){ return objects.length > maxObjects; }


		public function Star(enableTrail :Boolean = false,setTarget :MovieClip = null,defCallback :Function= null)
		{
			trailEnabled =  enableTrail;
			target =		setTarget;
			callback =		defCallback;
			objects.push(this);
			
			alpha = baseAlpha = Utils.random(starMinAlpha,starMaxAlpha);
		}

		public static function drag()
		{
			friction = World(Main.game).friction;
			onDrag = true;
		}
		public static function release()
		{
			friction = 0.1;
			onDrag = false;
		}
		function limitVel()
		{
			if(Math.abs(avelx) > maxVel)
				if(avelx > 0) avelx = maxVel;
				else		  avelx = -maxVel;
			if(Math.abs(avely) > maxVel)
				if(avely > 0) avely = maxVel;
				else		  avely = -maxVel;
		}
		function borders()
		{
			if(x > maxDist || x < - maxDist)
			{
				if (x > maxDist) x = maxDist;
				else			 x = -maxDist;
				avelx *= -1;
			}
			if(y > maxDist || y < - maxDist)
			{
				if(y > maxDist) y = maxDist;
				else 			y = -maxDist;
				avely *= -1;
			}
		}
		function addFriction()
		{
			avelx *=  1 - friction;
			avely *=  1 - friction;
		}
		function blink()
		{
			if(Math.random() * 100 < 1)
				alpha = baseAlpha + Utils.random( - starBaseAlphaVar,starBaseAlphaVar);
		}
		function follow()
		{
			var ang = Utils.ang(this,target);
			avelx += Math.cos(ang);
			avely += Math.sin(ang);
			
			if(Utils.dist(this,target) < 50)
			{
				Utils.removeObject(this,objects);
				if(callback != null) callback();
				Utils.kill(this);
			}
		}
		function trail()
		{
			if(lastx && lasty && parent)
			{
				var obj = new MovieClip();
					parent.addChild(obj);
					obj.graphics.lineStyle(1,0xffffff,alpha);
					obj.graphics.moveTo(x,y);
					obj.graphics.lineTo(lastx,lasty);
					obj.alpha = 0.99;
					Utils.fade(obj,-0.1,function(){ Utils.kill(obj); });
			}
		}
		function Star_display()
		{
			if(onDrag)
			{
				borders();
				limitVel();
			}
			
			if(target)		 follow();
			if(trailEnabled) trail();
			
			addFriction();
			
			blink();
		}
		override public function display()
		{
			Star_display();
			BaseMc_display();
		}
	}

}