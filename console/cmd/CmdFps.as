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
package as3.hv.core.console.cmd
{
	import flash.utils.getTimer;
	
	import flash.display.Sprite;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import as3.hv.core.console.Console;
	import as3.hv.core.console.AbstractMonitoringView;
	import as3.hv.core.console.DebugLevel;
	import as3.hv.core.console.UIHeadline;
	import as3.hv.core.console.UIStyles;
	import as3.hv.core.console.UIButtonMinMax;
	
	
	/**
	 * =========================================================================
	 * Class CmdFps
	 * =========================================================================
	 * shows a fps monitor
	 */
	public class CmdFps
			extends AbstractMonitoringView
			implements IConsoleCommand 
	{
		// =====================================================================
		// Constants
		// =====================================================================	
		public static const CMD:String = "fps";
		
		
		// =====================================================================
		// Variables
		// =====================================================================	
		
		// static singleton instance 
		private static var myInstance:CmdFps = new CmdFps();
		
		private var fps:uint = 0;
		private var fpsPeak:uint = 0;
		
		private var headline:UIHeadline;
		
		/**
		 * =====================================================================
		 * Constructor
		 * =====================================================================
		 */
		public function CmdFps()
		{
			super(250,85);
			
			if ( myInstance ) 
				throw new Error ("CmdFps is a singleton class, use getInstance() instead");    
			
			this.minimizedWidth = 100;
			// fps must be high ;)
			this.lowIsGood = false;
			
			this.headline = new UIHeadline(
					250,
					25,
					"FPS: 100"
				);
			
			this.graphWidth = currentWidth - 16;
			this.graphHeight = currentHeight - 35;
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getInstance
		 * ---------------------------------------------------------------------
		 *
		 * @returns 	the instance of the CmdFps
		 */
		public static function getInstance():CmdFps
		{
			return CmdFps.myInstance;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * layout
		 * ---------------------------------------------------------------------
		 */
		override protected function layout():void
		{
			super.layout();
			
			if( viewState == VIEW_STATE_MINIMIZED )
			{
				this.headline.layout(minimizedWidth,25,true);
				
				this.dragHandle.graphics.clear();
				this.dragHandle.graphics.lineStyle();
				this.dragHandle.graphics.beginFill(0xFF0000,0.0);
				this.dragHandle.graphics.drawRect(
						1,
						1,
						minimizedWidth - 2,
						minimizedHeight
					);
				this.dragHandle.graphics.endFill();
				
				this.spGraph.visible = false;
				
				return;
			}
			
			if( viewState == VIEW_STATE_MAXIMIZED )
			{
				this.headline.layout(currentWidth,25);
				
				this.dragHandle.graphics.clear();
				this.dragHandle.graphics.lineStyle();
				this.dragHandle.graphics.beginFill(0xFF0000,0.0);
				this.dragHandle.graphics.drawRect(
						1,
						1,
						currentWidth - 2,
						currentHeight
					);
				this.dragHandle.graphics.endFill();
				
				this.spGraph.visible = true;
			}
		}
		/**
		 * ---------------------------------------------------------------------
		 * doCommand
		 * ---------------------------------------------------------------------
		 * @see IConsoleCommand 
		 *
		 * @param args 		
		 */
		public function doCommand(args:Array):void
		{			
			if( args.length == 0 ) 
			{
				// view to the consoles parent
				if( this.stage == null )
					Console.getInstance().parent.addChild(this);
				else 
					Console.getInstance().parent.removeChild(this);
				
				return;
			}
			
			if( args.length == 1 )
			{
				var newfps:int = int(args[0]);
				if( newfps > 0 )
				{
					Console.getInstance().stage.frameRate = newfps;
					Console.getInstance().writeln(
							"set framerate to: " + newfps, 
							DebugLevel.COMMAND
						);
				}
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * usesArguments
		 * ---------------------------------------------------------------------
		 * @see IConsoleCommand 
		 *
		 * @return
		 */
		public function usesArguments():Boolean
		{
			return true;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * shortHelp
		 * ---------------------------------------------------------------------
		 */
		public function shortHelp():String
		{
			return "'" + CMD + "' - sets the new framerate or show/hide the FPS monitor";
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * longHelp
		 * ---------------------------------------------------------------------
		 */
		public function longHelp():String
		{
			return "USAGE: " + CMD 
					+ " [no args or int]<br> - [no args]: show/hide the FPS monitor"
					+ "<br> - [int]: sets the framerate to value";
		}
		
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * updateOnEnterFrame Event
		 * ---------------------------------------------------------------------
		 * 
		 * @param e 		Event
		 */
		override protected function updateOnEnterFrame(e:Event):void
		{
			var now:uint = getTimer();
			var d:uint = now - this.updateTimer;
			fps++;
		
			// update only after threshold is reached
			if( d < this.updateThreshold )
				return;
				
			this.updateTimer = now;
			
			var currentValue =  Math.min(
					graphHeight, 
					( fps / stage.frameRate ) * graphHeight
				);
			fpsPeak = Math.max(fps,fpsPeak);
			
			this.headline.setLabel("FPS: "+ fps );
			this.updateGraph(currentValue);
			
			fps = 0;
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
			super.addedToStage(null);
			
			// headline
			this.addChild(this.headline);
			
			this.dragHandle = new Sprite();
			this.addChild(this.dragHandle);
			this.setupDragging(true);
			
			// min max button
			this.btnViewMinMax = new UIButtonMinMax();
			this.addChild(this.btnViewMinMax);
			this.btnViewMinMax.x = 23;
			this.btnViewMinMax.y = 11;
			this.btnViewMinMax.addEventListener(
					MouseEvent.CLICK, 
					toggleViewState
				);
			
			this.layout();
			
			this.fps = 0;
			this.fpsPeak = 0;
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
			
			this.btnViewMinMax.removeEventListener(
					MouseEvent.CLICK, 
					toggleViewState
				);
			
			this.btnViewMinMax = null;
		}
	
	}
}