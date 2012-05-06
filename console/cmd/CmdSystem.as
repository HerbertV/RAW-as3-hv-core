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
	
	import flash.system.Capabilities;
	
	// =========================================================================
	// Class CmdSystem
	// =========================================================================
	// shows a brief system info
	public class CmdSystem 
			implements IConsoleCommand 
	{
		// =====================================================================
		// Constants
		// =====================================================================	
		public static const CMD:String = "system";
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function CmdSystem()
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
		 * @param args 	not use by system		
		 */
		public function doCommand(args:Array):void
		{
			var msg:String =  "<b>Systeminfo</b><br>" 
					+ "Flash Player: " + Capabilities.version 
					+ "<br>OS: " + Capabilities.os
					+ "<br>Display: " + Capabilities.screenResolutionX 
					+ "x" + Capabilities.screenResolutionY;
					
			Console.getInstance().writeln(msg, DebugLevel.COMMAND);
			Console.getInstance().newLine();
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * shortHelp
		 * ---------------------------------------------------------------------
		 */
		public function shortHelp():String
		{
			return "'" + CMD + "' - shows system info";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * longHelp
		 * ---------------------------------------------------------------------
		 */
		public function longHelp():String
		{
			return "USAGE: " + CMD 
					+ " [no args]<br/> -  shows system info";
		}
		
		
	}
}