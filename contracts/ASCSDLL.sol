pragma solidity^0.4.11;

library ASCSDLL {
    struct Data {
        mapping(bytes32 => uint) store;

        bytes32[] attributes;
        uint sortAttributeIndex;
    }

    function setOptions(Data storage self, bytes32[] _attributes, uint _sortAttributeIndex) {
        self.attributes = _attributes;
        self.sortAttributeIndex = _sortAttributeIndex;
    }

    function getAttribute(Data storage self, uint curr, bytes32 attrName) returns (uint) {
        return self.store[sha3(msg.sender, curr, attrName)];
    }

    function setAttribute(Data storage self, uint curr, bytes32 attrName, uint attrVal) {
        self.store[sha3(msg.sender, curr, attrName)] = attrVal;
    }

    function getNext(Data storage self, uint curr) returns (uint) {
        return getAttribute(self, curr, "next");
    }

    function getPrev(Data storage self, uint curr) returns (uint) {
        return getAttribute(self, curr, "prev");
    }

    function insert(Data storage self, uint prev, uint id, uint[] attrVals) {
        require(self.attributes.length == attrVals.length);

        uint next = getNext(self, prev);

        // set next node's prev attribute to new node id
        setAttribute(self, next, "prev", id);              

        // set prev node's next attribute to new node id
        setAttribute(self, prev, "next", id);             

        // make new node point to prev and next
        setAttribute(self, id, "prev", prev); 
        setAttribute(self, id, "next", next); 

        // set additional attributes of new node
        for(uint idx = 0; idx < self.attributes.length; idx++) {
            setAttribute(self, id, self.attributes[idx], attrVals[idx]);
        }
    }
    
    /// validate position of curr given prev and its sort attribute value
    function validatePosition(Data storage self, uint prev, uint curr, uint sortAttrVal) returns (bool valid) {
        // get next node  
        uint next = getNext(self, prev);

        // if curr is equal to next, thus next is being updated,
        // update next with the node one further
        if (next == curr) {
            next = getNext(self, next);
        }

        // get prev and next sort attribute values to check for position
        uint prevSortAttrVal = getAttribute(self, prev, self.attributes[self.sortAttributeIndex]);
        uint nextSortAttrVal = getAttribute(self, next, self.attributes[self.sortAttributeIndex]);

        // make sure sort attribute value of curr is in order with adjacent nodes
        if ((prevSortAttrVal <= sortAttrVal) && ((sortAttrVal <= nextSortAttrVal) || next == 0)) {
            return true;
        }
        return false;
    }

    /// removes curr nodes's links from list but preserves its data
    function remove(Data storage self, uint curr) {
        uint prev = getPrev(self, curr);
        uint next = getNext(self, curr);

        setAttribute(self, prev, "next", next);
        setAttribute(self, next, "prev", prev);

        setAttribute(self, curr, "next", curr);
        setAttribute(self, curr, "prev", curr);
    }

    /// deletes nodes attribute data
    function reset(Data storage self, uint curr) {
        remove(self, curr);

        // reset additional attributes of node
        for(uint idx = 0; idx < self.attributes.length; idx++) {
            setAttribute(self, curr, self.attributes[idx], 0);
        }
    }
}
