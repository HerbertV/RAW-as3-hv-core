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
				
		/**
		 * =====================================================================
		 * Contructor
		 * =====================================================================
		 */
		public function AbstractXMLProcessor() 
		{
			super();
			
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
		
		
	}

}