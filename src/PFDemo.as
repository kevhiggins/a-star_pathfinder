package
{
  import flash.display.Sprite;
	import flash.display.Shape;
  import flash.text.TextField;
  import flash.text.TextFormat;
  import flash.text.TextFieldAutoSize;
	import flash.geom.Point;
	import khiggins.demo.*;
	import khiggins.demo.view.Window;

  [SWF(backgroundColor="#ffffff", frameRate="30", width="400", height="224", wmode="gpu")]
  public class PFDemo extends Sprite
  {
    public function PFDemo():void
    {
			var board:Tiles = LoadMap.load();
			var win:Window = new Window(10, 10, board.grid[1][1], board);
			addChild(win);
			var newUnit:Unit = new Unit(board.grid[2][1]);
			board.addChild(newUnit);
			addUnit(win.focusTile); // Fix this... wrong tile
			newUnit.patrolToTile(board.grid[2][0]);	
    }

		public function addUnit(newTile:Tile):void {
			var img:Shape = new Shape();	
			var x:int = newTile.tileSize/2 - 2;
			var y:int = x;
			img.x = newTile.x+x; 
			img.y = newTile.y+y;
			img.graphics.beginFill(0xFF0000);
			img.graphics.drawRect(0, 0, 5, 5);
			img.graphics.endFill();
			this.addChild(img);
		}

  }
}

