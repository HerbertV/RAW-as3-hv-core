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
 * Copyright (c) 2013 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.core.xml 
{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import as3.hv.components.progress.IProgressSymbol;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.DebugLevel;
	
	/**
	 * =========================================================================
	 * Class XMLProcessorR
	 * =========================================================================
	 * Read-Only XML Processor
	 * uses AS3 XML classes
	 */ 
	public class XMLProcessorR 
			extends AbstractXMLProcessor 
	{
		// =====================================================================
		// Variables
		// =====================================================================
		protected var myLoader:URLLoader;
		
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 */
		public function XMLProcessorR() 
		{
			super();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * loadXML
		 * ---------------------------------------------------------------------
		 * @param filename
		 * @param progressSym
		 */
		override public function loadXML(
				filename:String, 
				progressSym:IProgressSymbol = null
			):void
		{
			this.loadingFailed = false;
			this.loadingFinished = false;
			this.myFilename = filename;
			
			
			var myURL:URLRequest = new URLRequest(filename);
			this.myLoader = new URLLoader(myURL);
			
			this.myLoader.addEventListener(
					Event.COMPLETE, 
					completeHandler
				);
			this.myLoader.addEventListener(
					IOErrorEvent.IO_ERROR, 
					ioErrorHandler
				);
			
			this.myProgressSymbol = progressSym;
			
			if( this.myProgressSymbol != null )
			{
				this.myProgressSymbol.init();
				this.myLoader.addEventListener(
						ProgressEvent.PROGRESS, 
						progressHandler
					);
			}
			
			if( Console.isConsoleAvailable() )
				Console.getInstance().writeln(
						"loading XML: ",
						DebugLevel.INFO,
						filename
					);
		}
	
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * progressHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function progressHandler(e:ProgressEvent):void
		{
        	var percent:int = int(e.bytesLoaded/e.bytesTotal*100);
			
			if( this.myProgressSymbol != null )
				this.myProgressSymbol.setProgressTo(percent,"loading XML...");
		}

		/**
		 * ---------------------------------------------------------------------
		 * completeHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function completeHandler(e:Event):void
		{
    		this.myXML = XML(this.myLoader.data);
			this.loadingFinished = true;
			
			if( this.myProgressSymbol != null ) 
			{
				this.myProgressSymbol.hide();
				this.myLoader.removeEventListener(
						ProgressEvent.PROGRESS, 
						progressHandler
					);
			}
			
			this.myLoader.removeEventListener(
					Event.COMPLETE, 
					completeHandler
				);
			this.myLoader.removeEventListener(
					IOErrorEvent.IO_ERROR, 
					ioErrorHandler
				);
			
			if( Console.isConsoleAvailable() )
				Console.getInstance().writeln(
						"loading finished: ",
						DebugLevel.INFO,
						this.myFilename
					);
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * ioErrorHandler
		 * ---------------------------------------------------------------------
		 * @param e
		 */
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
           if( Console.isConsoleAvailable() )
			{
				Console.getInstance().writeln(
						"IO Error while loading XML: ",
						DebugLevel.ERROR,
						this.myFilename
							+ "<br>" + e.toString()
					);
				Console.getInstance().newLine();
			}
			
			if( this.myProgressSymbol != null ) 
			{
				this.myProgressSymbol.hide();
				this.myLoader.removeEventListener(
						ProgressEvent.PROGRESS, 
						progressHandler
					);
			}
			
			this.myLoader.removeEventListener(
					Event.COMPLETE, 
					completeHandler
				);
			this.myLoader.removeEventListener(
					IOErrorEvent.IO_ERROR,
					ioErrorHandler
				);
			
			this.loadingFailed = true;
			// look whos watching
			this.dispatchEvent(e.clone());
        }
	}

}