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
package as3.hv.core.console.cmd
{
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	// =========================================================================
	// Class CmdHelp
	// =========================================================================
	public class CmdHelp 
			implements IConsoleCommand 
	{
		// =====================================================================
		// Constants
		// =====================================================================	
		public static const CMD:String = "help";
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CmdHelp()
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
		 * @param args 	array of arguments.
		 */
		public function doCommand(args:Array):void
		{
			var msg:String = "Available Commands:<br/>"
			
			if (args.length == 1) {
				// long help
				msg = IConsoleCommand(args[i]).longHelp();
			} else {
				for (var i:int=0; i<args.length; i++)
					msg += "<li>" + IConsoleCommand(args[i]).shortHelp() + "</li>";
					
			}
			Console.getInstance().writeln(msg, DebugLevel.INFO, false);
			Console.getInstance().newLine();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * shortHelp
		 * ---------------------------------------------------------------------
		 */
		public function shortHelp():String
		{
			return "'" + CMD + "' - for command list";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * longHelp
		 * ---------------------------------------------------------------------
		 */
		public function longHelp():String
		{
			return "'" + CMD + "' - for command list";
		}
		
		
	}
}