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
	import as3.hv.core.console.DebugLevel;
	
	/**
	 * =========================================================================
	 * Class CmdDebugLevel
	 * =========================================================================
	 */
	public class CmdDebugLevel 
			implements IConsoleCommand 
	{
		// =====================================================================
		// Constants
		// =====================================================================	
		public static const CMD:String = "dlvl";
		
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function CmdDebugLevel()
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
		 * @param args 		
		 */
		public function doCommand(args:Array):void
		{
			if( args.length == 0 ) 
			{
				// show level
				Console.getInstance().writeln(
						"Debug Level:" + DebugLevel.toString() 
								+ "(" + DebugLevel.level + ")",
						DebugLevel.COMMAND
					);
				return;
			}
			
			if( args.length == 1 ) 
			{
				if( args[0] == "-l" )
				{
					// list debug levels:
					var msg:String = "Available Levels:<br/>"
							+ "<li>0 - " + DebugLevel.toString(0) + "</li>"
							+ "<li>1 - " + DebugLevel.toString(1) + "</li>"
							+ "<li>4 - " + DebugLevel.toString(4) + "</li>"
							+ "<li>5 - " + DebugLevel.toString(5) + "</li>"
							+ "<li>6 - " + DebugLevel.toString(6) + "</li>"
							+ "<li>7 - " + DebugLevel.toString(7) + "</li>"
							+ "<li>8 - " + DebugLevel.toString(8) + "</li>";
					
					Console.getInstance().writeln(
							msg,
							DebugLevel.COMMAND
						);
					
					return;
					
				} else {
					var lvl:int = int(args[0]);
					
					if( lvl < 0 
							|| lvl == 2 
							|| lvl == 3
							|| lvl > 8 
						)
					{
						Console.getInstance().writeln(
								"invalid level",
								DebugLevel.COMMAND_ERROR
							);
						return;
					}
					
					// set level
					DebugLevel.level = lvl;
					Console.getInstance().writeln(
								"set debug to "+DebugLevel.toString(lvl) + "("+lvl+")",
								DebugLevel.COMMAND
							);
						
					return;
				}				
			}
			// wrong usage show help
			Console.getInstance().writeln(
					longHelp(),
					DebugLevel.COMMAND
				);
			
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
			return true;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * shortHelp
		 * ---------------------------------------------------------------------
		 */
		public function shortHelp():String
		{
			return "'" + CMD + "' - shows/changes the Debug Level";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * longHelp
		 * ---------------------------------------------------------------------
		 */
		public function longHelp():String
		{
			return "USAGE: " + CMD 
					+ " [arg]<br/> - level to set a new level or -l to show list";
		}
		
		
	}
}