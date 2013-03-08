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
package as3.hv.core.utils 
{
	/**
	 * =========================================================================
	 * Class AutoCompleter
	 * =========================================================================
	 * Static helper class for auto complete strings.
	 */
	public class AutoCompleter 
	{
		
		/**
		 * ---------------------------------------------------------------------
		 * filterList
		 * ---------------------------------------------------------------------
		 * it returns all items that start with the given prefix.
		 * 
		 * @param prefix the prefix to look for
		 * @param list the list to search
		 * 
		 * @return the filtered list
		 */
		public static function filterList(prefix:String, list:Array):Array
		{
			var filtered:Array = new Array();
			
			for each( var item:String in list )
				if( item.indexOf(prefix) == 0 )
					filtered.push(item);
			
			return filtered;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * findBestMatch
		 * ---------------------------------------------------------------------
		 * it auto completes the prefix with characters as long each item
		 * of the list has the same matching character. 
		 * 
		 * @param prefix
		 * @param list
		 * 
		 * @return the completed string.
		 */
		public static function findBestMatch(prefix:String, list:Array):String
		{
			if( list.length == 0 )
				return prefix;
			
			if( list.length == 1 )
				return list[0];
				
			var bestmatch:String = prefix;
			var charidx:int = prefix.length;
			var currChar:String = "";
			var seek:Boolean = true;
			
			while( seek ) 
			{
				// look into every item for the matching char.
				for each( var item:String in list )
				{
					// item end reached: we are done
					if( item.length <= charidx )
						return bestmatch;
					
					// char not set this round
					if( currChar == "" )
					{
						currChar = item.substr(charidx, 1);
						continue;
					}
					// compare chars: if they don't match we are done
					if( currChar != item.substr(charidx, 1) )
						return bestmatch;
				}
				// prepare for next round
				charidx++;
				bestmatch += currChar;
				currChar = "";
			}
			return bestmatch;
		}
	}

}