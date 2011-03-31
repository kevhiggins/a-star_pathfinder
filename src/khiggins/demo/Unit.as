package khiggins.demo {
	import flash.display.Shape;
	import flash.display.Sprite;
	import caurina.transitions.Tweener;
	import khiggins.pathfinding.Pathfinder;

	public class Unit extends Sprite {

		private var curTile:Tile;
		private var img:Shape = new Shape();
		private var tmpX:int;
		private var tmpY:int;
		private var board:Tiles;

		public function Unit(newTile:Tile) {
			this.addToTile(newTile);
		}

		public function setBoard(board:Tiles):void {
			this.board = board;
		}

		public function setTile(curTile:Tile):void {
			if(this.curTile != null){	
				this.curTile.removeUnit(this);	
			}
			this.curTile = curTile;
//			this.curTile.addUnit(this);
		}

		public function patrolToTile(endTile:Tile):void {
			var tileA:Tile = this.curTile;
			var tileB:Tile = endTile;
			var moveToA:Function = function():void {
				moveToTile(tileA, moveToB);
			};
			var moveToB:Function = function():void {
				moveToTile(tileB, moveToA);
			};
			moveToB();
		}

		public function moveToTile(targetTile:Tile, onComplete:Function = null):void {
			var pathHunter:Pathfinder = new Pathfinder();
			var path:Array = pathHunter.findPath(this.curTile, targetTile);
			var isPath:Boolean = path.length > 0;
			var prevTile:Tile = curTile;
			var pathLength:int = path.length;
		
			this.tmpX = x;
			this.tmpY = y;
			for (var i:int = 0; i < pathLength; i++) {
				var nextTile:Tile = path[i];
				this.queueMove(prevTile, nextTile, i, onComplete);
				prevTile = nextTile;
			}
			if(isPath) {
				this.setTile(targetTile);
			}
		}

		private function queueMove(prevTile:Tile, nextTile:Tile, delay:int, onComplete:Function = null):void {
			var xRange:int = prevTile.xTile - nextTile.xTile;
			var yRange:int = prevTile.yTile - nextTile.yTile;
			trace("From:"+prevTile.xLoc+","+prevTile.yLoc);
			trace("To:"+nextTile.xLoc+","+nextTile.yLoc);
			if(xRange != 0 && yRange == 0) {
				var newX:int = nextTile.x - prevTile.x + this.tmpX;
				this.tmpX = newX;
				trace("Moving along X axis");
				trace("newX:"+newX);
				Tweener.addTween(this, {
					x:newX, 
					time:1, 
					delay:delay,
					transition:"easeInOutQuad",
					onComplete:onComplete
				});
			}	
			else if(xRange == 0 && yRange != 0) {
				var newY:int = nextTile.y - prevTile.y + this.tmpY;
				this.tmpY = newY;
				trace("Moving along Y axis");
				trace("newY:"+newY);
				Tweener.addTween(this, {
					y:newY, 
					time:1, 
					delay:delay,
					transition:"easeInOutQuad",
					onComplete:onComplete
				});
			}
		}

		public function addToTile(newTile:Tile):void {
			var x:int = newTile.tileSize/2 - 2;
			var y:int = x;
			this.x = newTile.x+x; 
			this.y = newTile.y+y;
			//this.graphics.lineStyle(0, 0xFF0000);
			this.img.graphics.beginFill(0x00FF00);
			this.img.graphics.drawRect(0, 0, 5, 5);
			this.img.graphics.endFill();
			this.img.cacheAsBitmap = true;
			this.addChild(this.img);
			this.setTile(newTile);
		}
	}
}
