pragma solidity^0.4.11;

library ASCSDLL {
    mapping(bytes32 => uint) store;

    bytes32[] attributes;
    uint sortAttributeIndex;

    function setOptions(bytes32[] _attributes, uint _sortAttributeIndex) {
        attributes = _attributes;
        sortAttributeIndex = _sortAttributeIndex;
    }

    function getAttribute(uint curr, bytes32 attributeName) returns uint {
        return store[sha3(msg.sender, curr, attributeName)];
    }

    function setAttribute(uint curr, bytes32 attributeName, uint attributeValue) {
        store[sha3(msg.sender, curr, attributeName)] = attributeValue;
    }

    function insert(uint prev, uint id, uint[] attributeValues) {
        require(attributes.length == attributeValues.length);

        uint next = getAttribute(prev, "next");

        // set next node's prev attribute to new node id
        setAttribute(next, "prev", id);              

        // set prev node's next attribute to new node id
        setAttribute(prev, "next", id);             

        // make new node point to prev and next
        setAttribute(id, "prev", prev); 
        setAttribute(id, "next", next); 

        // set additional attributes of new node
        for(uint idx = 0; idx < attributes.length; idx++) {
            setAttribute(curr, attributes[idx], attributeValues[idx]);
        }
    }
}
