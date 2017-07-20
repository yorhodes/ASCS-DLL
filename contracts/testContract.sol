pragma solidity^0.4.11;

import "./ASCSDLL.sol";

contract  testASCSDLL {
    using ASCSDLL for ASCSDLL.Data;
    ASCSDLL.Data dll;

    function setOptions(bytes32[] attrName, uint sortAttrIdx){
        dll.setOptions(attrName, sortAttrIdx);
    }

    function getAttrNames() returns (bytes32[]){
        return dll.attrNames;
    }

    function getAttr(uint curr, bytes32 attrName) returns (uint) {
        return dll.getAttr(curr, attrName);
    }

    function setAttr(uint curr, bytes32 attrName, uint attrVal) {
        dll.setAttr(curr, attrName, attrVal);
    }

    function getNext(uint curr) returns (uint) {
        return dll.getNext(curr);
    }

    function getPrev(uint curr) returns (uint) {
        return dll.getPrev(curr);
    }

    function insert(uint prev, uint id, uint[] attrVals) {
        dll.insert(prev, id, attrVals);
    }
}
