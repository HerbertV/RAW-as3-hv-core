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
	
	// =========================================================================
	// Class AbstractModule
	// =========================================================================
	// Abstract base class for external SWF modules.
	// Can be loaded with ModuleLoader.
	//
	// Each external module needs an implementation of this class, which is 
	// linked as document class within your fla.
	//
	// NOTE:
	// The Module fla has to be published within the same folder as your
	// root fla. After publishing you can move the swf file into any subfolder
	// you want.
	public class AbstractModule
			extends MovieClip
	{
		// =====================================================================
		// Constants
		// =====================================================================
		
		public static const VERSION:String = "1.0.0";
		
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		// set the variable within your fla's timeline on true.
		// this is for intro anmiations usefull
		protected var iamReady:Boolean = false;
		
		// to check if the module has the correct version for the root fla
		protected var moduleVersion:String = "n.a.";
		
		// =====================================================================
		// Constructors
		// =====================================================================
		
		public function AbstractModule()
		{
			super();
		}
				
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * isReady
		 * ---------------------------------------------------------------------
		 *
		 * @return 
		 */
		public function isReady():Boolean
		{
			return iamReady;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getModuleVersion
		 * ---------------------------------------------------------------------
		 *
		 * @return 
		 */
		public function getModuleVersion():String
		{
			return moduleVersion;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * checkModuleVersion
		 * ---------------------------------------------------------------------
		 * @param version
		 *
		 * @return 
		 */
		public function checkModuleVersion(
				version:String
			):Boolean 
		{
			if( version == moduleVersion )
				return true;
			
			return false;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * init
		 * ---------------------------------------------------------------------
		 * abstract needs to be overridden.
		 */
		public function init():void
		{
			throw new Error("AbstractModule init() is abstract. Needs override.");    
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 * abstract needs to be overridden.
		 */
		public function dispose():void
		{
			throw new Error("AbstractModule dispose() is abstract. Needs override.");    
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateLanguage
		 * ---------------------------------------------------------------------
		 * for multilingual modules.
		 * override it if you need it.
		 *
		 * @param newLangCode 	e.g. 3-letter-language code 
		 *						or 2-letter-language-code
		 */
		public function updateLanguage(
				newLangCode:String=null
			):void
		{
			// override if you need me
		}
		
	}
}