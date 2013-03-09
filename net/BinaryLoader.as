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
package as3.hv.core.net
{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;

	import flash.utils.Endian;
	import flash.utils.ByteArray;

	import flash.events.Event;
	import flash.events.IOErrorEvent;

	/**
	 * =========================================================================
	 * Class BinaryLoader
	 * =========================================================================
	 * for loading binary data into an ByteArray
	 */
	public class BinaryLoader 
			extends AssetURLLoader 
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		private var endian:String;
		
		private var bytes:ByteArray;
		
		/**
		 * =====================================================================
		 * Constructor		
		 * =====================================================================
		 * 
		 * @param file
		 * @param name
		 * @param e LITTLE_ENDIAN or BIG_ENDIAN
		 */
		public function BinaryLoader(
				file:String,
				name:String = "BinaryLoader",
				e:String = Endian.LITTLE_ENDIAN
			)
		{
			super(file,name);
			
			this.endian = e;
			this.defaultDataFormat = URLLoaderDataFormat.BINARY;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getBytes
		 * ---------------------------------------------------------------------
		 * returns the loaded data as a ByteArray.
		 *
		 * @return 
		 */
		public function getBytes():ByteArray 
		{
			if( this.loadingFinished == true 
					&& this.loadingFailed == false ) 
				return this.bytes;
			
			return new ByteArray();
		}
		
		// =====================================================================
		// Eventhandler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * completeHandler
		 * ---------------------------------------------------------------------
		 * overridden to parse the HTML.
		 *
		 * @param e		Complete Event
		 */
		override protected function completeHandler(e:Event):void 
		{
			this.bytes = new ByteArray();
			this.bytes.endian = this.endian;
			this.bytes.writeBytes( 
					this.myLoader.data, 
					0, 
					this.myLoader.data.length 
				);
			this.bytes.position = 0;
	
			super.completeHandler(e);
		}
				
	}
}