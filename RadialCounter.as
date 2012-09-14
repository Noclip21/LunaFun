package
{
	import flash.display.MovieClip;
	import flash.display.BlendMode;
	
	public class RadialCounter extends BaseMc
	{
		
		var value	:Number;
		var bValue  :Number;
		var radius 	:Number;
		var bRadius :Number;
		var mRadius :Number;
		
		var color :uint;
		
		var border 		:MovieClip;
		var borderMask 	:MovieClip;
		var innerMask	:MovieClip;
		
		
		public function get number(){ return value; };
		public function set number(n){ value = n; drawCounter(); }
		
		
		public function RadialCounter(target :MovieClip,baseValue :Number = 360,baseRadius :Number = 50,radiusMultiplier :Number = 10,defaultColor :uint = 0xffffff)
		{
			target.addChild(this);
			
			bValue =  baseValue;
			bRadius = baseRadius;
			mRadius = radiusMultiplier;
			
			color = defaultColor;
			
			border = 	 new MovieClip();
			borderMask = new MovieClip();
			innerMask =  new MovieClip();
				addChild(border);
				addChild(borderMask);
				border.addChild(innerMask);
				
				border.blendMode = 	  BlendMode.LAYER;
				border.mask = 		  borderMask;
				innerMask.blendMode = BlendMode.ERASE;
		}
		
		function changeRadius()
		{
			radius = Math.floor(value/bValue)*mRadius + bRadius;
		}
		function drawBorder()
		{
			border.graphics.clear();
			border.graphics.beginFill(color);
			border.graphics.drawCircle(0,0,radius);
			border.graphics.endFill();
			
			innerMask.graphics.clear();
			if(radius-bRadius > 0)
			{
				innerMask.graphics.beginFill(color);
				innerMask.graphics.drawCircle(0,0,radius-mRadius);
				innerMask.graphics.endFill();
			}
		}
		function drawMask()
		{
			var rest = value%bValue;
			var coef = (rest*radius/(bValue/8))%radius;
			if(rest > 0)
			{
				borderMask.graphics.clear();
				borderMask.graphics.lineStyle(1,color);
				borderMask.graphics.beginFill(color);
				borderMask.graphics.moveTo(0,0);
				borderMask.graphics.lineTo(0,-radius);
				
				if(rest < bValue/8)
					borderMask.graphics.lineTo(coef,-radius);
				if(rest >= bValue/8)
				{
					borderMask.graphics.lineTo(radius,-radius);
					if(rest < bValue/4)
						borderMask.graphics.lineTo(radius,coef-radius);
				}
				if(rest >= bValue/4)
				{
					borderMask.graphics.lineTo(radius,0);
					if(rest < bValue*3/8)
						borderMask.graphics.lineTo(radius,coef);
				}
				if(rest >= bValue*3/8)
				{
					borderMask.graphics.lineTo(radius,radius);
					if(rest < bValue/2)
						borderMask.graphics.lineTo(radius-coef,radius);
				}
				if(rest >= bValue/2)
				{
					borderMask.graphics.lineTo(0,radius);
					if(rest < bValue*5/8)
						borderMask.graphics.lineTo(-coef,radius);
				}
				if(rest >= bValue*5/8)
				{
					borderMask.graphics.lineTo(-radius,radius);
					if(rest < bValue*3/4)
						borderMask.graphics.lineTo(-radius,radius-coef);
				}
				if(rest >= bValue*3/4)
				{
					borderMask.graphics.lineTo(-radius,0);
					if(rest < bValue*7/8)
						borderMask.graphics.lineTo(-radius,-coef);
				}
				if(rest >= bValue*7/8)
				{
					borderMask.graphics.lineTo(-radius,-radius);
					if(rest < bValue)
						borderMask.graphics.lineTo(coef-radius,-radius);
				}
				if(rest == bValue)
					borderMask.graphics.lineTo(0,-radius);
				borderMask.graphics.endFill();
			}
		}
		function drawCounter()
		{
			changeRadius();
			drawBorder();
			drawMask();
		}
	}
	
}
