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
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import flash.text.TextField;
	
	// =========================================================================
	// Class HTMLLoader
	// =========================================================================
	// for loading HTML files into a text field.
	//
	public class HTMLLoader 
			extends AssetURLLoader 
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		private var myHTML:String  = "";
				
		private var myTarget:TextField = null;
		
		
		// =====================================================================
		// Constructors
		// =====================================================================
		
		/**
		 * Constructor		
		 *
		 * @param target	Target text field (optional)
		 */
		public function HTMLLoader( target:TextField=null )
		{
			super();
			
			this.myTarget = target;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getHTML
		 * ---------------------------------------------------------------------
		 * returns the loaded HTML as string or an empty string if the laoding
		 * is still in progress or failed.
		 *
		 * @return 
		 */
		public function getHTML():String 
		{
			if( this.loadingFinished == true 
					&& this.loadingFailed == false ) 
				return this.myHTML;
			
			return "";
		}
		
		// =====================================================================
		// Eventhandler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * completeHandler
		 * ---------------------------------------------------------------------
		 * overridden to parse the HTML.
		 *
		 * @param e		Complete Event
		 */
		override protected function completeHandler(e:Event):void 
		{
			this.myHTML = this.myLoader.data;
			if (this.myTarget != null) 
			{
				this.myTarget.htmlText = this.myHTML;
				this.myTarget.scrollV = 1;
			}
			super.completeHandler(e);
		}
				
	}
}