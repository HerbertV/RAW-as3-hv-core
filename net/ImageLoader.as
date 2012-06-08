﻿/*
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
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	
	// =========================================================================
	// Class ImageLoader
	// =========================================================================
	// for loading Images.
	//
	public class ImageLoader 
			extends AssetLoader 
	{
		// =====================================================================
		// Variables
		// =====================================================================
		
		// target container where the image is loaded into.
		private var targetContainer:MovieClip = null;
		
		
		// =====================================================================
		// Constructors
		// =====================================================================
		
		/**
		 * Constructor		
		 *
		 * @param target
		 */
		public function ImageLoader(
				target:MovieClip=null
			)
		{
			super();
			
			this.targetContainer = target;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getImage
		 * ---------------------------------------------------------------------
		 * Returns the image. 
		 * Returns null if the image is still loading or failed to load.
		 *
		 * @return 
		 */
		public function getImage():DisplayObject
		{
			if( this.isImageLoaded == true 
					&& this.loadingFailed == false ) 
				return DisplayObject(myLoader.content);
			
			return null;
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
			super.completeHandler(e);
			
			if( targetContainer != null )
			{
				var image:Bitmap = Bitmap(loadevent.currentTarget.content);
				this.targetContainer.addChild(image);
			}
		}
		
	}
}