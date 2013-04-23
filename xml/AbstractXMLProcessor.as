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
	import flash.display.Sprite;
	
	/**
	 * =========================================================================
	 * Class AbstractXMLProcessor
	 * =========================================================================
	 * Abstract base for XML file handling.
	 * Manages loading and parsing.
	 * 
	 * uses AS3 XML classes
	 */ 
	public class AbstractXMLProcessor 
			extends Sprite 
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		// Note:
		// for me it makes sense that a project using xml file(s) 
		// use one xsd where all xml files use the same root tag and doc version.
		//
		// XML Roottag example:
		// <ROOTTAGNAME 
		// 		XMLVersion="versionumber" 
		// 		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		// 		xsi:noNamespaceSchemaLocation="your.xsd"> 
		// 
		public static var XMLDOCVERSION:String = "0.0";
		public static var XMLROOTTAG:String = "undefined";
		
		// the xml
		protected var myXML:XML = null;
				
		protected var myFilename:String;
		
		protected var loadingFinished:Boolean = false;
		protected var loadingFailed:Boolean = false;
		
		protected var parsingFinished:Boolean = false;
		protected var parsingFailed:Boolean = false;
		protected var parseStep:int = 0;
		
		protected var myProgressSymbol:IProgressSymbol = null;
		
				
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 */
		public function AbstractXMLProcessor() 
		{
			super();
			
			this.myXML = new XML();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * checkDoc
		 * ---------------------------------------------------------------------
		 * checks the root tag and the doc version. 
		 *
		 * @param xmldoc the xml to check
		 * 
		 * @return
		 */
		public static function checkDoc(
				xmldoc:XML
			):Boolean
		{
			if( xmldoc.name().localName != XMLROOTTAG )
			{
				if( Console.isConsoleAvailable() )
				{
					Console.getInstance().writeln(
							"Not a valid " + XMLROOTTAG + " XML.",
								DebugLevel.FATAL_ERROR
							);
					Console.getInstance().newLine();
				}
				return false;
			}
			
			if( xmldoc.@XMLVersion != XMLDOCVERSION )
			{
				if( Console.isConsoleAvailable() )
				{
					Console.getInstance().writeln(
							"XML doc version is not " + XMLDOCVERSION,
								DebugLevel.FATAL_ERROR
							);
					Console.getInstance().newLine();
				}
				return false;
			}
			return true;	
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * initFrameBasedParsing
		 * ---------------------------------------------------------------------
		 * in most cases unneccesary, but complex/large xmls where xml info needs
		 * to be converted into a object structure, this can be usefull.
		 * 
		 * @param parentClip
		 * @param progressSym
		 */
		public function initFrameBasedParsing(
				parentClip:MovieClip, 
				progressSym:IProgressSymbol = null
			)
		{
			this.parsingFinished = false;
			this.parsingFailed = false;
			this.parseStep = 0;
			
			this.myProgressSymbol = progressSym;
			
			parentClip.addChild(this);
			this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		
			if( this.myProgressSymbol != null )
				this.myProgressSymbol.init();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * loadXML
		 * ---------------------------------------------------------------------
		 * abstract
		 * 
		 * @param filename
		 * @param progressSym
		 */
		public function loadXML(
				filename:String, 
				progressSym:IProgressSymbol = null
			):void
		{
			// Abstract NEEDS OVEERRIDE
			trace("AbstractXMLProcessor.loadXML: NEEDS OVEERRIDE");
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * getXML
		 * ---------------------------------------------------------------------
		 * @return 
		 */
		final public function getXML():XML 
		{
			return this.myXML;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setXML
		 * ---------------------------------------------------------------------
		 * param xmldoc 
		 */
		final public function setXML(xmldoc:XML) 
		{
			this.myXML = xmldoc;
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
		 * isParsingFinished
		 * ---------------------------------------------------------------------
		 * @return
		 */
		final public function isParsingFinished():Boolean
		{
			return this.parsingFinished;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isParsingFailed
		 * ---------------------------------------------------------------------
		 * @return
		 */
		final public function isParsingFailed():Boolean
		{
			return this.parsingFailed;
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * enterFrameHandler
		 * ---------------------------------------------------------------------
		 * abstract
		 * 
		 * @param e
		 */
		protected function enterFrameHandler(e:Event):void 
		{
			// Abstract NEEDS OVEERRIDE
			trace("AbstractXMLProcessor.enterFrameHandler: NEEDS OVEERRIDE");
			this.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
	}

}