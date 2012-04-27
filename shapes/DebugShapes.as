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
	import flash.display.Graphics;

	// =========================================================================
	// Class DebugShapes
	// =========================================================================
	// Helper Class for debugging Display based Classes.
	//	
	public class DebugShapes
	{
		/**
		 * ---------------------------------------------------------------------
		 * drawDebugCross
		 * ---------------------------------------------------------------------
		 * draws a cross with a circle around, like a cross-hair.
		 * 
		 * @param g				Graphics layer
		 * @param x				centerpoint x
		 * @param y				centerpoint y
		 * @param thickness		line thickness, default 1.0
		 * @param color			line color, default pure red.
		 * @param alpha			line alpha, default 1.0
		 */
		public static function drawDebugCross(
				g:Graphics,
				x:Number, 
				y:Number,
				thickness:Number=1.0,
				color:uint=0xFF0000,
				alpha:Number=1.0
			):void
		{
			var size:Number = 6.0;
			
			g.lineStyle(thickness, color, alpha);     
			g.moveTo(x-size, y);
			g.lineTo(x+size, y); 
			g.moveTo(x, y-size);
			g.lineTo(x, y+size); 
			
			g.drawCircle(
					x+thickness/2, 
					y+thickness/2, 
					size
				);
		}
	
	}	
}