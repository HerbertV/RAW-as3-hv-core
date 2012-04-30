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
	import flash.geom.Rectangle;
	
	import flash.display.Sprite;
	import flash.display.Shape;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import as3.hv.core.shapes.EdgedRectangle;

	// =========================================================================
	// Class AbstractConsoleView
	// =========================================================================
	// Abstract base for all Views that are console related.
	//
	public class AbstractConsoleView 
			extends Sprite
	{
		
		// =====================================================================
		// CONSTANTS
		// =====================================================================
		
		public static const VIEW_STATE_MAXIMIZED:uint = 0;
		public static const VIEW_STATE_MINIMIZED:uint = 1;
		
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		protected var viewState:uint;
		
		// since the sprites width/height depends on 
		// it children. we store the current values here
		protected var currentWidth:Number = 100;
		protected var currentHeight:Number = 100;
		
		// resizing stuff
		protected var isResizeable:Boolean = false;
		
		protected var minWidth:Number;
		protected var minHeight:Number;
		
		protected var maxWidth:Number;
		protected var maxHeight:Number;
		// for user interaction
		protected var resizeHandle:Sprite;
		
		// dragging stuff
		protected var isDragable:Boolean = false;
		// for user interaction
		protected var dragHandle:Sprite;
				
		// shape for drawing a background
		protected var bgShape:Shape;
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		/**
		 * Constructor 
		 *
		 * @param w 		width of this view
		 * @param h			height of this view
		 */
		public function AbstractConsoleView(
				w:int,
				h:int
			)
		{
			super();
			
			viewState = VIEW_STATE_MAXIMIZED;
			
			currentWidth = minWidth = maxWidth = w;
			currentHeight = minHeight = maxHeight = h;
			
			this.addEventListener(
					Event.ADDED_TO_STAGE, 
					this.addedToStage, 
					false, 
					0, 
					true
				);
				
			this.addEventListener(
					Event.REMOVED_FROM_STAGE, 
					this.removedFromStage, 
					false, 
					0, 
					true
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * layout
		 * ---------------------------------------------------------------------
		 * needs to be overridden.
		 *
		 * draws the graphics.
		 */
		protected function layout():void
		{
			bgShape.graphics.clear();
			
			EdgedRectangle.drawGraphics(
					bgShape.graphics,
					0,
					0,
					currentWidth,
					currentHeight,
					new Array(10,5),
					2,
					0x000000,
					0.9,
					true,
					0xCCCCDD,
					0.7
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupResizing
		 * ---------------------------------------------------------------------
		 * setup resizing parameters.
		 *
		 * @param resizable
		 * @param minW
		 * @param minH
		 * @param maxW
		 * @param maxH
		 */
		public function setupResizing(
				resizeable:Boolean,
				minW:Number=0,
				minH:Number=0,
				maxW:Number=-1,
				maxH:Number=-1
			):void
		{
			this.isResizeable = resizeable;
			
			this.minWidth = minW;
			this.minHeight = minH;
			
			if( maxW > 0 )
				this.maxWidth = maxW;
				
			if( maxH > 0 )
				this.maxHeight = maxH;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setupDragging
		 * ---------------------------------------------------------------------
		 * setup dragging parameters.
		 *
		 * @param dragable
		 */
		public function setupDragging(
				dragable:Boolean
			):void
		{
			this.isDragable = dragable;
			
			if( this.isDragable )
			{
				this.dragHandle.addEventListener(
						MouseEvent.MOUSE_DOWN,
						startViewDrag
					);
			}
				
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * addedToStage Event
		 * ---------------------------------------------------------------------
		 */
		protected function addedToStage(e:Event):void
		{
			//init
			this.bgShape = new Shape();
			this.addChild(bgShape);
			
			// to prevent layout called more than once if 
			// you override this function.
			if( e != null )
				this.layout();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removedFromStage Event
		 * ---------------------------------------------------------------------
		 */
		protected function removedFromStage(e:Event):void
		{
			//dealloc
			while(	this.numChildren > 0	)
				this.removeChildAt(0);
			
			if( dragHandle != null )
				this.dragHandle.removeEventListener(
						MouseEvent.MOUSE_DOWN,
						startViewDrag
					);
			
			this.bgShape = null;
			this.resizeHandle = null;
			this.dragHandle = null;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * startViewDrag Event
		 * ---------------------------------------------------------------------
		 */
		protected function startViewDrag(e:MouseEvent):void 
		{
			this.startDrag(
					false,
					new Rectangle(0,0,this.stage.stageWidth,this.stage.stageHeight)
				);
			
			stage.addEventListener(
					MouseEvent.MOUSE_UP,
					stopViewDrag
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * startViewDrag Event
		 * ---------------------------------------------------------------------
		 */
		protected function stopViewDrag(e:MouseEvent):void 
		{
			this.stopDrag();
		}
					
		
//TODO
/*
		public function resizeTest(evt:MouseEvent):void
		{
			
			this.removeEventListener(MouseEvent.MOUSE_DOWN, resizeTest);
			
			this.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoving);
			this.addEventListener(MouseEvent.MOUSE_UP, stopResizeTest);
			
		}
		
		public function stopResizeTest(evt:MouseEvent):void
		{
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, resizeTest);
			
			this.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoving);
			this.removeEventListener(MouseEvent.MOUSE_UP, stopResizeTest);
			
		}
		
		
		public function resize(evt:MouseEvent):void
		{
			//trace( " x: "+x + " mouseX: "+  this.parent.mouseX );
			
			this.currentWidth =   this.parent.mouseX - this.x ;
			this.currentHeight =  this.parent.mouseY - this.y;
			
			this.layout();
		}
*/		
		
		
		
		
	}
}
