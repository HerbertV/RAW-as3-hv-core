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
		/**
		 * Constructor
		 * 
		 * @param file filename with relative/absolute path
		 * @param name (optional)
		 */
		public function AssetLoader(
				file:String,
				name:String=""
			)
		{
			super(file,name);
		}
				
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * load
		 * ---------------------------------------------------------------------
		 * overridden to start the loader and add the event listeners 
		 */
		override public function load():void
		{
			if( filename == null || filename == "" )
				throw new Error(this.myName + " has no filename");
			
			this.myLoader = new Loader();
			this.myLoader.load(new URLRequest(filename));
			
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
			
			if( this.myLoader == null )
				return;
				
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
			if( this.myLoader != null )
				return this.myLoader.content;
			
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
			
			if( this.myLoader == null )
				return;
				
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
			
			if( this.myLoader == null )
				return;
				
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