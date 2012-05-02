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
 * @version: 2.0.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2009-2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */
package as3.hv.core.console
{
	import flash.geom.Point;
	
	import flash.display.Sprite;
	
	import flash.events.MouseEvent;
	
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	
	import as3.hv.core.shapes.PenroseTriangle;

	// =========================================================================
	// Class UIButtonMinMax
	// =========================================================================
	// Default Button for minimizing/maximizing its related view
	//
	public class UIButtonMinMax 
			extends Sprite
	{
		// =====================================================================
		// Variables
		// =====================================================================	
		private var tween:Tween;
		
		private var isMaxState:Boolean = true;
		
		// =====================================================================
		// Constructor
		// =====================================================================
		//
		public function UIButtonMinMax()
		{
			super();
			
			this.buttonMode = true;
			this.useHandCursor = true;
			
			PenroseTriangle.drawGraphics(
					this.graphics,
					new Point(0,0), 
					45,
					1,
					0x606060,
					1.0,
					true,
					new Array(0x0066FF,0x66CCFF,0xCCCCDD),
					new Array(1.0,1.0,1.0)
				);
			
			this.scaleY = this.scaleX = 0.5; 
			
			this.addEventListener(
					MouseEvent.CLICK, 
					doClickFeedback
				);
		}
		
		// =====================================================================
		// Functions
		// =====================================================================	
		
		/**
		 * ---------------------------------------------------------------------
		 * doClickFeedback Event
		 * ---------------------------------------------------------------------
		 * feeback for mouseclicks
		 *
		 * @param e 		MouseEvent
		 */
		public function doClickFeedback(e:MouseEvent):void
		{
			if ( tween != null )
				if( tween.isPlaying )
					tween.stop();
	
			
			isMaxState = !isMaxState;
			
			if( isMaxState )
			{
				tween = new Tween(
					this, 
					"rotation", 
					Regular.easeInOut, 
					this.rotation, 
					0, 
					0.5, 
					true
				);
	
			} else {
				tween = new Tween(
					this, 
					"rotation", 
					Regular.easeInOut, 
					this.rotation, 
					120, 
					0.5, 
					true
				);
			}
		}
		
	}
}