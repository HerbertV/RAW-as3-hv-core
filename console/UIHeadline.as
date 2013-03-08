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
	import flash.display.Sprite;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import as3.hv.core.shapes.EdgedRectangle;

	/**
	 * =========================================================================
	 * Class UIHeadline
	 * =========================================================================
	 * Default Headline Sprite for Console and Monitoring Views
	 */
	public class UIHeadline 
			extends Sprite
	{
		
		// =====================================================================
		// Variables
		// =====================================================================
		
		// headline label
		private var txtHeadline:TextField;
		// bg shape also used as drag handle
		private var bgHeadline:Sprite;
		
		/**
		 * =====================================================================
		 * Constructor 
		 * =====================================================================
		 * 
		 * @param w
		 * @param h
		 * @param lbl
		 */
		public function UIHeadline(
				w:Number,
				h:Number,
				lbl:String
			)
		{
			super();
			
			bgHeadline = new Sprite();
			this.addChild(bgHeadline);
			
			var hdformat:TextFormat = new TextFormat();
			hdformat.font = UIStyles.HEAD_FONT_NAME;
			hdformat.color = UIStyles.HEAD_FONT_COLOR;
			hdformat.size = UIStyles.HEAD_FONT_SIZE;
			hdformat.bold = true;
			
			txtHeadline = new TextField();
			txtHeadline.defaultTextFormat = hdformat;
			txtHeadline.text = lbl;
			txtHeadline.x = 35;
			txtHeadline.y = 5;
			txtHeadline.height = h-5;
			txtHeadline.selectable = false;
			this.addChild(txtHeadline);
			
		}
		
		// =====================================================================
		// Functions
		// =====================================================================
		
		/**
		 * ---------------------------------------------------------------------
		 * setLabel
		 * ---------------------------------------------------------------------
		 * set the label
		 *
		 * @param lbl
		 */
		public function setLabel(lbl:String)
		{
			this.txtHeadline.text = lbl;		
		}
		
		/**
		 * ---------------------------------------------------------------------
		 * layout 
		 * ---------------------------------------------------------------------
		 * layouts the sprite
		 *
		 * @param w			width
		 * @param h			height
		 * @param hideBg	if true it hides the background rectangle
		 */
		public function layout(
				w:Number, 
				h:Number,
				hideBg:Boolean=false
			)
		{
			bgHeadline.graphics.clear();
			
			if( !hideBg )
				EdgedRectangle.drawGraphics(
						bgHeadline.graphics,
						0.5,
						0.5,
						w-1,
						h,
						new Array(10,5,3,-1),
						1,
						UIStyles.HEAD_BG_OUTLINE_COLOR,
						UIStyles.HEAD_BG_OUTLINE_ALPHA,
						true,
						UIStyles.HEAD_BG_COLOR,
						UIStyles.HEAD_BG_ALPHA
					);
				
			txtHeadline.width = w - (txtHeadline.x+2);
		}
	
	}
}