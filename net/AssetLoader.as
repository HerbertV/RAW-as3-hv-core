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
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	
	// =========================================================================
	// Class AssetLoader
	// =========================================================================
	// This loader is based on flash.display.Loader, so it is usefull for
	// loading images, SWFs and FLVs.
	// 
	public class AssetLoader
			extends AbstractLoader
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		protected var myLoader:Loader = null;
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function AssetLoader()
		{
			super();
		}
		
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * loadFile
		 * ---------------------------------------------------------------------
		 * overridden to init the loader and add the event listeners 
		 *
		 * @param file		filename with relative/absolute path
		 */
		override public function loadFile(file:String)
		{
			super.loadFile(file);
			
			this.myLoader = new Loader();
			this.myLoader.load(new URLRequest(file));
			
			this.myLoader.contentLoaderInfo.addEventListener(
					IOErrorEvent.IO_ERROR, 
					ioErrorHandler
				);
            this.myLoader.contentLoaderInfo.addEventListener(
					ProgressEvent.PROGRESS, 
					progressHandler
				);
			this.myLoader.contentLoaderInfo.addEventListener(
					Event.COMPLETE, 
					completeHandler
				);
        }
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 */
		override public function dispose():void
		{
			super.dispose();
			
			this.myLoader.contentLoaderInfo.removeEventListener(
					IOErrorEvent.IO_ERROR, 
					ioErrorHandler
				);
			this.myLoader.contentLoaderInfo.removeEventListener(
					ProgressEvent.PROGRESS, 
					progressHandler
				); 
			this.myLoader.contentLoaderInfo.removeEventListener(
					Event.COMPLETE, 
					completeHandler
				); 
						
			this.myLoader.close();
			this.myLoader = null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getContent
		 * ---------------------------------------------------------------------
		 * returns the loaded content 
		 *
		 * @return			content as object
		 */
		public function getContent():Object
		{
			if (this.myLoader != null) {
				return this.myLoader.content;
			}
			return null;
		}
		
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * completeHandler
		 * ---------------------------------------------------------------------
		 * internal event handler
		 *
		 * @param e			Event
		 */
		override protected function completeHandler(e:Event):void 
		{
			super.completeHandler(e);
			
			this.myLoader.contentLoaderInfo.removeEventListener(
					IOErrorEvent.IO_ERROR, 
					ioErrorHandler
				);
			this.myLoader.contentLoaderInfo.removeEventListener(
					ProgressEvent.PROGRESS, 
					progressHandler
				); 
			this.myLoader.contentLoaderInfo.removeEventListener(
					Event.COMPLETE, 
					completeHandler
				); 
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * ioErrorHandler
		 * ---------------------------------------------------------------------
		 * internal event handler
		 *
		 * @param e			IOErrorEvent
		 */
		override protected function ioErrorHandler(e:IOErrorEvent):void 
		{
        	super.ioErrorHandler(e);
			
			this.myLoader.contentLoaderInfo.removeEventListener(
					IOErrorEvent.IO_ERROR, 
					ioErrorHandler
				);
			this.myLoader.contentLoaderInfo.removeEventListener(
					ProgressEvent.PROGRESS, 
					progressHandler
				); 
			this.myLoader.contentLoaderInfo.removeEventListener(
					Event.COMPLETE, 
					completeHandler
				); 
		}
		
	}
}