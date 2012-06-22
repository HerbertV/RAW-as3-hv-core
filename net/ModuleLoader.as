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
 * Copyright (c) 2010-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.core.net
{
	import flash.display.MovieClip;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
		
	// =========================================================================
	// Class ModuleLoader
	// =========================================================================
	// for loading AbstractModules.
	//
	public class ModuleLoader
			extends AssetLoader 
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		protected var targetContainer:MovieClip = null;
		
		protected var instantAdd:Boolean = false;
		protected var wasAdded:Boolean = false;
		
		protected var moduleVersion:String = "";
		
		// =====================================================================
		// Constructors
		// =====================================================================
		
		/**
		 * Constructor
		 * 
		 * @param file filename with relative/absolute path
		 * @param target
		 * @param version
		 * @param name (optional)
		 * @param instant (optional)
		 *			use true if your module is optimized for streaming
		 */
		public function ModuleLoader(
				file:String,
				target:MovieClip,
				version:String,
				name:String="ModuleLoader",
				instant:Boolean=false
			)
		{
			super(file,name);
			
			this.targetContainer = target;
			this.moduleVersion = version;
			this.instantAdd = instant;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getModule
		 * ---------------------------------------------------------------------
		 * Returns the module. 
		 * Returns null if the null is still loading or failed to load.
		 *
		 * @return 
		 */
		public function getModule():AbstractModule
		{
			if( this.loadingFinished == true 
					&& this.loadingFailed == false )
				return AbstractModule(myLoader.content);
			
			return null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * checkModule
		 * ---------------------------------------------------------------------
		 * to check if it is a valid AbstractModule and has the proper version.
		 *
		 * @param module
		 *
		 * @return 
		 */
		protected function checkModule( module:MovieClip ):Boolean
		{
			if( !(module is AbstractModule) ) 
			{
				if( Console.isConsoleAvailable() ) 
				{
					Console.getInstance().writeln(
							"Not a valid AbstractModule:",
							DebugLevel.ERROR,
							" --> "+ this.filename
						);
					Console.getInstance().newLine();	
				}  else {
					// since it is an error trace it 
					trace("Not a valid AbstractModule: "+ this.filename);
				}
				return false;
			}
			
			if( !AbstractModule(module).checkModuleVersion(moduleVersion) )
			{
				if( Console.isConsoleAvailable() ) 
				{
					Console.getInstance().writeln(
							"Wrong module version: ",
							DebugLevel.ERROR,
							" --> " + this.filename
								+ "<br> --> needed: " + moduleVersion 
								+ "<br> --> loaded: " 
								+ AbstractModule(module).getModuleVersion()
						);
					Console.getInstance().newLine();	
				}  else {
					// since it is an error trace it 
					trace(
						"Wrong module version: "
						+ this.filename 
						+ " needed: " 
						+ moduleVersion
						+ " laoded: "
						+ AbstractModule(module).getModuleVersion()
						);
				}
				return false;
			}
			// check success
			return true;
		}
		
		
		// =====================================================================
		// Eventhandler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * completeHandler
		 * ---------------------------------------------------------------------
		 * overridden to check if its a abstract module
		 *
		 * @param e		Complete Event
		 */
		override protected function completeHandler(e:Event):void 
		{
			
			var module:MovieClip = MovieClip(e.currentTarget.content);
			
			if( checkModule(module) )
			{
				if( this.targetContainer.contains(module) == false ) 
					this.targetContainer.addChild(module);
				
				AbstractModule(module).init();
			
			} else {
				this.loadingFailed = true;
			}
		
			super.completeHandler(e);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * progressHandler
		 * ---------------------------------------------------------------------
		 * overridden for instant adding
		 *
		 * @param e		Progress Event
		 */
		override protected function progressHandler(e:ProgressEvent):void 
		{
			if( this.myLoader.content != null ) 
			{
				if( this.instantAdd == true 
						&& this.wasAdded == false ) 
				{
					var module:MovieClip = MovieClip(myLoader.content);
					this.wasAdded = true;
					
					if( checkModule(module) )
						this.targetContainer.addChild(module);
				}
			}
			super.progressHandler(e);
		}
				
	}	
}