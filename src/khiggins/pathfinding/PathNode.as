
/* Explain Costs */
package khiggins.pathfinding {
	public class PathNode {
		private var x:int;
		private var y:int;
		private var _gCost:int;
		private var _hCost:int;
		private var _fCost:int;
		private var _aNode:INode;
		private var _isPassable:Boolean;
		private var _nodeParent:PathNode;

		public function PathNode(aNode:INode, nodeParent:PathNode = null):void {
			this.x = aNode.xLoc;
			this.y = aNode.yLoc;
			this._isPassable = aNode.isPassable;
			this._nodeParent = nodeParent;
			this._aNode = aNode;
		}

		public function notEqual(aNode:PathNode):Boolean {
			return this.x != aNode.x || this.y != aNode.y;
		}

		public function isEqual(aNode:PathNode):Boolean {
			return this.x == aNode.x && this.y == aNode.y;
		}

		public function calculateCosts(endNode:PathNode):void {
			this.calculateGCost();
			this.calculateHCost(endNode);
			this.calculateFCost();
		}
		// This will change later if we do diagonal
		private function calculateGCost():void{
			this._gCost = 10;
			if(this._nodeParent != null) {
				this._gCost += this._nodeParent.gCost;	
			}
		}
		private function calculateHCost(endNode:PathNode):void{
			var xDist:int = Math.abs(this.x - endNode.x) * 10;
			var yDist:int = Math.abs(this.y - endNode.y) * 10;
			this._hCost = xDist + yDist;
		}
		private function calculateFCost():void{
			this._fCost = this._gCost + this._hCost;
		}

		public function getAdjacentPathNodes():PathNodeList {
			var adjacentNodes:Array = this._aNode.getAdjacentNodes();
			return this.nodesToPathNodes(adjacentNodes);
		}

		/* Try Using each or something to make this simple */
		public function nodesToPathNodes(nodes:Array):PathNodeList {
			var nodeList:PathNodeList = new PathNodeList();
			for each (var aNode:INode in nodes){
				var newNode:PathNode = new PathNode(aNode, this);
				nodeList.push(newNode);	
			}		
			return nodeList;
		}

		public function get gCost():int {return _gCost;}
		public function get hCost():int {return _hCost;}
		public function get fCost():int {return _fCost;}
		public function get aNode():INode {return _aNode;}
		public function get isPassable():Boolean {return _isPassable;}
		public function get nodeParent():PathNode {return _nodeParent;}

		public function set gCost(cost:int):void {
			if(!_gCost && !_hCost && !_fCost) {
				_gCost = cost;
			}
		}
		public function set hCost(cost:int):void {
			if(!_gCost && !_hCost && !_fCost) {
				_hCost = cost;
			}
		}
		public function set fCost(cost:int):void {
			if(!_gCost && !_hCost && !_fCost) {
				_fCost = cost;
			}
		}

	}
}