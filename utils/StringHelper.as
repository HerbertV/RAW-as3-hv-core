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
 * @version: 1.1.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2010-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.core.utils
{
	// =========================================================================
	// Class StringHelper
	// =========================================================================
	// Static Class 
	// with extensions for the String class
	//
	public class StringHelper
	{
		// =====================================================================
		// CONSTANTS
		// =====================================================================
		
		// Class Version
		public static const VERSION:String = "1.1.0";
		
		
		// =====================================================================
		// FUNCTIONS
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * replace
		 * ---------------------------------------------------------------------
		 * Original as3 String replace works with Regular Expressions
		 * sometimes I just want to replace something without a RegExp
		 * 
		 * @param str 			String to modify
		 * @param oldSubStr 	the sequence to be removed
		 * @param newSubStr		the sequence to be added
		 *
		 * @returns				the modified String
		 */
		public static function replace(
				str:String, 
				oldSubStr:String, 
				newSubStr:String 
			):String 
		{
			return str.split(oldSubStr).join(newSubStr);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * trim
		 * ---------------------------------------------------------------------
		 * There is no native trim for as3 String. 
		 * Trims both sides of a string
		 *
		 * @param str	the String to trim
		 * @param char 	the character trimmed
		 *
		 * @returns		the trimmed String
		 */
		public static function trim(
				str:String, 
				char:String
			):String 
		{
			return trimBack(
					trimFront(str, char), 
					char
				);
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * trimFront
		 * ---------------------------------------------------------------------
		 * trims only the front of a String
		 *
		 * @param str	the String to trim
		 * @param char 	the character trimmed
		 *
		 * @returns		the trimmed String
		 */
		public static function trimFront(
				str:String, 
				char:String
			):String 
		{
			char = strToChar(char);
			if( str.charAt(0) == char ) 
				str = trimFront(str.substring(1), char);
			
			return str;
		}
	
	
		/**
		 * ---------------------------------------------------------------------
		 * trimBack
		 * ---------------------------------------------------------------------
		 * trims only the back of a String
		 *
		 *
		 * @param str	the String to trim
		 * @param char 	the character trimmed
		 *
		 * @returns		the trimmed String
		 */
		public static function trimBack(
				str:String, 
				char:String
			):String 
		{
			char = strToChar(char);
			if( str.charAt(str.length - 1) == char )
				str = trimBack(str.substring(0, str.length - 1), char);
			
			return str;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * strToChar
		 * ---------------------------------------------------------------------
		 * converts a String into a char
		 */
		public static function strToChar(str:String):String 
		{
			if( str.length == 1 ) 
				return str;
			
			return str.slice(0, 1);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * replaceHTMLbrackets
		 * ---------------------------------------------------------------------
		 * replaces < and > with their entities &lt; and &gt;
		 * 
		 * @param str		String with brackets
		 *
		 * @returns			String with entities
		 */
		public static function replaceHTMLbrackets(str:String):String 
		{
			str = StringHelper.replace(str, "<", "&lt;");
			str = StringHelper.replace(str, ">", "&gt;");
			return str;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removeHTMLTags
		 * ---------------------------------------------------------------------
		 * removes all Tags
		 * 
		 * @param str		String with tags
		 *
		 * @returns			String without tags
		 */
		public static function removeHTMLTags(str:String):String 
		{
			var removeHtmlRegExp:RegExp = new RegExp("<[^<]+?>", "gi");
			str = str.replace(removeHtmlRegExp, "");
			return str;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * leadingZeros
		 * ---------------------------------------------------------------------
		 * converts an int into an string and adds leading zeros
		 * 
		 * @param i			integer to convert
		 * @param zeros		zero string represents also the digit count
		 *					default is "00", which adds one leading zero if
		 *					i is smaller 10
		 *
		 * @returns			integer as string with leading zeros
		 */
		public static function leadingZeros(
				i:int, 
				zeros:String="00"
			):String
		{
			var strInt:String = String(i);
			zeros = zeros.substring(0,zeros.length-strInt.length);
			
			return zeros+strInt;
		}
		
	}
}