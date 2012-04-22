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
package as3.hv.core.math
{
	import flash.events.Event;

	// =========================================================================
	// Class TrueRandom
	// =========================================================================
	//
	// A class for solving the basic problems with random Numbers.
	//
	// If you call the as3 Math.random() function with the same min/max span 
	// during one frame several times, there can be a lot of doubletts.
	// Especially if you generate integer values within a small min/max span.
	//
	// To avoid this, this class can pre-generate random number for later use.
	//
	// Additional this class provides a seeded generator based on 
	// "Lehmer random number generator": 
	// @see http://en.wikipedia.org/wiki/Lehmer_random_number_generator
	//
	public class TrueRandom
	{
		// =====================================================================
		// CONSTANTS
		// =====================================================================
		
		// Class Version
		public static const VERSION:String = "1.0.0";
		
		
		// =====================================================================
		// VARIABLES
		// =====================================================================
		
		// stores the pre-generated non-seeded random numbers
		private var rndCache:Array = null;
		// size of the cache
		private var cacheSize:uint = 0;
		// also if the cache is full it will be still refreshed
		// to add more "randomness".
		// The counter is to count the number of calls until a new refresh is 
		// done.
		private var cacheRefreshCounter:int = 0;
				
		// A callback function that returns a random number.
		// The function needs the min/max parameters, like:
		// function generateRandomInt(min:int,max:int=-1):int
		private var generatorCallback:Function = null;
		// min value for the callback
		private var minValue:Number = 0;
		// max value for the callback
		private var maxValue:Number = 0;
		
		// the very first seed 
		private var initialSeed:uint = 0;
		// current seed for seeded generation
		private var rndSeed:uint = 1;
		
		// =====================================================================
		// CONSTRUCTOR
		// =====================================================================
		
		/**
		 * Constructor
		 *
		 * creates a TrueRandom instance.
		 * 
		 * @param isSeeded		default is false, so a non-seeded generation
		 * 						is used.
		 *
		 * @param cacheSizeOrSeed
		 * 						size of our random cache if non-seeded, 
		 * 						default is 10.
		 *						Or the seed. If the seed is 0 the current
		 *						time is set as seed.
		 */
		public function TrueRandom(
				isSeeded:Boolean=false,
				cacheSizeOrSeed:uint=10
			)
		{
			this.rndCache = new Array();
			
			if( isSeeded )
			{
				if( cacheSizeOrSeed == 0 )
					this.initialSeed = (new Date()).getTime();
				else
					this.initialSeed = cacheSizeOrSeed;
					
				this.rndSeed = this.initialSeed;	
			
			} else {
				this.cacheSize = cacheSizeOrSeed;
			}
		}
		
		
		// =====================================================================
		// FUNCTIONS
		// =====================================================================
				
		/**
		 * ---------------------------------------------------------------------
		 * setupGenerator
		 * ---------------------------------------------------------------------
		 * Call this function to setup the non-seeded random generator, with
		 * a cache the generates random values before you need them.
		 *
		 * @param generator	Callback function that generates a random Number.
		 * 					The function needs the min/max parameters, like:
		 * 					function generateRandomInt(min:int,max:int=-1):int
		 *
		 * @param min		Minimum value parameter for the callback
		 *
		 * @param max 		Maximum value parameter for the callback
		 */
		public function setupGenerator(
				generator:Function,
				min:Number,
				max:Number
			):void
		{
			this.generatorCallback = generator;
			this.minValue = min;
			this.maxValue = max;
		}
			
		/**
		 * ---------------------------------------------------------------------
		 * fillUpCache
		 * ---------------------------------------------------------------------
		 * Adds a new value to the cache every time it is called.
		 * If the cache size is reached, it is only refreshed after each 10th 
		 * call.
		 *
		 * Useable only for non-seeded generation.
		 *
		 * Call this function in your ENTER_FRAME or EXIT_FRAME event listener,
		 * so it can fill up during your movieclip runs.
		 *
		 * @param e 	The event. It is needed, if you add this function
		 *				as a direct ENTER_FRAME/EXIT_FRAME event listener callback
		 */
		public function fillUpCache(e:Event):void
		{
			// fail save 
			if( generatorCallback == null )
				return;
				
			// fill the cache if not full or refresh it 
			// after 10 calls
			if( rndCache.length < cacheSize 
					|| cacheRefreshCounter == 10 )
			{
				rndCache.push( generatorCallback(minValue,maxValue) );
				
				// if we refresh the cache, we remove also the first value 
				if( cacheRefreshCounter == 10 )
				   rndCache.shift()
				   
				cacheRefreshCounter = 0;
			
			} else {
				cacheRefreshCounter++;
			}
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * nextCachedNumber
		 * ---------------------------------------------------------------------
		 * To get the first value from our cache.
		 *
		 * Useable only for non-seeded generation.
		 *
		 * @returns 	Returns the first value from our non-seeded random 
		 *				cache. The value type depends on the generator callback.
		 */
		public function nextCachedNumber():Number
		{
			// fail save 
			if( generatorCallback == null )
				return 0;
				
			// fail save, if cache is empty
			if( rndCache.length == 0 )
				return generatorCallback(minValue,maxValue);
				
			return rndCache.shift();	
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * getInitialSeed
		 * ---------------------------------------------------------------------
		 * Useable only for seeded generation.
		 *
		 * @returns 	Getter for the initial seed.
		 */
		public function getInitialSeed():uint
		{
			return this.initialSeed;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * generateNextSeed
		 * ---------------------------------------------------------------------
		 * internal for seeded generation
		 *
		 * @returns 	The next seed.
		 */
		private function nextSeed():uint
		{
			return rndSeed = (rndSeed * 16807) % 2147483647;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * nextSeededInt
		 * ---------------------------------------------------------------------
		 * Useable only for seeded generation.
		 *
		 * @returns 	Seeded unsigned int
		 */
		public function nextSeededInt():uint
		{
			return nextSeed();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * nextSeededNumber
		 * ---------------------------------------------------------------------
		 * Useable only for seeded generation.
		 *
		 * @param percision	(optional) Maximum number of decimals after 
		 *					the floating point
		 *
		 * @returns		Seeded Number(float) 
		 */
		public function nextSeededNumber(
				percision:uint=0
			):Number
		{
			var num:Number = nextSeed() / 2147483647;
			
			if( percision > 0 )
				num = TrueRandom.trunc(num,percision);
			
			return num;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * nextRangedSeededInt
		 * ---------------------------------------------------------------------
		 * Useable only for seeded generation.
		 *
		 * @param min 	Minimum value.
		 * @param max 	Maximum value. 
		 *				Optional, if only a min value is given, the range is 
		 *				from 0 to min
		 *
		 * @returns 	ranged seeded unsigned int from min - max or 0 - min.
		 */
		public function nextRangedSeededInt(
				min:int, 
				max:int=-1
			):uint
		{
			if( max == -1 ) 
			{
				max = min;
				min = 0;
			}
			return Math.round(nextSeededNumber() * (max-min)) + min;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * nextRangedSeededNumber
		 * ---------------------------------------------------------------------
		 * Useable only for seeded generation.
		 *
		 * @param min 			Minimum value.
		 * @param max 			(optional) Maximum value. 
		 *						If only a min value is given, the range is 
		 *						from 0 to min
		 * @param percision 	(optional) Number of decimals after the 
		 *						floating point
		 *
		 * @returns 		ranged seeded Number(float) from min - max.
		 */
		public function nextRangedSeededNumber(
				min:Number, 
				max:Number,
				percision:uint=0
			):Number
		{
			var num:Number = (nextSeededNumber() * (max-min)) + min;
			
			if( percision > 0 )
				num = TrueRandom.trunc(num,percision);
			
			return num;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * trunc
		 * ---------------------------------------------------------------------
		 * Just a little static helper to truncate a float.
		 * 
		 * @param num 			The float to truncate.
		 * @param percision 	(optional) number of decimals after the 
		 *						floating point
		 * 
		 * @returns			The truncated float.
		 */
		public static function trunc(
				num:Number, 
				percision:uint
			):Number
		{
			if( percision > 0 )
			{
				var multiplier:uint = Math.pow(10, percision);
				num = Math.round(num * multiplier) / multiplier
			}
			return num;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * generateRangedInt
		 * ---------------------------------------------------------------------
		 * uses Math.random(), so it is non-seeded
		 *
		 * Static function returns an integer between minimum and maximum value.
		 * min and max have to be >= 0
		 *
		 * ---------------------------------------------------------------------
		 * NOTE to me:
		 * ---------------------------------------------------------------------
		 * A lot of examples including Math.random() use:
		 * 		Math.floor(Math.random() * (max-min +1)) + min
		 *
		 * But this is wrong, Math.floor() rounds down to the previous integer, 
		 * and therefore they add +1 in the multiplier.
		 * But in the case of min=0 and max=1 it returns values between 0 and 2.
		 * If Math.random() returns  1.0 insert it into the formular:
		 * 		(1.0 * 1 - 0 + 1) = 2 
		 * 
		 * instead of adding + 1 you have to add + 0.5 if you want to use 
		 * Math.floor(). But you can also use Math.round() and you have nothing
		 * to add anymore.
		 * 
		 * I came up with this solution after accessing random elements from an
		 * array where I got a lot "RangeErrors" since the index was out of 
		 * bounds.
		 * 
		 * @param min  		Minimum value.
		 * @param max 		(optional) Maximum value. 
		 *					If only a min value is given, the range is 
		 *					from 0 to min
		 *
		 * @returns 	 	ranged unsigned int from min - max or 0 - min.
		 */
		public static function generateRangedInt(
				min:int, 
				max:int=-1
			):int
		{
			if( max == -1 ) 
			{
				max = min;
				min = 0;
			}
			return Math.round(Math.random() * (max-min)) + min;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * generateRandomSignedMultiplier
		 * ---------------------------------------------------------------------
		 * non-seeded
		 *
		 * @returns 	-1 or 1
		 */
		public static function generateRandomSignedMultiplier():int
		{
			if( TrueRandom.generateRangedInt(9) < 5 )
				return -1;
			
			return 1;
		}
		
		
	}
}