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
package as3.hv.core.console.cmd
{
	import as3.hv.core.console.Console;
	
	/**
	 * =========================================================================
	 * Class CmdClear
	 * =========================================================================
	 */
	public class CmdClear 
			implements IConsoleCommand 
	{
		// =====================================================================
		// Constants
		// =====================================================================	
		public static const CMD:String = "clr";
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function CmdClear()
		{
		
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * doCommand
		 * ---------------------------------------------------------------------
		 * @see IConsoleCommand 
		 *
		 * @param args 		not used by this command
		 */
		public function doCommand(args:Array):void
		{
			Console.getInstance().clearOutput();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * usesArguments
		 * ---------------------------------------------------------------------
		 * @see IConsoleCommand 
		 *
		 * @return
		 */
		public function usesArguments():Boolean
		{
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * shortHelp
		 * ---------------------------------------------------------------------
		 */
		public function shortHelp():String
		{
			return "'" + CMD + "' - clears the consoles output";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * longHelp
		 * ---------------------------------------------------------------------
		 */
		public function longHelp():String
		{
			return "USAGE: " + CMD 
					+ " [no args]<br/> - clears the consoles output";
		}

	}
}