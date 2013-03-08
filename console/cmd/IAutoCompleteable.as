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
package as3.hv.core.console.cmd 
{
	
	/**
	 * =========================================================================
	 * Interface IAutoCompleteable
	 * =========================================================================
	 * Interface for Console Commands that support the auto complete feature
	 * for their arguments.
	 */
	public interface IAutoCompleteable 
	{
		/**
		 * ---------------------------------------------------------------------
		 * doAutoComplete
		 * ---------------------------------------------------------------------
		 * auto completes the command.
		 *
		 * @param args array of arguments.
		 * @return the completed command string (including the command string itself).
		 */
		function doAutoComplete(args:Array):String;
		
	}
	
}