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
	
	import flash.text.StyleSheet;
	
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	// =========================================================================
	// Class CSSLoader
	// =========================================================================
	// for loading CSS files
	public class CSSLoader 
			extends AssetURLLoader 
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		private var myCSS:StyleSheet = null;
		
		// =====================================================================
		// Constructors
		// =====================================================================
		
		public function CSSLoader()
		{
			super();
			
			this.myCSS = new StyleSheet();
		}
		
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getCSS
		 * ---------------------------------------------------------------------
		 * returns the loaded css. returns null if the loading is still in
		 * progress or failed
		 *
		 * @return 
		 */
		public function getCSS():StyleSheet 
		{
			if( this.loadingFinished == true 
					&& this.loadingFailed == false ) 
				return this.myCSS;
			
			return null;
		}
		
		
		// =====================================================================
		// Eventhandler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * completeHandler
		 * ---------------------------------------------------------------------
		 * overridden to parse the CSS.
		 *
		 * @param e		Complete Event
		 */
		override protected function completeHandler(e:Event):void 
		{
			this.myCSS.parseCSS(this.myLoader.data);
			
			super.completeHandler(e);
		}

	}
}