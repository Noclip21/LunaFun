package
{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class Luna extends BaseMc
	{
		
		var world :World;
		var moon  :Moon;
		
		var _onGround 	 :Boolean;
		var spacePressed :Boolean;
		var force 		 :Number;
		var forceCoef	 :Number;
		var forceMax	 :Number;
		var forceMin	 :Number;
		var dashf		 :Number;
		
		var folded 			   :Boolean;
		var prevRotation 	   :Number;
		var _translations 	   :Number;
		var _totalTranslations :Number;
		var _startingAngle	   :Number;
		var _rotatingRight	   :Boolean;
		
		
		public function get onGround()			{ return _onGround;				} 
		public function get translations()		{ return _translations; 		}
		public function get totalTranslations() { return _totalTranslations;	}
		public function get startingAngle()		{ return angle(_startingAngle); }
		public function get currentAngle()		{ return angle(rotation);		}
		public function get rotatingRight()		{ return _rotatingRight;		}
		
		
		
		public function Luna(target :World,layer :MovieClip)
		{
			layer.addChild(this);
			world = target;
			moon = world.moon;
			
			_onGround = 	false;
			spacePressed = 	false;
			forceCoef =		0.75;
			forceMax =		11.25;
			forceMin =		5;
			force = 		forceMin;
			dashf =			0.225;
			
			folded = 			true;
			prevRotation = 		rotation;
			_totalTranslations = 0;
			_translations = 	 0;
			_startingAngle = 	rotation;
			_rotatingRight =	false;
		}
		
		function angle(n :Number)
		{
			var ang =	n;
			if(ang < 0)	ang = 360 + ang;
			return ang;
		}
		
		function anim(frame)
		{
			/*
			* Animation sheet
			*	land
			* 	landFolded
			*	landUnfolded
			* 	charging
			* 	jumping
			* 	gliding
			*/
			gotoAndStop(frame);
		}
		
		function idle()
		{
			spacePressed = false;
		}
		function charge()
		{
			force += forceCoef;
			if(force > forceMax) force = forceMax;
			spacePressed = true;
			anim('charging');
		}
		function jump()
		{
			var ang = Utils.ang(moon,this);
				avelx += force*Math.cos(ang);
				avely += force*Math.sin(ang);
				
			dash(dashf*scaleX);
			if(force <= forceMin + (forceMax - forceMin)/2)
				dash(10*dashf*scaleX);
				
			_startingAngle = rotation;
			
			force = forceMin;
			_onGround = false;
			spacePressed = false;
			folded = true;
			anim('jumping');
		}
		function land()
		{
			var point = moon.landPoint(this);
				x = point.x;
				y = point.y;
			avelx = 0;
			avely = 0;
			
			
			_translations = 0;
			_startingAngle = rotation;
			
			
			_onGround = true;
			if(folded)  anim('landFolded');
			else		anim('landUnfolded');
		}
		function glide()
		{
			var vectorGravity = moon.gravity(new Point(x,y));
				avelx += vectorGravity.x;
				avely += vectorGravity.y;
				
				
			if((rotation > 0 && prevRotation > 0) ||
			   (rotation < 0 && prevRotation < 0))
			{
				if(rotation > prevRotation) _rotatingRight = true;
				if(rotation < prevRotation) _rotatingRight = false;
			}
			if((rotation > _startingAngle && prevRotation < _startingAngle && _rotatingRight) ||
			   (rotation < _startingAngle && prevRotation > _startingAngle && !_rotatingRight))
			{
				_totalTranslations += 1;
				_translations += 	  1;
			}
			
			
			if(Utils.dist(moon,this) >= Main.height)
			{
				folded = false;
				anim('gliding');
			}
		}
		
		function stars()
		{
			if(Math.random()*100 < _translations*0.5 && !Star.limit)
			{
				var star = new Star();
					star.x = Utils.random(x-50,x+50);
					star.y = Utils.random(y-50,y+50);
					star.avelx = avelx*0.1;
					star.avely = avely*0.1;
					world.back.addChild(star);
			}
		}
		function dash(f :Number)
		{
			if(Utils.dist(moon,this) < moon.quitDistance)
			{
				var ang90 = Utils.ang(moon,this) + Math.PI/2;
					avelx += f*Math.cos(ang90);
					avely += f*Math.sin(ang90);
			}
		}
		
		function Luna_display()
		{
			if(_onGround)
			{
				if(Main.key.isDown(32))// space
					charge();
				else
					if(spacePressed)
						jump();
					else
						idle();
			}else{
				glide();
				if(_translations >= 1)
					stars();
				if(Main.key.isDown(39)) // right
					dash(dashf);
				if(Main.key.isDown(37)) // left
					dash(-dashf);
				if(moon.onSurface(this))
					land();
			}
			
			if(Main.key.isDown(39)) // right
				scaleX = Math.abs(scaleX);
			if(Main.key.isDown(37)) // left
				scaleX = -Math.abs(scaleX);
			
			prevRotation = rotation;
			rotation = Utils.ang(moon,this)*180/Math.PI + 90;
		}
		override public function display()
		{
			Luna_display();
			BaseMc_display();
		}
	}
	
}
