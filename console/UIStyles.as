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
 * @version: 2.0.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.core.console
{
	// =========================================================================
	// Class UIStyles
	// =========================================================================
	// statics for styling our console
	//
	public class UIStyles
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		// ---------------------------------------------------------------------
		// Headlinestyles
		// ---------------------------------------------------------------------
		//Background
		public static var HEAD_BG_COLOR:uint = 0xCCCCDD;
		public static var HEAD_BG_ALPHA:Number = 0.8;
		public static var HEAD_BG_OUTLINE_COLOR:uint = 0x000000;
		public static var HEAD_BG_OUTLINE_ALPHA:Number = 1.0;
		//Label
		public static var HEAD_FONT_COLOR:int = 0x000000;
		public static var HEAD_FONT_NAME:String = "Arial";
		public static var HEAD_FONT_SIZE:int = 11;
		
		// ---------------------------------------------------------------------
		// Framestyles
		// ---------------------------------------------------------------------
		//Background
		public static var FRAME_BG_COLOR:uint = 0xCCCCDD;
		public static var FRAME_BG_ALPHA:Number = 0.7;
		public static var FRAME_BG_OUTLINE_COLOR:uint = 0x000000;
		public static var FRAME_BG_OUTLINE_ALPHA:Number = 0.9;
		
		// ---------------------------------------------------------------------
		// Outputstyles
		// ---------------------------------------------------------------------
		//Background
		public static var OUTPUT_BG_COLOR:uint = 0x333333;
		public static var OUTPUT_BG_ALPHA:Number = 0.8;
		public static var OUTPUT_BG_OUTLINE_COLOR:uint = 0x000000;
		public static var OUTPUT_BG_OUTLINE_ALPHA:Number = 1.0;
		
		// ---------------------------------------------------------------------
		// Console Messages
		// ---------------------------------------------------------------------
		public static var MSG_FONT_NAME:String = "Arial";
		public static var MSG_FONT_SIZE:int = 11;
		
		public static var MSG_COLOR_COMMAND:String = "#0099FF";
		public static var MSG_COLOR_INFO:String = "#00CC00";
		public static var MSG_COLOR_DEBUG:String = "#FFFFFF";
		public static var MSG_COLOR_WARNING:String = "#FFCC00";
		public static var MSG_COLOR_ERROR:String = "#FF0000";
		
		// ---------------------------------------------------------------------
		// Commandline
		// ---------------------------------------------------------------------
		//Background
		public static var CMD_BG_COLOR:uint = 0x333333;
		public static var CMD_BG_ALPHA:Number = 0.8;
		public static var CMD_BG_OUTLINE_COLOR:uint = 0x000000;
		public static var CMD_BG_OUTLINE_ALPHA:Number = 1.0;
		//Label
		public static var CMD_FONT_COLOR:int = 0xFFFFFF;
		public static var CMD_FONT_NAME:String = "Arial";
		public static var CMD_FONT_SIZE:int = 11;
		
		// ---------------------------------------------------------------------
		// Scrollbar, dragger ...
		// ---------------------------------------------------------------------
		public static var UI_COLOR:uint = 0x0066FF;
		public static var UI_OUTLINE_COLOR:uint = 0x000000;
		
	}
}