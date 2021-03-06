package khiggins.demo
{
	import flash.display.Sprite;
	import khiggins.demo.view.Window;
  public class Tiles extends Sprite
  {
		public var grid:Array = new Array();
		public static const tileSize:int = 21;
		public var isBusy:Boolean = false;
		private var win:Window;

    public function Tiles(map:Array):void
    {
			initGrid(map);	
    }

		public function setWindow(win:Window):void {
			this.win = win;
		}

		private function initGrid(map:Array):void
		{
			var yLength:int = map.length;
			var tSize:int		= Tiles.tileSize;
			for (var y:int=0; y < yLength; y++) {
				var curRow:Array = map[y];
				var xLength:int = curRow.length;
				if(this.grid[y] == undefined){
					this.grid[y] = new Array();
				}
				for (var x:int=0; x < xLength; x++) {
					var curCell:String = curRow[x]; 
					var tmpTile:Tile;
					/* Move switch into an overridable function */
					switch(curCell) {
						case "O":
							tmpTile = new Tile(x, y, tSize, 0x000000);
							tmpTile.setBoard(this);
							this.grid[y][x] = tmpTile;
							this.addChild(tmpTile);
							break;
						case "X":
							tmpTile = new Tile(x, y, tSize, 0x000000);
							tmpTile.setBoard(this);
							tmpTile.obstruct();
							this.grid[y][x] = tmpTile;
							this.addChild(tmpTile);
							break;
					}
				}
			}
		}

		public function moveWindowToTile(nextTile:Tile):void {
			win.moveToTile(nextTile);
		}

		public function getTile(x:int, y:int):Tile{
			if(x >= 0 && y >= 0 
				&& y < this.grid.length
				&& x < this.grid[y].length){
					return this.grid[y][x];
			}
			return null;
		}
  }
}

