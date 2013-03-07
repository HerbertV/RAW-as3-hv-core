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
 * Copyright (c) 2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.core.utils 
{
	import flash.system.Capabilities;
	
	/**
	 * =========================================================================
	 * Class OSUtility
	 * =========================================================================
	 * Helper functions and static vars for OS specific problems. 
	 */
	public class OSUtility 
	{
		// =====================================================================
		// Constants
		// =====================================================================
		
		public static const PATH_SEPARATOR_WIN:String = "\\";
		
		public static const PATH_SEPARATOR_MAC:String = ":";
		
		public static const PATH_SEPARATOR_OTHER:String = "/";
		
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		/**
		 * stores the OS String
		 */
		public static var OS:String;
		
		/**
		 * contains the path separator for the actual system
		 */
		public static var PATH_SEPARATOR:String;
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * setup all OS related variables.
		 */
		public static function init()
		{
			OSUtility.OS = flash.system.Capabilities.os.substr(0, 3);
			
			if( OS == "Win" ) 
			{
				PATH_SEPARATOR = PATH_SEPARATOR_WIN;
				
			} else if( OS == "Mac" ) {
				PATH_SEPARATOR = PATH_SEPARATOR_MAC;
				
			} else {
				PATH_SEPARATOR = PATH_SEPARATOR_OTHER;
				
			}
		}
		
	}

}