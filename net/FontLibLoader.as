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
 * Copyright (c) 2010-2013 Herbert Veitengruber 
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
	
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
		
	/**
	 * =========================================================================
	 * Class FontLibLoader
	 * =========================================================================
	 * For loading an external swf that contains embedded fonts.
	 * Works with classic fonts and TLF fonts.
	 * 
	 * Note:
	 * TLF works only with Flash CS4+
	 * 
	 * Font linkage inside swf:
	 * Inside the swf the linked fonts class name must match one of the 
	 * arrays font names. Base class must be flash.text.Font. 
	 * 
	 * Usage:
	 * var fll = new FontLibLoader( 
	 * 			"data\\fonts.swf",
	 *			[ "FontHelveticaWorld",
	 *				"FontHelveticaWorldBold"
	 *			]
	 *		);
	 *	
	 * // add your listeners.
	 *	
	 * fll.load();
	 *	
	 * now access it from everywhere with:
	 * FontLibLoader.getInstance();
	 * 
	 */
	public class FontLibLoader
			extends AssetLoader 
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		// static singleton instance 
		private static var myInstance:FontLibLoader;
				
		private var fontsDomain:ApplicationDomain;
 	 	
		private var fonts:Array;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 * 
		 * @param file filename with relative/absolute path
		 * @param fnames array of font class names
		 */
		public function FontLibLoader(
				file:String,
				fnames:Array
			)
		{
			super(file,"FontLibLoader");
			
			if ( myInstance ) 
				throw new Error ("FontLibLoader is a singleton class, use getInstance() instead"); 
				
			this.fonts = fnames;
 	 	 	
			FontLibLoader.myInstance = this;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getInstance
		 * ---------------------------------------------------------------------
		 *
		 * @return	the instance of the FontLibLoader
		 */
		public static function getInstance():FontLibLoader
		{
			return FontLibLoader.myInstance;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * registerFonts
		 * ---------------------------------------------------------------------
		 * registers all fonts from our loaded swf lib
		 */
		private function registerFonts(arr:Array):void 
		{
 	 	 	for( var i:int = 0; i < arr.length; i++ )
 	 	 	 	Font.registerFont(getFontClass(arr[i]));
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFontClass
		 * ---------------------------------------------------------------------
		 * @param classname
		 *
		 * @return 
		 */
		public function getFontClass(classname:String):Class 
		{
 	 	 	return this.fontsDomain.getDefinition(classname) as Class;
 	 	}
		
 	 	/**
		 * ---------------------------------------------------------------------
		 * getFont
		 * ---------------------------------------------------------------------
		 * @param classname
		 *
		 * @return 
		 */
		public function getFont(classname:String):Font
		{
 	 	 	var fontClass:Class = getFontClass(id);
 	 	 	return new fontClass as Font;
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
			this.fontsDomain = this.myLoader.contentLoaderInfo.applicationDomain;
 	 	 	registerFonts(fonts);
			super.completeHandler(e);
		}
				
				
	}	
}