﻿/*
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
 * @version: 2.1.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.core.console.cmd
{
	/**
	 * =========================================================================
	 * Interface IConsoleCommand
	 * =========================================================================
	 * Interface for Console Commands.
	 *
	 * How to use:
	 * Make a new class file implementining this interface.
	 * Naming convention: Cmd[commandname].as
	 * 
	 * add the CMD constant in your class:
	 * public static const CMD:String = "command";
	 *	
	 * add your command to Console with:
	 * registerCommand(CmdHelp.CMD, new CmdHelp(this));
	 */ 
	public interface IConsoleCommand 
	{
		/**
		 * ---------------------------------------------------------------------
		 * doCommand
		 * ---------------------------------------------------------------------
		 * Execute this command. 
		 *
		 * @param args array of arguments can be null if command needs no args.
		 */
		function doCommand(args:Array=null):void;
		
		/**
		 * ---------------------------------------------------------------------
		 * usesArguments
		 * ---------------------------------------------------------------------
		 * this function must return true, if args of doCommand are used.
		 * 
		 * @return 
		 */
		function usesArguments():Boolean;
		
		/**
		 * ---------------------------------------------------------------------
		 * longHelp
		 * ---------------------------------------------------------------------
		 * @return the long help string
		 */
		function longHelp():String;
				
		/**
		 * ---------------------------------------------------------------------
		 * shortHelp
		 * ---------------------------------------------------------------------
		 * @return the short help string
		 */
		function shortHelp():String;
	
	}
}