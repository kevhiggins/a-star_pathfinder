package khiggins.demo {
  import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.*;
	import flash.geom.Point;
	import khiggins.pathfinding.INode;
	
	public class Tile extends Sprite implements INode {
		private var tile:Shape = new Shape();
		private var unit:Unit;
		public var tileSize:int;
		public var xTile:int;
		public var yTile:int;
		private var _isPassable:Boolean = true;
		private var board:Tiles;

		public function Tile(x:int, y:int, tileSize:int, tileColor:uint) {
			this.tileSize = tileSize;
			this.xTile = x;
			this.yTile = y;
			this.x = xTile * tileSize;
			this.y = yTile * tileSize;
			this.tile.graphics.lineStyle(0, tileColor);
			this.tile.graphics.beginFill(0xFFFFFF); 
			this.tile.graphics.drawRect(0,0,tileSize,tileSize);
			this.tile.graphics.endFill();

			this.addChild(this.tile);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		public function addUnit(newUnit:Unit):void {
			this.unit = newUnit;	
		}

		public function setBoard(board:Tiles):void {
			this.board = board;
		}
		
		public function removeUnit(oldUnit:Unit):void {
			this.unit = null;
		}

		private function onClick(event:MouseEvent):void {
			if(this.isPassable) {
				board.moveWindowToTile(this);
			}
		}

		public function obstruct():void {
			this.isPassable = false;
			this.tile.graphics.beginFill(0x000000); 
			this.tile.graphics.drawRect(0,0,this.tileSize,this.tileSize);
			this.tile.graphics.endFill();
		}

		public function getAdjacentNodes():Array {
			var adjacentTiles:Array = new Array();
			var curTile:Tile;
			trace(board);
			curTile = board.getTile(this.xTile-1, this.yTile);
			if(curTile != null) {
				adjacentTiles.push(curTile);
			}
			curTile = board.getTile(this.xTile+1, this.yTile);
			if(curTile != null) {
				adjacentTiles.push(curTile);
			}
			curTile = board.getTile(this.xTile, this.yTile-1);
			if(curTile != null) {
				adjacentTiles.push(curTile);
			}
			curTile = board.getTile(this.xTile, this.yTile+1);
			if(curTile != null) {
				adjacentTiles.push(curTile);
			}
			return adjacentTiles
		}

		public function isAdjacent(aTile:Tile):Boolean {
			var xRange:int = Math.abs(this.xTile - aTile.xTile);
			var yRange:int = Math.abs(this.yTile - aTile.yTile);
			if((xRange == 1 && yRange == 0) || (xRange == 0 && yRange == 1)) {
				return true;
			}
			return false;
		}
		
		public function get xLoc():int {
			return this.xTile;
		}

		public function get yLoc():int {
			return this.yTile;
		}
	
		public function get isPassable():Boolean {
			return _isPassable;
		}
		public function set isPassable(value:Boolean):void {
			this._isPassable = value;
		}
		
	}
}
