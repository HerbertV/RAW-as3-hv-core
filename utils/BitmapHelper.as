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
 * Copyright (c) 2010-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.core.utils
{
	import flash.display.Bitmap;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
			
	// =========================================================================
	// Class BitmapHelper
	// =========================================================================
	// Static Class 
	//
	public class BitmapHelper
	{
		// =====================================================================
		// CONSTANTS
		// =====================================================================
		
		// Class Version
		public static const VERSION:String = "1.0.0";
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * resizeBitmap
		 * ---------------------------------------------------------------------
		 * resizes a bitmap down to max width or height
		 * 
		 * @param bmp 			Bitmap to resize
		 * @param maxWidth 
		 * @param maxHeight
		 * @param doCenter
		 *
		 * @returns	the resized Bitmap
		 */
		public static function resizeBitmap(
				bmp:Bitmap, 
				maxWidth:int, 
				maxHeight:int, 
				doCenter:Boolean
			):Bitmap
		{
			// calc ratios
			var ratioWidth:Number = maxWidth/bmp.width;
			var ratioHeight:Number = maxHeight/bmp.height;
			
			if( Console.isConsoleAvialable() )
				Console.getInstance().writeln(
						"resizing Bitmap...",
						DebugLevel.INFO,
						" --> maxWidth: " + maxWidth
							+ "<br> --> maxHeight: " + maxHeight
							+ "<br> --> bmp.width: " + bmp.width
							+ "<br> --> bmp.height: " + bmp.height
							+ "<br> --> ratioWidth: " + ratioWidth
							+ "<br> --> ratioHeight: " + ratioHeight
					);
			
			if( bmp.width > maxWidth 
					|| bmp.height > maxHeight ) 
			{
				if( ratioWidth > ratioHeight )
				{
					bmp.width = bmp.width * ratioHeight;
					bmp.height = bmp.height * ratioHeight;
				} else {
					bmp.width = bmp.width * ratioWidth;
					bmp.height = bmp.height * ratioWidth;		
				}
				
				if( doCenter )
				{
					bmp.x = (maxWidth - bmp.width) / 2;
					bmp.y = (maxHeight - bmp.height) / 2;
				}
				
				if( Console.isConsoleAvialable() )
					Console.getInstance().writeln(
							"after resize:",
							DebugLevel.INFO,
							"<br> --> bmp.width: " + bmp.width
								+ "<br> --> bmp.height: " + bmp.height
						);
			}
			return bmp;
		}
	
	
	}
}