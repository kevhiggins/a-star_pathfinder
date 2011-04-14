package khiggins.pathfinding {

	/* A custom array to store PathNodes. Overrides some array functionality for ease of use */
	public dynamic class PathNodeList extends Array {

		/**
		* Creates a PathNodeList extending array.
		* @param args inital elements to initialize in PathNode List
		*/
		public function PathNodeList(...args)
		{
				var n:uint = args.length
				if (n == 1 && (args[0] is Number))
				{
				    var dlen:Number = args[0];
				    var ulen:uint = dlen;
				    if (ulen != dlen)
				    {
				        throw new RangeError("Array index is not a 32-bit unsigned integer ("+dlen+")");
				    }
				    length = ulen;
				}
				else
				{
				    length = n;
				    for (var i:int=0; i < n; i++)
				    {
				        this[i] = args[i] 
				    }
				}
		}


		/**
		* Override default sort behavior to sort by fCost.
		* @param args allows for alternate sort functionality.
		*/
		AS3 override function sort(... args):* {
			if(args.length == 0) {
				this.sortOn("fCost", Array.NUMERIC);	
			}
			else {
				return super.sort.apply(this, args);
			}
			return null;
		}

		/**
		* Removes impassable nodes from this PathNodeList.
		*/
		public function removeImpassable():void {
			var delIndices:Array = new Array();
			for (var i:int=0; i < this.length; i++) {
				var curNode:PathNode = this[i]; 
				if(!curNode.isPassable) {
					delIndices.unshift(i);
				}
			}

			for each (var indice:int in delIndices) {
				this.splice(indice, 1);
			}
		}

		/**
		* Removes nodes that are shared between lists from this list.
		* @param nodeList PathNodeList to compare with this PathNodeList to determing element removal.
		*/
		public function removeShared(nodeList:PathNodeList):void {
			var delIndices:Array = new Array();
			for (var i:int=0; i < this.length; i++) {
				var curThis:PathNode = this[i]; 
				for each (var curThat:PathNode in nodeList) {
					if(curThis.isEqual(curThat)) {
						delIndices.unshift(i);
						break;
					}
				}
			}

			for each (var indice:int in delIndices) {
				this.splice(indice, 1);
			}
		}

		/**
		* Merges lists into this list giving priority to low gCost nodes.
		* @param nodeList PathNodeList to merge into this.
		*/
		public function mergeUnique(nodeList:PathNodeList):void {
			var listLength:int = this.length
			for each (var curThat:PathNode in nodeList) {
				var isUnique:Boolean = true;
				for (var i:int=0; i < listLength; i++) {
					var curThis:PathNode = this[i];
					if(curThis.isEqual(curThat)) {
						if(curThis.gCost > curThat.gCost){
							this[i] = curThat;
						}
						isUnique = false;
					}
				}
				if(isUnique) {
					this.push(curThat);
				}
			}
		}

		/**
		* Calculates the costs for all PathNodes in list.
		* @param endNode End point to reference for calculating costs.
		*/
		public function calculateNodes(endNode:PathNode):void {
			var listLength:int = this.length;
			for (var i:int; i < listLength; i++) {
				var curNode:PathNode = this[i];
				curNode.calculateCosts(endNode);
			}
		}
	}
}
