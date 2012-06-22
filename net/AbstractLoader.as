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
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	// =========================================================================
	// Class AbstractLoader
	// =========================================================================
	// Abstract base for all loaders.
	// 
	public class AbstractLoader
			implements IEventDispatcher
	{
		// =====================================================================
		// Variables
		// =====================================================================
		// stay awhile and listen
		protected var dispatcher:EventDispatcher;
		
		// to identify a loader
		protected var myName:String;
		// the file to load
		protected var filename:String;
		
		protected var intBytesLoaded:int;
		protected var intBytesTotal:int;
		
		protected var loadingFinished:Boolean;
		protected var loadingFailed:Boolean;
		
		// for serialized loading.
		protected var nextLoader:AbstractLoader;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		/**
		 * Constructor
		 * 
		 * @param file filename with relative/absolute path
		 * @param name (optional)
		 */
		public function AbstractLoader(
				file:String,
				name:String=""
			)
		{
			this.myName = name;
			this.filename = file;
			
			this.intBytesLoaded = 0;
			this.intBytesTotal = 0;
			this.loadingFinished = false;
			this.loadingFailed = false;
			
			this.dispatcher = new EventDispatcher(this);
			this.nextLoader = null;
		}
		
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * load
		 * ---------------------------------------------------------------------
		 * needs to be overridden. Will start the loading.
		 */
		public function load():void
		{
			throw new Error("AbstractLoader load() is not implemented");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * dispose
		 * ---------------------------------------------------------------------
		 * needs to be overridden
		 */
		public function dispose():void
		{
			this.dispatcher = null;
			this.filename = null;
			this.myName = null;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getName
		 * ---------------------------------------------------------------------
		 * @return
		 */
		final public function getName():String
		{
			return this.myName;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getFilename
		 * ---------------------------------------------------------------------
		 * @return
		 */
		final public function getFilename():String
		{
			return this.filename;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBytesTotal
		 * ---------------------------------------------------------------------
		 * @return
		 */
		final public function getBytesTotal():int
		{
			return this.intBytesTotal;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBytesLoaded
		 * ---------------------------------------------------------------------
		 * @return
		 */
		final public function getBytesLoaded():int
		{
			return this.intBytesLoaded;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getPercentLoaded
		 * ---------------------------------------------------------------------
		 * 
		 * @return percent 0-100
		 */
		final public function getPercentLoaded():int
		{
			return int( this.intBytesLoaded/this.intBytesTotal * 100 );
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isLoadingFinished
		 * ---------------------------------------------------------------------
		 * @return
		 */
		final public function isLoadingFinished():Boolean
		{
			return this.loadingFinished;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isLoadingFailed
		 * ---------------------------------------------------------------------
		 * @return
		 */
		final public function isLoadingFailed():Boolean
		{
			return this.loadingFailed;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * addNext
		 * ---------------------------------------------------------------------
		 * add new loader that is loaded after this one is finished or failed.
		 *
		 * @param loader
		 */
		final public function addNext(loader:AbstractLoader):void
		{
			this.nextLoader = loader;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getNext
		 * ---------------------------------------------------------------------
		 * the next loader form our serialized loader chain.
		 * use this in a complete and/or ioError listener 
		 * and call load() afterwards.
		 *
		 * @return
		 */
		final public function getNext():AbstractLoader
		{
			return this.nextLoader;
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * completeHandler
		 * ---------------------------------------------------------------------
		 * internal event handler
		 * needs to be overridden
		 *
		 * @param e			Event
		 */
		protected function completeHandler(e:Event):void 
		{
			this.loadingFinished = true;
			
			if( Console.isConsoleAvailable() ) 
			{
				Console.getInstance().writeln(
						"Loading Complete: ",
						DebugLevel.INFO,
						" --> "+ this.filename
					);
				Console.getInstance().newLine();	
			} 
			
			// look whos watching
			this.dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * ioErrorHandler
		 * ---------------------------------------------------------------------
		 * internal event handler
		 * needs to be overridden
		 *
		 * @param e			IOErrorEvent
		 */
		protected function ioErrorHandler(e:IOErrorEvent):void 
		{
            if( Console.isConsoleAvailable() ) 
			{
				Console.getInstance().writeln(
						"IOError while loading",
						DebugLevel.ERROR,
						" --> "+ this.filename
					);
				Console.getInstance().newLine();	
	
			} else {
				// since it is an error trace it 
				trace("IO Error while loading: "+ this.filename);
			}
			
			this.loadingFailed = true;
			// look whos watching
			this.dispatcher.dispatchEvent(e.clone());
		}

		/**
		 * ---------------------------------------------------------------------
		 * progressHandler
		 * ---------------------------------------------------------------------
		 * internal event handler
		 *
		 * @param e			ProgressEvent
		 */
		protected function progressHandler(e:ProgressEvent):void 
		{
			//update vars
			this.intBytesTotal = e.bytesTotal;
			this.intBytesLoaded = e.bytesLoaded;
			
			// look whos watching
			this.dispatcher.dispatchEvent(e.clone());
		}
		
		
		// =====================================================================
		// IEventDispatcher functions
		// =====================================================================
		// redirect all to dispatcher
		//
		// @see flash.events.IEventDispatcher
		// @see flash.events.EventDispatcher
		/**
		 * ---------------------------------------------------------------------
		 * addEventListener
		 * ---------------------------------------------------------------------
		 */
		final public function addEventListener(
				type:String, 
				listener:Function, 
				useCapture:Boolean = false, 
				priority:int = 0, 
				useWeakReference:Boolean = false
			):void
		{
        	dispatcher.addEventListener(
					type, 
					listener, 
					useCapture, 
					priority
				);
		}
			   
		/**
		 * ---------------------------------------------------------------------
		 * dispatchEvent
		 * ---------------------------------------------------------------------
		 */
		final public function dispatchEvent(evt:Event):Boolean
		{
			return dispatcher.dispatchEvent(evt);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * hasEventListener
		 * ---------------------------------------------------------------------
		 */
		final public function hasEventListener(type:String):Boolean
		{
			return dispatcher.hasEventListener(type);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removeEventListener
		 * ---------------------------------------------------------------------
		 */
		final public function removeEventListener(
				type:String, 
				listener:Function, 
				useCapture:Boolean = false
			):void
		{
			dispatcher.removeEventListener(
					type, 
					listener, 
					useCapture
				);
		}
					   
		/**
		 * ---------------------------------------------------------------------
		 * willTrigger
		 * ---------------------------------------------------------------------
		 */
		final public function willTrigger(type:String):Boolean 
		{
			return dispatcher.willTrigger(type);
		}
		
	}	
}