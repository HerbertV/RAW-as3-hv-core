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
 * Copyright (c) 2009-2013 Herbert Veitengruber 
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
	
	/**
	 * =========================================================================
	 * Class AbstractConsoleView
	 * =========================================================================
	 * Abstract base for all Views that are console related.
	 */
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
		
		protected var minimizedWidth:Number = 50;
		protected var minimizedHeight:Number = 25;
		
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
		
		protected var btnViewMinMax:UIButtonMinMax;
		
		
		/**
		 * =====================================================================
		 * Constructor 
		 * =====================================================================
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
			if( viewState == VIEW_STATE_MAXIMIZED )
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
						UIStyles.FRAME_BG_OUTLINE_COLOR,
						UIStyles.FRAME_BG_OUTLINE_ALPHA,
						true,
						UIStyles.FRAME_BG_COLOR,
						UIStyles.FRAME_BG_ALPHA
					);
				return;
			}
			
			if( viewState == VIEW_STATE_MINIMIZED )
			{
				bgShape.graphics.clear();
			
				EdgedRectangle.drawGraphics(
						bgShape.graphics,
						0,
						0,
						minimizedWidth,
						minimizedHeight,
						new Array(10,5),
						2,
						UIStyles.FRAME_BG_OUTLINE_COLOR,
						UIStyles.FRAME_BG_OUTLINE_ALPHA,
						true,
						UIStyles.FRAME_BG_COLOR,
						UIStyles.FRAME_BG_ALPHA
					);
			}
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
				
			if( this.isResizeable )
			{
				this.resizeHandle.buttonMode = true;
				this.resizeHandle.useHandCursor = true;
				this.resizeHandle.addEventListener(
						MouseEvent.MOUSE_DOWN,
						startViewResize
					);
			} else if ( this.resizeHandle != null ) {
				this.resizeHandle.removeEventListener(
						MouseEvent.MOUSE_DOWN,
						startViewResize
					);
			}
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
				this.dragHandle.buttonMode = true;
				this.dragHandle.useHandCursor = true;
				this.dragHandle.addEventListener(
						MouseEvent.MOUSE_DOWN,
						startViewDrag
					);
			} else if ( this.dragHandle != null ) {
				this.dragHandle.removeEventListener(
						MouseEvent.MOUSE_DOWN,
						startViewDrag
					);
			}
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * bringToFront
		 * ---------------------------------------------------------------------
		 * Helper for stay on top (z-order) handling
		 */
		public function bringToFront()
		{
			if( this.parent != null )
				this.parent.setChildIndex(
						this, 
						this.parent.numChildren-1
					);	
			
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
				
			bringToFront();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removedFromStage Event
		 * ---------------------------------------------------------------------
		 */
		protected function removedFromStage(e:Event):void
		{
			//dealloc
			while( this.numChildren > 0 )
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
			bringToFront();
			
			this.startDrag(false);
			
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
		
		/**
		 * ---------------------------------------------------------------------
		 * startViewResize Event
		 * ---------------------------------------------------------------------
		 */
		protected function startViewResize(e:MouseEvent):void 
		{
			bringToFront();
			
			this.resizeHandle.startDrag(
					false,
					new Rectangle(
							minWidth,
							minHeight,
							maxWidth,
							maxHeight
						)
				);
			
			stage.addEventListener(
					MouseEvent.MOUSE_UP,
					stopViewResize
				);
			
			stage.addEventListener(
					MouseEvent.MOUSE_MOVE, 
					resizing
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stopViewResize Event
		 * ---------------------------------------------------------------------
		 */
		protected function stopViewResize(e:MouseEvent):void 
		{
			this.resizeHandle.stopDrag();
			
			stage.removeEventListener(
					MouseEvent.MOUSE_UP,
					stopViewResize
				);
			
			stage.removeEventListener(
					MouseEvent.MOUSE_MOVE, 
					resizing
				);
			resizing(null);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * resizing Event
		 * ---------------------------------------------------------------------
		 */
		protected function resizing(e:MouseEvent):void
		{
			this.currentWidth = this.resizeHandle.x;
			this.currentHeight = this.resizeHandle.y;
			this.layout();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * toggleViewState Event
		 * ---------------------------------------------------------------------
		 */
		protected function toggleViewState(e:MouseEvent):void
		{
			if( this.viewState == VIEW_STATE_MAXIMIZED )
				this.viewState = VIEW_STATE_MINIMIZED;
			else if( this.viewState == VIEW_STATE_MINIMIZED )
				this.viewState = VIEW_STATE_MAXIMIZED;
			
			bringToFront();
			layout();
		}
		
	}
}
