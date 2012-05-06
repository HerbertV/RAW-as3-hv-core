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
package as3.hv.core.utils
{
	// =========================================================================
	// Class DateTimeFormatter
	// =========================================================================
	// Static Class 
	// with extenstions for date conversions
	//
	public class DateTimeFormatter
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
		 * defaultFormat
		 * ---------------------------------------------------------------------
		 * converts a date into a date time string YYYY-MM-DD HH24:mm:ss
		 *
		 * @param d 		the date
		 *
		 * @return 			the date formated into YYYY-MM-DD HH24:mm:ss
		 */
		public static function defaultFormat(d:Date):String
		{
			var dt:String = d.fullYear
					+ "-" + StringHelper.leadingZeros(d.month+1)
					+ "-" + StringHelper.leadingZeros(d.date)
					+ " " + StringHelper.leadingZeros(d.hours)
					+ ":" + StringHelper.leadingZeros(d.minutes)
					+ ":" + StringHelper.leadingZeros(d.seconds); 
		
			return dt;		
		}
	
	}
}