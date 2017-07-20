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

    function getAttribute(Data storage self, uint curr, bytes32 attributeName) returns (uint) {
        return self.store[sha3(msg.sender, curr, attributeName)];
    }

    function setAttribute(Data storage self, uint curr, bytes32 attributeName, uint attributeValue) {
        self.store[sha3(msg.sender, curr, attributeName)] = attributeValue;
    }

    function insert(Data storage self, uint prev, uint id, uint[] attributeValues) {
        require(self.attributes.length == attributeValues.length);

        uint next = getAttribute(self, prev, "next");

        // set next node's prev attribute to new node id
        setAttribute(self, next, "prev", id);              

        // set prev node's next attribute to new node id
        setAttribute(self, prev, "next", id);             

        // make new node point to prev and next
        setAttribute(self, id, "prev", prev); 
        setAttribute(self, id, "next", next); 

        // set additional attributes of new node
        for(uint idx = 0; idx < self.attributes.length; idx++) {
            setAttribute(self, id, self.attributes[idx], attributeValues[idx]);
        }
    }

    /// preserves additional data
    function remove(Data storage self, uint curr) {
        uint prev = getAttribute(self, curr, "prev");
        uint next = getAttribute(self, curr, "next");

        setAttribute(self, prev, "next", next);
        setAttribute(self, next, "prev", prev);

        setAttribute(self, curr, "next", curr);
        setAttribute(self, curr, "prev", curr);
    }

    /// destroyes additional data
    function reset(Data storage self, uint curr) {
        remove(self, curr);

        // reset additional attributes of node
        for(uint idx = 0; idx < self.attributes.length; idx++) {
            setAttribute(self, curr, self.attributes[idx], 0);
        }
    }
}
