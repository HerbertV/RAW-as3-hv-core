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
	
	// =========================================================================
	// Class EdgedRectangleShape
	// =========================================================================
	// for drawing Rectangles with cut off corners.
	//       _____
	//     1/     \2
	//      |     |
	//     4\_____/3
	//
	// you can choose which corners are cut.
	//
	public class EdgedRectangleShape
	{
		// =====================================================================
		// CONSTANTS
		// =====================================================================
		
		// Class Version
		public static const VERSION:String = "1.0.0";
		
		// =====================================================================
		// FUNCTIONS
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * drawGraphics
		 * ---------------------------------------------------------------------
		 * static helper to draw an edged rectangle direct into the graphics.
		 *
		 * @param g				The graphics of an display object.
		 * @param x				starting point x coord (upper left corner)
		 * @param y 			starting point y coord (upper left corner)
		 * @param w				Width
		 * @param h				Height
		 * @param insets		x/y insets for all edges as an Array.
		 * 						Array can include 1,2 or 4 entries.
		 * 						If 1 is set all corners are cut the same.
		 *						If 2 are set 1/3 and 2/4 are cut the same.
		 *						If 4 are set all corners are cut individual.
		 *						A value of -1 prevents the cut.
		 *						
		 * @param cut			which corners are cut
		 * @param lThickness	outline thickness
		 * @param lColor		outline color
		 * @param lAlpha		outline alpha
		 * @param filled 		if it is filled. Default not filled.
		 * @param fColor		fill color
		 * @param fAlpha		fill alpha
		 */	
		public static function drawGraphics(
				g:Graphics,
				x:Number,
				y:Number,
				w:Number,
				h:Number,
				insets:Array,
				lThickness:Number,
				lColor:uint,
				lAlpha:Number,
				filled:Boolean=false,
				fColor:uint=0x000000,
				fAlpha:Number=1.0
			):void
		{
			var offsetX:Number = x;
			var offsetY:Number = y;
			
			var inset1:Number = -1;
			var inset2:Number = -1;
			var inset3:Number = -1;
			var inset4:Number = -1;
			
			if( insets.length != 1 
			   		&& insets.length != 2
					&& insets.length != 4 )
				throw new Error ("Wrong inset count: Use 1,2 or 4 entries.");    
			
			// assign insets
			if( insets.length == 1 )
				inset1 = inset2 = inset3 = inset3 = insets[0];
			
			if( insets.length == 2 )
			{
				inset1 = inset3 = insets[0];
				inset2 = inset4 = insets[1];
			}
			
			if ( insets.length == 4 )
			{
				inset1 = insets[0];
				inset2 = insets[1];
				inset3 = insets[2];
				inset4 = insets[3];
			}
			
			// now draw
			if( filled )
				g.beginFill(fColor,fAlpha);
            
			g.lineStyle(lThickness, lColor, lAlpha);
            			
			// starting point
			if( inset1 > 0 ) 
				x += inset1;
			
			g.moveTo(x,y);
			
			// side 1-2
			x = w +offsetX;
			if( inset2 > 0 )
				x -= inset2;
			
			g.lineTo(x,y);
			
			// edge 2 diagonal
			if( inset2 > 0 )
			{
				y += inset2;
				x += inset2;
				g.lineTo(x,y);
			}
			
			// side 2-3
			y = h + offsetY;
			if( inset3 > 0 )
				y -= inset3;
			
			g.lineTo(x,y);
			
			// edge 3 diagonal
			if( inset3 > 0 )
			{
				x -= inset3;
				y += inset3;
				g.lineTo(x,y);
			}
			
			// side 3-4
			x = offsetX;
			if( inset4 > 0 )
				x += inset4;
			
			g.lineTo(x,y);
			
			// edge 4 diagonal
			if( inset4 > 0 )
			{
				x = offsetX;
				y -= inset4;
				g.lineTo(x,y);
			}
			
			// side 4-1
			y = offsetY;
			if( inset1 > 0 )
				y += inset1;
			
			g.lineTo(x,y);
			
			// edge 1 diagonal
			if( inset1 > 0 )
			{
				y = offsetY;
				x += inset1;
				g.lineTo(x,y);
			}
			
			if( filled )
				g.endFill();
		}
		
	
	}

}