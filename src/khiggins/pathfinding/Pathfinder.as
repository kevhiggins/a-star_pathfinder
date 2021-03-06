package khiggins.pathfinding {

	/* Wrapper for findPath function. Will be modified for additional pathfinding algorithms eventually */
	public class Pathfinder {
		public function Pathfinder() {}	
	
		/**
		* Finds the path between two Nodes using A* algorithm
		* @param start INode to begin pathfinding from.
		* @param end INode to find a path to.
		* @return An Array of PathNodes defining a path from start to end.
		*/
		public function findPath(start:INode, end:INode):Array{
			/* Initialize variables and add startNode to openList */
			var startNode:PathNode			= new PathNode(start);
			var endNode:PathNode				= new PathNode(end);
			var openList:PathNodeList		= new PathNodeList(startNode);	
			var closedList:PathNodeList	= new PathNodeList();
			var curNode:PathNode;
			var adjNodes:PathNodeList;
			var foundNode:PathNode = null;
			var path:Array = new Array();

			if(startNode.isEqual(endNode)) {
				return path;
			}
			/* Loop until destination reached or proven unreachable */
			while(openList.length > 0) {
				/* Get curNode with lowest fCost from openList */
				openList.sort();
				curNode = openList.shift();
			
				/* Path found if curNode is equal to endNode */	
				if(curNode.isEqual(endNode)) {
					foundNode = curNode;	
					break;
				}
				/* Switch curNode to the closedList */
				closedList.push(curNode);

				/* Get curNode's adjacent Nodes */
				adjNodes = curNode.getAdjacentPathNodes();

				/* Filter adjNodes for passable nodes and nodes not in the closedList */
				adjNodes.removeImpassable(); 
				adjNodes.removeShared(closedList);

				/* Calculate costs for adjNodes and merge to openList */
				adjNodes.calculateNodes(endNode);	
				openList.mergeUnique(adjNodes);
			}

			
			if(foundNode != null && foundNode.nodeParent != null) {
				curNode = foundNode;
				do {
					path.unshift(curNode.aNode);
					curNode = curNode.nodeParent;
				} while(curNode.nodeParent != null);
			}

			return path;
		}
	}
}
