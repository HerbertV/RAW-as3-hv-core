/*
 *  __  __      
 * /\ \/\ \  __________   
 * \ \ \_\ \/_______  /\   
 *  \ \  _  \  ____/ / /  
 *   \ \_\ \_\ \ \/ / / 
 *    \/_/\/_/\ \ \/ /  
 *             \ \  /
 *              \_\/
 *
 * -----------------------------------------------------------------------------
 * @author: Herbert Veitengruber 
 * @version: 1.0.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.core.shapes
{
	import flash.display.Shape;
	import flash.display.Graphics;
	
	import flash.geom.Point;

	
	// =========================================================================
	// Class PenroseTriangle
	// =========================================================================
	// Draws a PenroseTriangle
	//
	// @see http://en.wikipedia.org/wiki/Penrose_triangle
	// @see M.C. Escher http://en.wikipedia.org/wiki/M._C._Escher
	//
	public class PenroseTriangle
	{
		// =====================================================================
		// CONSTANTS
		// =====================================================================
		
		// Class Version
		public static const VERSION:String = "1.0.0";
		
		// height = side length * height multiplier (hm)
		public static const HM:Number =  Math.sqrt(3)/2;
		// degrees to rad multiplier
		public static const DEG_2_RAD:Number = ( Math.PI / 180 );

		
		// =====================================================================
		// FUNCTIONS
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * drawGraphics
		 * ---------------------------------------------------------------------
		 * static helper to draw a Penrose Triangle direct into the graphics.
		 *
		 * @param g				The graphics of an display object.
		 * @param center		center point of the triangle
		 * @param len 			length of the outer triangle sides.
		 * @param lThickness	outline thickness
		 * @param lColor		outline color (uint 0x000000 to 0xFFFFFF)
		 * @param lAlpha		outline alpha (0.0 to 1.0)
		 * @param filled 		if it has filled segments or not.
		 * @param fColors		Array of colors (uint 0x000000 to 0xFFFFFF) 
		 * 						with length of 3.
		 *						Each Color is for 1 segment.
		 * @param fAlphas		Array of alphas (0.0 to 1.0) with length of 3.
		 *						Each Alpha is for 1 segment. 	
		 */	
		public static function drawGraphics(
				g:Graphics,
				center:Point, 
				len:Number,
				lThickness:Number,
				lColor:uint,
				lAlpha:Number,
				filled:Boolean,
				fColors:Array,
				fAlphas:Array
			):void
		{
			var pv:PenroseVars = new PenroseVars(center,len);

			PenroseTriangle.drawSegment(
					g,
					pv,
					lThickness,
					lColor,
					lAlpha,
					filled,
					fColors[0],
					fAlphas[0],
					0
				);
			
			PenroseTriangle.drawSegment(
					g,
					pv,
					lThickness,
					lColor,
					lAlpha,
					filled,
					fColors[1],
					fAlphas[1],
					120
				);
			
			PenroseTriangle.drawSegment(
					g,
					pv,
					lThickness,
					lColor,
					lAlpha,
					filled,
					fColors[2],
					fAlphas[2],
					240
				);
			
			if( filled )
			{
				g.beginFill(0xFF0000,0.0);
				PenroseTriangle.drawTriangle(g, center, pv.sizeInner);
				g.endFill();
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * drawSingleSegment
		 * ---------------------------------------------------------------------
		 * static helper to draw a segment of a Penrose Triangle direct into 
		 * the graphics.
		 *
		 * @param g				The graphics of an display object.
		 * @param center		center point of the triangle
		 * @param len 			length of the outer triangle sides.
		 * @param lThickness	outline thickness
		 * @param lColor		outline color (uint 0x000000 to 0xFFFFFF)
		 * @param lAlpha		outline alpha (0.0 to 1.0)
		 * @param filled 		if it has filled segments or not.
		 * @param fColor		color (uint 0x000000 to 0xFFFFFF) 
		 * @param fAlpha		alpha (0.0 to 1.0)
		 * @param angle			angle in degrees. 	
		 */	
		public static function drawSingleSegment(
				g:Graphics,
				center:Point, 
				len:Number,
				lThickness:Number,
				lColor:uint,
				lAlpha:Number,
				filled:Boolean,
				fColor:uint,
				fAlpha:Number,
				angle:uint
			):void
		{
			var pv:PenroseVars = new PenroseVars(center,len);
			
			PenroseTriangle.drawSegment(
					g,
					pv,
					lThickness,
					lColor,
					lAlpha,
					filled,
					fColor,
					fAlpha,
					angle
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * drawTriangle
		 * ---------------------------------------------------------------------
		 * draws an upside down triangle.
		 *
		 * @param g				The graphics of an display object.
		 * @param center		center point of the triangle
		 * @param len 			length of the triangle sides.
		 */	
		public static function drawTriangle(
				g:Graphics, 
				center:Point, 
				len:Number
			):void
		{		
			var posx = center.x - len/2;
			var posy = center.y - (PenroseTriangle.HM*len)/3;
			
			g.moveTo(posx,posy);
			
			posx = posx +len;
			g.lineTo(posx,posy);
			
			posx += len * Math.cos(PenroseTriangle.DEG_2_RAD * 120);
			posy += len * Math.sin(PenroseTriangle.DEG_2_RAD * 120);
			g.lineTo(posx,posy);
			
			posx += len * Math.cos(PenroseTriangle.DEG_2_RAD * 240);
			posy += len * Math.sin(PenroseTriangle.DEG_2_RAD * 240);
			g.lineTo(posx,posy);
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * drawSegment
		 * ---------------------------------------------------------------------
		 * internal draw segment.
		 *
		 * @param g				The graphics of an display object.
		 * @param pv			PenroseVars
		 * @param lThickness	outline thickness
		 * @param lColor		outline color (uint 0x000000 to 0xFFFFFF)
		 * @param lAlpha		outline alpha (0.0 to 1.0)
		 * @param filled 		if it has filled segments or not.
		 * @param fColor		color (uint 0x000000 to 0xFFFFFF) 
		 * @param fAlpha		alpha (0.0 to 1.0)
		 * @param angle			angle in degrees. 	
		 */	
		private static function drawSegment(
				g:Graphics,
				pv:PenroseVars,
				lThickness:Number,
				lColor:uint,
				lAlpha:Number,
				filled:Boolean,
				fColor:uint,
				fAlpha:Number,
				angle:uint
			):void
		{
			var posx = pv.center.x + pv.dist 
					* Math.cos( pv.angleOffset + DEG_2_RAD * angle);
			var posy = pv.center.y + pv.dist 
					* Math.sin( pv.angleOffset + DEG_2_RAD * angle);
	
				
			g.lineStyle(lThickness, lColor, lAlpha);

			if( filled )
				g.beginFill(fColor, fAlpha);

			g.moveTo(posx,posy);
			
			posx += pv.sizeEx * Math.cos(DEG_2_RAD * (300+angle));
			posy += pv.sizeEx * Math.sin(DEG_2_RAD * (300+angle));
			g.lineTo(posx,posy);
			
			posx += (pv.sizeOuter - (pv.sizeEx*2)) * Math.cos(DEG_2_RAD * angle);
			posy += (pv.sizeOuter - (pv.sizeEx*2)) * Math.sin(DEG_2_RAD * angle);
			g.lineTo(posx,posy);

			posx += pv.sizeMiddle * Math.cos(DEG_2_RAD * (120+angle));
			posy += pv.sizeMiddle * Math.sin(DEG_2_RAD * (120+angle));
			g.lineTo(posx,posy);
			
			posx += pv.sizeEx * Math.cos(DEG_2_RAD * (240+angle));
			posy += pv.sizeEx * Math.sin(DEG_2_RAD * (240+angle));
			g.lineTo(posx,posy);
			
			posx -= (pv.sizeInner + pv.sizeEx) 
					* Math.cos(DEG_2_RAD * (120+angle));
			posy -= (pv.sizeInner + pv.sizeEx) 
					* Math.sin(DEG_2_RAD * (120+angle));
			g.lineTo(posx,posy);
			
			posx -= pv.sizeMiddle * Math.cos(DEG_2_RAD * angle);
			posy -= pv.sizeMiddle * Math.sin(DEG_2_RAD * angle);
			g.lineTo(posx,posy);	
			
			if( filled )
				g.endFill();
		}
		
	}
}


// =============================================================================
// Inner Class PenroseTriangle
// =============================================================================
// just to prevent re-calculating vars for each segement again.
//
import as3.hv.core.shapes.PenroseTriangle;
import flash.geom.Point;

class PenroseVars
{
	// the centerpoint of this shape
	public var center:Point;

	// side lenght of the outer Tringle
	public var sizeOuter:Number;
	// side lenght of the middle Triangle
	public var sizeMiddle:Number;
	// side lenght of the inner Triangle
	public var sizeInner:Number;

	// triangles heights
	public var hOuter:Number;
	public var hMiddle:Number;
	public var hInner:Number;

	public var deltaH:Number;
	public var sizeEx:Number;

	public var segementStart:Point;
	public var dist:Number;
	public var angleOffset:Number;

	/**
	 * -------------------------------------------------------------------------
	 * Constructor
	 * -------------------------------------------------------------------------
	 * pre calculates all vars needed for drawing.
	 *
	 * @param c				center point of the triangle
	 * @param len 			length of the outer triangle sides.
	 */	
	public function PenroseVars(
			c:Point, 
			len:Number
		)
	{
		this.center = c;

		//side sizes for all 3 triangles
		this.sizeOuter = len;
		this.sizeMiddle = sizeOuter * 2/3;
		this.sizeInner = sizeOuter /3;
		
		// triangles heights
		this.hOuter = PenroseTriangle.HM  * sizeOuter;
		this.hMiddle = PenroseTriangle.HM * sizeMiddle;
		this.hInner = PenroseTriangle.HM * sizeInner;

		// triangle height difference between to segments
		this.deltaH = hMiddle/3 - hInner/3;
		// side extension to fill the gap between 2 triangles
		this.sizeEx = deltaH / Math.sin(PenroseTriangle.DEG_2_RAD * 60) 
				* Math.sin(PenroseTriangle.DEG_2_RAD * 90);
		
		this.segementStart = new Point(
				c.x - sizeMiddle/2 - sizeEx, 
				c.y - hMiddle/3
			);
			
		this.dist = Point.distance(c,segementStart);
		this.angleOffset =  Math.atan2(
				segementStart.y - c.y, 
				segementStart.x - c.x
			);
	}
}	