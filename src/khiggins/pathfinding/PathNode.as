
/* Explain Costs */
package khiggins.pathfinding {
	
	/* Composed of an INode with additional data for keeping track of path relevancy. */
	public class PathNode {
		private var x:int;
		private var y:int;
		private var _gCost:int;
		private var _hCost:int;
		private var _fCost:int;
		private var _aNode:INode;
		private var _isPassable:Boolean;
		private var _nodeParent:PathNode;

		/**
		* Instantiates a PathNode
		* @param aNode INode which PathNode is composed of.
		* @param nodeParent the PathNode leading to this PathNode.
		*/
		public function PathNode(aNode:INode, nodeParent:PathNode = null):void {
			this.x = aNode.xLoc;
			this.y = aNode.yLoc;
			this._isPassable = aNode.isPassable;
			this._nodeParent = nodeParent;
			this._aNode = aNode;
		}

		/**
		* Checks if two PathNodes are not equal by position.
		* @param aNode PathNode to check this against.
		* @return not equality of PathNodes
		*/
		public function notEqual(aNode:PathNode):Boolean {
			return this.x != aNode.x || this.y != aNode.y;
		}

		/**
		* Checks if two PathNodes are equal by position.
		* @param aNode PathNode to check this against.
		* @return equality of PathNodes
		*/
		public function isEqual(aNode:PathNode):Boolean {
			return this.x == aNode.x && this.y == aNode.y;
		}

		/**
		* Calculate G, H, and F Costs of PathNode.
		* @param endNode PathNode defining path destination.
		*/
		public function calculateCosts(endNode:PathNode):void {
			this.calculateGCost();
			this.calculateHCost(endNode);
			this.calculateFCost();
		}

		/**
		* Calculate G cost of PathNode. G cost increases by 10
		* for each PathNode away from the starting PathNode it is.
		*/
		private function calculateGCost():void{
			this._gCost = 10;
			if(this._nodeParent != null) {
				this._gCost += this._nodeParent.gCost;	
			}
		}

		/**
		* Calculate H cost of PathNode. H cost is the number of
		* nodes away from the endNode this node is on the x axis
		* times 10, plus the number of nodes away from the endNode
		* this node is on the y axis times 10.
		*/
		private function calculateHCost(endNode:PathNode):void{
			var xDist:int = Math.abs(this.x - endNode.x) * 10;
			var yDist:int = Math.abs(this.y - endNode.y) * 10;
			this._hCost = xDist + yDist;
		}

		/**
		* Calculate F cost of PathNode. F cost is the G cost plus
		* the H cost.
		*/
		private function calculateFCost():void{
			this._fCost = this._gCost + this._hCost;
		}

		/**
		* A wrapper function to access the INodes getAdjacenNodes().
		*/
		public function getAdjacentPathNodes():PathNodeList {
			var adjacentNodes:Array = this._aNode.getAdjacentNodes();
			return this.nodesToPathNodes(adjacentNodes);
		}

		/**
		* Converts an array of INodes into an a PathNodeList of PathNodes.
		* @param nodes list of INodes to convert into PathNodes.
		* @note Make this static it does not change state.
		*/
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
