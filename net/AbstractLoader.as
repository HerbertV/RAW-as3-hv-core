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
		protected var dispatcher:EventDispatcher;

		protected var filename:String;
		
		protected var intBytesLoaded:int;
		protected var intBytesTotal:int;
		
		protected var loadingFinished:Boolean;
		protected var loadingFailed:Boolean;
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		public function AbstractLoader()
		{
			this.dispatcher = new EventDispatcher(this);
		}
		
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * loadFile
		 * ---------------------------------------------------------------------
		 * needs to be overridden.
		 * 
		 * @param file		filename with relative/absolute path
		 */
		public function loadFile(file:String)
		{
			this.intBytesLoaded = 0;
			this.intBytesTotal = 0;
			this.filename = file;
			this.loadingFinished = false;
			this.loadingFailed = false;
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
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBytesTotal
		 * ---------------------------------------------------------------------
		 */
		final public function getBytesTotal():int
		{
			return this.intBytesTotal;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getBytesLoaded
		 * ---------------------------------------------------------------------
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
		 */
		final public function isLoadingFinished():Boolean
		{
			return this.loadingFinished;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isLoadingFailed
		 * ---------------------------------------------------------------------
		 */
		final public function isLoadingFailed():Boolean
		{
			return this.loadingFailed;
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