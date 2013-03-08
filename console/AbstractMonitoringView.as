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
	import flash.utils.getTimer;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import flash.events.Event;
	
	import as3.hv.core.shapes.EdgedRectangle;

	/**
	 * =========================================================================
	 * Class AbstractMonitoringView
	 * =========================================================================
	 * Abstract base for all Views that are used to monitor something.
	 * E.g. fps, memory ...
	 */
	public class AbstractMonitoringView 
			extends AbstractConsoleView
	{
		
		// =====================================================================
		// Constants
		// =====================================================================	
		public static const COLOR_GRAPH_LINES:uint = 0x4D95FF;
		public static const COLOR_GRAPH_GOOD:uint = 0x00FF00;
		public static const COLOR_GRAPH_MEDIOCRE:uint = 0xFFCC00;
		public static const COLOR_GRAPH_BAD:uint = 0xFF0000;
	
		// =====================================================================
		// Variables
		// =====================================================================	
		protected var updateThreshold:uint = 1000;
		protected var updateTimer:uint;
		
		protected var graphWidth:int;
		protected var graphHeight:int;
		
		protected var bdGraph:BitmapData;
		protected var spGraph:Sprite;
		
		protected var halfGValue:int;
		protected var twoThirdGValue:int; 
		protected var oneThirdGValue:int; 
		
		protected var lowIsGood:Boolean = true;
		
		/**
		 * =====================================================================
		 * Constructor 
		 * =====================================================================
		 *
		 * @param w 		width of this view
		 * @param h			height of this view
		 */
		public function AbstractMonitoringView(
				w:int,
				h:int
			)
		{
			super(w,h);
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setupGraph
		 * ---------------------------------------------------------------------
		 */
		protected function setupGraph():void
		{
			this.halfGValue = graphHeight * 0.5;
			this.twoThirdGValue = graphHeight * 0.6666; 
			this.oneThirdGValue = graphHeight / 3.0; 
						
			this.bdGraph = new BitmapData(
					graphWidth,
					graphHeight,
					false, 
					UIStyles.OUTPUT_BG_COLOR
				);
			
			// draw the middle line
			for( var px:int = 0; px < graphWidth; ++px )
			{
				for( var py:int = 0; py < graphHeight; ++py )
				{
					if ( (graphHeight-py) == this.halfGValue )
						bdGraph.setPixel(px,py, COLOR_GRAPH_LINES );
				}
			}
			
			this.spGraph.graphics.lineStyle(1, UIStyles.OUTPUT_BG_OUTLINE_COLOR);
			this.spGraph.graphics.beginBitmapFill(bdGraph);
			this.spGraph.graphics.drawRect(0,0,graphWidth, graphHeight);
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * updateGraph
		 * ---------------------------------------------------------------------
		 * updates the graph bitmap.
		 * call it by your updateOnEnterFrame implementation
		 *
		 * @param currentValue
		 */
		protected function updateGraph(currentValue:int):void
		{
			// first shift all rows one right
			this.bdGraph.scroll(-1,0);
			
			// set coloring
			var colorGraph:uint = COLOR_GRAPH_GOOD;
			if( this.lowIsGood )
				colorGraph = COLOR_GRAPH_BAD;
			
			if( currentValue < this.twoThirdGValue 
					&& currentValue > this.oneThirdGValue )
			{
				colorGraph = COLOR_GRAPH_MEDIOCRE;
				
			} else if( currentValue <= this.oneThirdGValue ) {
				if( this.lowIsGood )
					colorGraph = COLOR_GRAPH_GOOD;
				else
					colorGraph = COLOR_GRAPH_BAD;
			}
			
			// draw the new row
			for( var py:int=0; py< graphHeight; py++ )
			{
				if( (graphHeight-py) == this.halfGValue )
				{
					this.bdGraph.setPixel( graphWidth-1, py, COLOR_GRAPH_LINES );
				
				} else if( (graphHeight-py) > currentValue ) {
					this.bdGraph.setPixel( graphWidth-1, py, UIStyles.OUTPUT_BG_COLOR );
				} else {
					this.bdGraph.setPixel( graphWidth-1, py, colorGraph);
				}
			}
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * updateOnEnterFrame Event
		 * ---------------------------------------------------------------------
		 * has to be overridden!
		 * do not call super in your implementation
		 */
		protected function updateOnEnterFrame(e:Event):void
		{
			throw new Error ("Please override updateOnEnterFrame");    
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * addedToStage Event
		 * ---------------------------------------------------------------------
		 * 
		 * @param e 		Event
		 */
		override protected function addedToStage(e:Event):void
		{
			// init
			super.addedToStage(e);
			
			// graph
			this.spGraph = new Sprite();
			this.addChild(spGraph);
			this.spGraph.x = 8;
			this.spGraph.y = 30;
			setupGraph();
			
			this.addEventListener(
					Event.ENTER_FRAME, 
					updateOnEnterFrame
				);
			
			this.updateTimer = getTimer();
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * removedFromStage Event
		 * ---------------------------------------------------------------------
		 *
		 * @param e 		Event
		 */
		override protected function removedFromStage(e:Event):void
		{
			//dealloc
			super.removedFromStage(e);
			
			this.removeEventListener(
					Event.ENTER_FRAME, 
					updateOnEnterFrame
				);
			
			this.spGraph.graphics.clear();
			this.bdGraph.dispose();
			
			this.spGraph = null;
			this.bdGraph = null;
		}
		
	}	
}
		