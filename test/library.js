const testASCSDLL = artifacts.require('testASCSDLL.sol');
const abi = require('ethereumjs-abi');

contract('Library Testing', (accounts) => {
    const encodeBytes32 = (stringArray) => {
        return stringArray.map((string) =>  {
            return "0x" + abi.rawEncode(["bytes32"], [ string ]).toString('hex');
        });
    }

    it('should set options', async () => {
        let proxy = await testASCSDLL.deployed();
        let attrNames = encodeBytes32(['numTokens', 'commitHash']);
        await proxy.setOptions(attrNames,0);
        let proxyAttrNames = await proxy.getAttrNames.call();
        proxyAttrNames.map((attrName, idx) => { 
            assert.equal(attrName, attrNames[idx], "Attribute name is set incorrectly" )
        });
    });
});
      
