package khiggins.demo.view {
	/* Standard Library */
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/* 3rd party code */
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.DisplayShortcuts;

	/* My code */
	import khiggins.demo.Tiles;
	import khiggins.demo.Tile;
	import khiggins.pathfinding.Pathfinder;

	public class Window extends Sprite {
		private var view:Rectangle;
		private var curTile:Tile;
		private var board:Tiles;
		private var tmpScroll:Rectangle;
		private var _focusTile:Tile;

		public function get focusTile():Tile {
			return _focusTile;
		}

		public function Window(viewWidth:int, viewHeight:int, curTile:Tile, board:Tiles):void {
			/* Initialize the View */
			var viewX:int = curTile.xTile - (viewWidth - 1)/2;
			var viewY:int = curTile.yTile - (viewHeight - 1)/2;
			var tSize:int = Tiles.tileSize;
			this.view  = new Rectangle(viewX*tSize, viewY*tSize, viewWidth*tSize - 1, viewHeight*tSize - 1);
			this.scrollRect = view;

			var focusX:int = (viewWidth - 1)/2;
			var focusY:int = (viewHeight - 1)/2;
	
			this._focusTile = new Tile(focusX, focusY, Tiles.tileSize, 0x000000);
	
			/* Focus Tile */
			this.curTile = curTile;

			/* Attach the board */
			this.board = board;
			this.board.setWindow(this);
			this.addChild(board);

			/* Just refresh the view */
			this.cacheAsBitmap = true;

			/* Initialize scrollRect tweening */
			DisplayShortcuts.init();

		}

		/* Finds the path to a tile and queues up moves to get to it */
		public function moveToTile(targetTile:Tile):void {
			/* Prevent movement if same tile, or board is busy */
			if(this.board.isBusy || this.curTile == targetTile) {
				return;
			}
			else {
				this.board.isBusy = true;	
			}
			/* Initialize variables */
			var pathHunter:Pathfinder = new Pathfinder();
			var path:Array = pathHunter.findPath(this.curTile, targetTile);

			var isPath:Boolean = path.length > 0;
			var prevTile:Tile = curTile;
			var pathLength:int = path.length;
			var onComplete:Function = null;
			/* Copy of scrollRect to properly tween consecutive tiles */
			this.tmpScroll = this.scrollRect.clone();

			for (var i:int = 0; i < pathLength; i++) {
				var nextTile:Tile = path[i];
				/* A tile adjaceny check might not hurt */
				if(i == pathLength - 1) {
					onComplete = function():void {
						board.isBusy = false;
					}
				}
				this.queueMove(prevTile, nextTile, i, onComplete);
				prevTile = nextTile;
			}
			if(isPath) {
				this.curTile = targetTile;
			}
			if(!isPath) {
				this.board.isBusy = false;
			}
		}

		/* Queues a tween to move directly from one tile to another */
		private function queueMove(prevTile:Tile, nextTile:Tile, delay:int, onComplete:Function):void {
			var xRange:int = nextTile.x - prevTile.x;
			var yRange:int = nextTile.y - prevTile.y;
			/* Determine if the tween is x or y axis */
			if(xRange != 0 && yRange == 0) {
				var newX:int = xRange + this.tmpScroll.x;
				this.tmpScroll.x = newX;
				Tweener.addTween(this, {
					_scrollRect_x:newX, 
					time:1, 
					delay:delay,
					transition:"easeInOutQuad",
					onComplete:onComplete
				});
			}	
			else if(xRange == 0 && yRange != 0) {
				var newY:int = yRange + this.tmpScroll.y;
				this.tmpScroll.y = newY;
				Tweener.addTween(this, {
					_scrollRect_y:newY, 
					time:1, 
					delay:delay,
					transition:"easeInOutQuad",
					onComplete:onComplete
				});
			}
		}
	}
}
