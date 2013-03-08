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
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.core.console
{
	/**
	 * =========================================================================
	 * Class DebugLevel
	 * =========================================================================
	 * Debug level and helper functions
	 */
	public class DebugLevel 
	{
		// =====================================================================
		// Constants
		// =====================================================================	
		
		public static const OFF:int = 0;
		public static const FULL:int = 1;
		
		// commandline levels
		public static const COMMAND:int = 2;
		public static const COMMAND_ERROR:int = 3;
						
		public static const INFO:int = 4;
		public static const DEBUG:int = 5;
		public static const WARNING:int = 6;
		public static const ERROR:int = 7;
		public static const FATAL_ERROR:int = 8;
		
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		// current level of debug, default is FULL.
		public static var level:int = 1;
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * check
		 * ---------------------------------------------------------------------
		 * checks the given level against the current debug level. 
		 *
		 * @param lvl 	level to be checked.
		 *
		 * @returns 	true if the given level is below the current level.
		 *				there a 4 special cases OFF, FULL, COMMAND and 
		 * 				COMMAND_ERROR.
		 */
		public static function check( lvl:int ):Boolean
		{
			// commandline feedback is allways shown
			if( lvl == COMMAND || lvl == COMMAND_ERROR )
				return true;
				
			// debugging is off 
			if( DebugLevel.level == OFF )
				return false;
		
			// show all messages
			if( DebugLevel.level == FULL )
				return true;
		
			if( lvl >= DebugLevel.level )
				return true;
		
			return false;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * toString
		 * ---------------------------------------------------------------------
		 * checks the given level against the current debug level. 
		 *
		 * @param lvl 	(optional) if no level is set, the current debug level
		 *				is returned as string
		 *
		 * @returns 	the debug level as string
		 */
		public static function toString( lvl:int=-1 ):String
		{
			if( lvl == -1 ) 
				lvl = DebugLevel.level;
			
			switch( lvl )
			{
				case 0:		return "OFF";
				case 1:		return "FULL";
				case 2:		return "COMMAND";
				case 3:		return "COMMAND_ERROR";
				case 4:		return "INFO";
				case 5:		return "DEBUG";
				case 6:		return "WARNING";
				case 7:		return "ERROR";
				case 8:		return "FATAL ERROR";
			}
			
			return "illegal";
		}
	}	
}