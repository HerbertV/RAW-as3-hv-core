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
	
	import as3.hv.core.utils.DateTimeFormatter;
	
	/**
	 * =========================================================================
	 * Class CmdTime
	 * =========================================================================
	 */
	public class CmdTime 
			implements IConsoleCommand 
	{
		// =====================================================================
		// Constants
		// =====================================================================	
		public static const CMD:String = "time";
		
		// =====================================================================
		// Variables
		// =====================================================================	
		private static var startTime:Date;
		
		private static var isTimeSet:Boolean = false;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function CmdTime()
		{
			if( !CmdTime.isTimeSet )
				CmdTime.initTime();
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
			var now:Date = new Date();
			var d:Number = now.time - startTime.time;
			
			var dH:int = d / 3600000;
			var dM:int = (d % 3600000) / 60000;
			var dS:int = ( (d % 3600000) % 60000 ) / 1000;
			var dms:int = ( (d % 3600000) % 60000 ) % 1000;
			
			var msg:String = "Application started at: " 
					+ DateTimeFormatter.defaultFormat(startTime)
					+ "<br>now: "
					+ DateTimeFormatter.defaultFormat(now)
					+ "<br>running for: "
					+ dH + "h "
					+ dM + "min "
					+ dS + "sec "
					+ dms + "ms";
			
			Console.getInstance().writeln(
					msg,
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
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initTime
		 * ---------------------------------------------------------------------
		 * inits the startup application time
		 */
		static public function initTime():void
		{
			CmdTime.startTime = new Date();
			CmdTime.isTimeSet = true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * shortHelp
		 * ---------------------------------------------------------------------
		 */
		public function shortHelp():String
		{
			return "'" + CMD + "' - shows the application times";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * longHelp
		 * ---------------------------------------------------------------------
		 */
		public function longHelp():String
		{
			return "USAGE: " + CMD 
					+ " [no args]<br/> - shows the application times";
		}

	}
}