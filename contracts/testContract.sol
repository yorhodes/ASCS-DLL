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
}
