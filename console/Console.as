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
	
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;

	import flash.ui.Keyboard;
	
	import flash.system.Capabilities;
	
	import as3.hv.core.utils.StringHelper;
	import as3.hv.core.shapes.EdgedRectangle;
	import as3.hv.core.console.cmd.*;
	
	// =========================================================================
	// Class Console
	// =========================================================================
	// an ActionScript 3 Console for on-the-fly logging, debugging, monitoring
	// with command line.
	//
	//
	// History Note:
	// -------------------------------------------------------------------------
	// Version 1.0 was written in AS2 and used a MovieClip you had to include 
	// into to your fla's library.
	// Version 1.1 was the first version written in AS3.
	// Version 1.2 added the command line
	// Version 2.0 complete code revision
	//
	public class Console
			extends AbstractConsoleView
	{
		// =====================================================================
		// Constants
		// =====================================================================
		// Class version
		public static const VERSION:String = "2.0.0";
		
		public static const CMDLINE_MARGIN_X = 10;
		public static const CMDLINE_MARGIN_Y = 3;
		public static const CMDLINE_HEIGHT = 20;
		
		public static const COLOR_COMMAND:String = "#555555";
		public static const COLOR_INFO:String = "#009900";
		public static const COLOR_DEBUG:String = "#000000";
		public static const COLOR_WARNING:String = "#FFFF00";
		public static const COLOR_ERROR:String = "#FF0000";
		
		public static const FONTSIZE_COMMAND:String = "10";
		public static const FONTSIZE_INFO:String = "10";
		public static const FONTSIZE_DEBUG:String = "10";
		public static const FONTSIZE_WARNING:String = "12";
		public static const FONTSIZE_ERROR:String = "13";
		
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		// static singleton instance 
		private static var myInstance:Console = new Console();
		
		// headline label
		private var txtHeadline:TextField;
		// bg shape also used as drag handle
		private var bgHeadline:Sprite;
		
		// for all output messages
		private var txtOutput:TextField;
		// background shape
		private var bgOutput:Shape;
		//scrollbar.
		private var sbOutput:Sprite;
		
		// for user input
		private var cmdLine:TextField;
		private var bgCmdLine:Shape;
		
		private var cmdDefault:String = "type something";
		
		private var arrCommands:Array = new Array();
		private var arrCommandKeys:Array = new Array();
		
		private var doAutoScroll:Boolean = true;
		
		private var toggleKey:uint = 220; //^
		
		// command stack for storing the last commands
		private var arrCmdStack:Array = new Array();
		private var cmdStackIdx:int = -1;
		private var cmdStackSize:int = 10;
		
		
		// =====================================================================
		// Constructor
		// =====================================================================
		/**
		 * Constructor 
		 *
		 * Cannot called directly since this class is a singleton.
		 * use getInstance instead.
		 *
		 */
		public function Console()
		{
			super(300,400);
		
			if ( myInstance ) 
				throw new Error ("Console is a singleton class, use getInstance() instead");    
			
			this.visible = false;
			
			this.txtHeadline = new TextField();
			var hdformat:TextFormat = new TextFormat();
			hdformat.font = "Arial";
			hdformat.color = 0x000000;
			hdformat.size = 10;
			hdformat.bold = true;
			this.txtHeadline.defaultTextFormat = hdformat;
			this.txtHeadline.text = "CONSOLE -- Version "+VERSION;
			this.txtHeadline.x = 10;
			this.txtHeadline.y = 5;
			this.txtHeadline.height = 20;
			this.txtHeadline.selectable = false;
			
			// Output Area
			// init the output area immediately since there we can start logging
			// as soon as possible
			txtOutput = new TextField();
			txtOutput.type = TextFieldType.DYNAMIC;
			txtOutput.multiline = true;
			txtOutput.selectable = true;
			
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			format.color = 0xFFFFFF;
			format.size = 10;
			txtOutput.defaultTextFormat = format;
			
			//now register the core commands
			this.registerCommand( CmdHelp.CMD, new CmdHelp() );
			this.registerCommand( CmdClear.CMD, new CmdClear() );
			this.registerCommand( CmdDebugLevel.CMD, new CmdDebugLevel() );
			
			
			clearOutput();
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * getInstance
		 * ---------------------------------------------------------------------
		 * If no instance exists one is created. 
		 *
		 * @returns 	the instance of the Console
		 */
		public static function getInstance():Console
		{
			return Console.myInstance;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * layout
		 * ---------------------------------------------------------------------
		 */
		override protected function layout():void
		{
			super.layout();
			bgHeadline.graphics.clear();
			EdgedRectangle.drawGraphics(
					bgHeadline.graphics,
					1,
					1,
					currentWidth-2,
					25,
					new Array(10,5,3,-1),
					1,
					0x000000,
					1.0,
					true,
					0xCCCCDD,
					0.8
				);
			this.txtHeadline.width = currentWidth - 20;
			
			this.dragHandle.graphics.clear();
			this.dragHandle.graphics.lineStyle();
			this.dragHandle.graphics.beginFill(0xFF0000,0.0);
			this.dragHandle.graphics.drawRect(1,1,currentWidth-2,25);
			this.dragHandle.graphics.endFill();
						
			// output
			bgOutput.graphics.clear();
			EdgedRectangle.drawGraphics(
					bgOutput.graphics,
					5,
					30,
					currentWidth-10,
					currentHeight-60,
					new Array(5,3),
					1,
					0x000000,
					1.0,
					true,
					0xCCCCDD,
					0.8
				);
			
			txtOutput.width = currentWidth - (CMDLINE_MARGIN_X*2);
			txtOutput.height = currentHeight - 70;
			txtOutput.x = CMDLINE_MARGIN_X;
			txtOutput.y = 35;
			
			//commandline
			bgCmdLine.graphics.clear();
			EdgedRectangle.drawGraphics(
					bgCmdLine.graphics,
					5,
					currentHeight - 28,
					currentWidth - 10,
					23,
					new Array(5,3),
					1,
					0x000000,
					1.0,
					true,
					0xCCCCDD,
					0.8
				);
			
			this.cmdLine.width = currentWidth - (CMDLINE_MARGIN_X*2);
			this.cmdLine.height = CMDLINE_HEIGHT;
			this.cmdLine.x = CMDLINE_MARGIN_X;
			this.cmdLine.y = currentHeight - CMDLINE_MARGIN_Y - CMDLINE_HEIGHT;
			this.cmdLine.text = cmdDefault;
			this.cmdLine.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
			
		/**
		 * ---------------------------------------------------------------------
		 * setHeadline
		 * ---------------------------------------------------------------------
		 * sets the headline text.
		 * 
		 * @param txt		headline
		 */
		public function setHeadline(txt:String):void
		{
			this.txtHeadline.text = txt;
		}
		
		
		/**
		 * ---------------------------------------------------------------------
		 * setAutoScroll
		 * ---------------------------------------------------------------------
		 * set auto scrolling on/off.
		 * 
		 * @param val
		 */
		public function setAutoScroll(val:Boolean):void
		{
			this.doAutoScroll = val;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * isAutoScrolling
		 * ---------------------------------------------------------------------
		 * 
		 * @return
		 */
		public function isAutoScrolling():Boolean 
		{
			return this.doAutoScroll;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * setToggleKey
		 * ---------------------------------------------------------------------
		 * for changing the visibility toggle key.
		 * Default key is ^ 
		 *
		 * @param key 		key as uint from Keyboard class e.g. Keyboard.F1
		 *					or a keycode uint
		 */
		public function setToggleKey(key:uint):void
		{
			this.toggleKey = key;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * doCommand
		 * ---------------------------------------------------------------------
		 * looks through the command list and calls the IConsoleCommands
		 * doCommand function if the command was found.
		 * Error handling on wrong arguments is done in the command class itself.
		 * 
		 * @param cmdstring		commandstring with arguments
		 */
		public function doCommand(cmdstring:String) 
		{	
			var arrCmd:Array = cmdstring.split(" ");
			var cmdKey:String = "";
			var cmdIdx:int = -1;
			var cmd:IConsoleCommand = null;
			
			if( cmdstring != "" )
			{
				if( arrCmd.length > 0 ) 
				{
					cmdKey = String(arrCmd.shift()).toLowerCase();
					cmdIdx = arrCommandKeys.indexOf(cmdKey);
					
					if( cmdIdx > -1 ) 
					{
						this.writeln(
								"CMD: "+cmdstring,
								DebugLevel.COMMAND
							);
						
						cmd = IConsoleCommand(this.arrCommands[cmdIdx]);
						
						if( cmd is CmdHelp ) 
						{
							// special case show help
							if( arrCmd.length == 0 ) 
							{
								// command list
								cmd.doCommand(this.arrCommands);
							} else {
								// command help
								cmdIdx = arrCommandKeys.indexOf(arrCmd[0]);
								if( cmdIdx > -1 )
									cmd.doCommand(new Array(this.arrCommands[cmdIdx]));
							}
						} else {
							// execute command
							cmd.doCommand(arrCmd);
						}
					
					} else {
						this.writeln(
								"UNKOWN CMD: "+cmdstring,
								DebugLevel.COMMAND_ERROR
							);
					}
				}
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * registerCommand
		 * ---------------------------------------------------------------------
		 * register a command to the available command list.
		 * if you register a existing key, the old command is overridden. 
		 * 
		 * @param key		command string
		 * @param cmd 		command class 
		 */
		public function registerCommand(
				key:String, 
				cmd:IConsoleCommand
			)
		{
			var idx:int = this.arrCommandKeys.indexOf(key);
			
			if( idx == -1 )
			{
				// add new
				this.arrCommandKeys.push(key);
				this.arrCommands.push(cmd);
				return;
			}
			// override
			this.arrCommands[idx] = cmd;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * newLine
		 * ---------------------------------------------------------------------
		 */
		public function newLine()
		{
			this.txtOutput.htmlText = this.txtOutput.htmlText 
					+ "<font size='5'><br/></font>";
			this.updateScrollbar();
			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * clearOutput
		 * ---------------------------------------------------------------------
		 */
		public function clearOutput()
		{
			this.txtOutput.htmlText = "";
			
			this.writeln(" &gt; &gt; CONSOLE READY &lt; &lt;",DebugLevel.INFO,false);

//TODO move to system command
//this.writeToConsole(" Flash Player "+ Capabilities.version ,DebugConsole.TYPE_INPUT);
//this.writeToConsole(" "+this.getMyConfigString(),DebugConsole.TYPE_INPUT);

			this.newLine();
			this.updateScrollbar();
			
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * writeln
		 * ---------------------------------------------------------------------
		 * @param msg 			Message (html formated)
		 * @param level			debug level of the messge
		 * @param doCheck		if false the current debug level of the message
		 * 						is not checked and the message is allways shown.
		 */
		public function writeln(
				msg:String,
				level:int,
				doCheck:Boolean=true
			) 
		{
			if( doCheck && !DebugLevel.check(level) )
				return;
						
			var formatedMsg = "<font face='Arial' size='";
			
			switch( level )
			{
				case DebugLevel.FATAL_ERROR:
					formatedMsg += FONTSIZE_ERROR 
							+ "' color='" + COLOR_ERROR 
							+ "'><b> &gt; &gt; !!FATAL ERROR!! &lt; &lt; </b><br/>" 
							+ msg + "</font>";
					break;
				
				case DebugLevel.ERROR:
					formatedMsg += FONTSIZE_ERROR
							+ "' color='" + COLOR_ERROR 
							+ "'><b> &gt; &gt; !ERROR! &lt; &lt; </b><br/>"
							+ msg + "</font>";
					break;
					
				case DebugLevel.WARNING:
					formatedMsg += FONTSIZE_WARNING
							+ "' color='" + COLOR_WARNING
							+ "'><b> &gt; &gt; WARNING &lt; &lt; </b><br/>"
							+ msg + "</font>";
					break;
					
				case DebugLevel.DEBUG:
					formatedMsg += FONTSIZE_DEBUG 
							+ "' color='" + COLOR_DEBUG + "'>" 
							+ msg + "</font>";
					break;
				
				case DebugLevel.INFO:
					formatedMsg += FONTSIZE_INFO 
							+ "' color='" + COLOR_INFO + "'>" 
							+ msg + "</font>";
					break;
				
				case DebugLevel.COMMAND:
					formatedMsg += FONTSIZE_COMMAND
							+ "' color='" + COLOR_COMMAND + "'>" 
							+ msg + "</font>";
					break;
				
				case DebugLevel.COMMAND_ERROR:
					formatedMsg += FONTSIZE_COMMAND
							+ "' color='" + COLOR_ERROR + "'>" 
							+ msg + "</font>";
					break;
			}
			
			this.txtOutput.htmlText = this.txtOutput.htmlText +  formatedMsg;
			if( this.doAutoScroll )
				this.txtOutput.scrollV = this.txtOutput.numLines;
			
			this.updateScrollbar();
			

// TODO show and expand console if fatalerror
/*
if (type == DebugLevel.FATAL_ERROR && this.isConsoleOpen == false) {
	this.switchConsole();
}
*/
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * updateScrollbar
		 * ---------------------------------------------------------------------
		 * updates the scrollbar for our output
		 */
		private function updateScrollbar(needsResize:Boolean=true):void
		{
			if( sbOutput == null )
				return;
			
			if( txtOutput.maxScrollV == 1 )
			{
				sbOutput.visible = false;
				return;
			}
			
			sbOutput.visible = true;
			var h:Number = txtOutput.height;
			
			if( txtOutput.maxScrollV > 1 )
			{
				// since there is no function to get max visible lines
				var visibleLines:int = txtOutput.numLines - txtOutput.maxScrollV;
				h = h * visibleLines / txtOutput.numLines;
			}
			
			if( h < 30 )
				h = 30;
						
			var percent:Number = txtOutput.scrollV / txtOutput.maxScrollV;
			
			sbOutput.x = currentWidth - CMDLINE_MARGIN_X + 1;
			sbOutput.y = txtOutput.y + (percent * (txtOutput.height - h));
			
			if( !needsResize )
				return;
						
			sbOutput.graphics.clear();
			sbOutput.graphics.lineStyle(0,0x000000);
			sbOutput.graphics.beginFill(0x0066FF);
			sbOutput.graphics.drawRect(
					0,
					0,
					6,
					h
				);
			sbOutput.graphics.endFill();	
		}
		
		// =====================================================================
		// Event Handler
		// =====================================================================
		
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
			this.bgHeadline = new Sprite();
			this.addChild(this.bgHeadline);
			this.addChild(this.txtHeadline);
			
			this.dragHandle = new Sprite();
			this.addChild(this.dragHandle);
			this.setupDragging(true);
			
			// output
			this.bgOutput = new Shape();
			this.addChild(bgOutput);
			this.addChild(txtOutput)
			this.txtOutput.addEventListener(
					MouseEvent.MOUSE_WHEEL,
					doScrollWheel
				);
			this.sbOutput = new Sprite();
			this.addChild(sbOutput)
			this.sbOutput.addEventListener(
					MouseEvent.MOUSE_DOWN,
					startScroll
				);
			stage.addEventListener(
					MouseEvent.MOUSE_UP,
					stopScroll
				);
			
			// Commandline
			this.bgCmdLine = new Shape();
			this.addChild(this.bgCmdLine);
			
			this.cmdLine = new TextField();
			var cmdformat:TextFormat = new TextFormat();
			cmdformat.font = "Arial";
			cmdformat.color = 0x000000;
			cmdformat.size = 10;
			this.cmdLine.defaultTextFormat = cmdformat;
			this.cmdLine.type = TextFieldType.INPUT;
			this.addChild(this.cmdLine);
			
			this.layout();
			this.updateScrollbar();
			
			stage.addEventListener(
					KeyboardEvent.KEY_UP,
					toggleConsole
				);
			
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
			
			this.sbOutput.removeEventListener(
					MouseEvent.MOUSE_DOWN,
					startScroll
				);
			stage.removeEventListener(
					MouseEvent.MOUSE_UP,
					stopScroll
				);
			this.txtOutput.removeEventListener(
					MouseEvent.MOUSE_WHEEL,
					doScrollWheel
				);
			stage.removeEventListener(
					KeyboardEvent.KEY_UP,
					toggleConsole
				);
			
			this.bgHeadline = null;
			this.bgOutput = null;
			this.sbOutput = null;
			this.bgCmdLine = null;
			this.cmdLine = null;
		
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * keyUpHandler Event
		 * ---------------------------------------------------------------------
		 * key handling for our command line
		 * 
		 * @param e 		KeyboardEvent
		 */
		private function keyUpHandler(e:KeyboardEvent):void 
		{
			// complete comand
			if( e.keyCode == Keyboard.TAB )
			{
				//TODO				
			}
			
			//UpArrow = 38
			if( e.keyCode == Keyboard.UP 
					&& arrCmdStack.length > 0)
			{
				cmdStackIdx--;
				
				if( cmdStackIdx < 0 )
					cmdStackIdx = arrCmdStack.length-1;
				
				this.cmdLine.text = arrCmdStack[cmdStackIdx];
				this.cmdLine.setSelection(
						this.cmdLine.text.length, 
						this.cmdLine.text.length
					)
				return;
			}
			
			//DownArrow = 40
			if( e.keyCode == Keyboard.DOWN 
					&& arrCmdStack.length > 0 )
			{
				cmdStackIdx++;
				if( cmdStackIdx > arrCmdStack.length-1 )
					cmdStackIdx = 0;
					
				this.cmdLine.text = arrCmdStack[cmdStackIdx];
				this.cmdLine.setSelection(
						this.cmdLine.text.length, 
						this.cmdLine.text.length
					)
				return;
			}
				
			if( e.keyCode == Keyboard.ENTER )
			{
				// clean command
				var cmd:String = StringHelper.trim(this.cmdLine.text," ");
				
				// update stack
				arrCmdStack.push(cmd);
				cmdStackIdx = -1;
				if( arrCmdStack.length > cmdStackSize )
					arrCmdStack.shift();
				
				// fire command
				this.doCommand( cmd );
				this.cmdLine.text = "";
			}
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * toggleConsole Event
		 * ---------------------------------------------------------------------
		 * toggles the consoles visiblity by hitting the toggle key.
		 
		 * @param e 		KeyboardEvent
		 */
		private function toggleConsole(e:KeyboardEvent):void 
		{
			if (e.keyCode == this.toggleKey)
				this.visible = !this.visible;
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * startScroll Event
		 * ---------------------------------------------------------------------
		 * scrollbar -> textfield
		 *
		 * @param e 		MouseEvent
		 */
		private function startScroll(e:MouseEvent):void
		{
			sbOutput.startDrag(
					false,
					new Rectangle(
							currentWidth - CMDLINE_MARGIN_X + 1,
							txtOutput.y,
							0,
							txtOutput.height - sbOutput.height
						)
				);
			sbOutput.addEventListener(
					Event.ENTER_FRAME,
					doScroll
				);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * stopScroll Event
		 * ---------------------------------------------------------------------
		 * scrollbar -> textfield
		 *
		 * @param e 		MouseEvent
		 */
		private function stopScroll(e:MouseEvent):void
		{
			sbOutput.stopDrag();
			sbOutput.removeEventListener(
					Event.ENTER_FRAME,
					doScroll
				);
			
			// finally call doScroll to make the last update
			doScroll(null);
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * doScroll Event
		 * ---------------------------------------------------------------------
		 * scrollbar -> textfield
		 *
		 * @param e 		MouseEvent
		 */
		private function doScroll(e:Event):void
		{
			var interval:Number = txtOutput.height - sbOutput.height;
			var percent:Number = ((sbOutput.y - txtOutput.y) / interval );
			txtOutput.scrollV = percent * txtOutput.maxScrollV;
		}
	
		/**
		 * ---------------------------------------------------------------------
		 * doScrollWheel
		 * ---------------------------------------------------------------------
		 * textfield -> scrollbar. if you use the mousewheel above the textfield.
		 *
		 * @param e 		MouseEvent
		 */
		private function doScrollWheel(e:MouseEvent):void
		{
			updateScrollbar(false);
		}
	}
}
