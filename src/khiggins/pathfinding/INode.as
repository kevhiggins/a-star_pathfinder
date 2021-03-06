package khiggins.pathfinding {
	
	/**
	* Nodes Implementing this interface are granted A* pathfinding capabilities.
	*/
	public interface INode {
		/**
		* Returns the x axis location.
		*
		* @return Node's x axis location. 
		*/
		function get xLoc():int;
		/**
		* Returns the y axis location.
		*
		* @return Node's y axis location. 
		*/
		function get yLoc():int;
		/**
		* Returns true if the node is passable, else false.
		*
		* @return Passability of node.
		*/
		function get isPassable():Boolean;
		/**
		* Returns an Array of all adjacent nodes.
		*
		* @return All nodes adjacent to this node (Not diagonal adjacents). 
		*/
		function getAdjacentNodes():Array;
	}
}
