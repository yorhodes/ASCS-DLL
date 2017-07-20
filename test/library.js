const testASCSDLL = artifacts.require('testASCSDLL.sol');
const abi = require('ethereumjs-abi');

const encodeBytes32 = (stringArray) => {
    return stringArray.map((string) =>  {
        return "0x" + abi.rawEncode(["bytes32"], [ string ]).toString('hex');
    });
}

contract('Library Testing', (accounts) => {

    it('should set options', async () => {
        let proxy = await testASCSDLL.deployed();
        let attrNames = encodeBytes32(['numTokens', 'commitHash']);
        await proxy.setOptions(attrNames,0);
        let proxyAttrNames = await proxy.getAttrNames.call();
        proxyAttrNames.map((attrName, idx) => { 
            assert.equal(attrName, attrNames[idx], "Attribute name is set incorrectly" )
        });
    });

    it("should check getAttr returns 0 when dll is empty", async () => {
        let proxy = await testASCSDLL.deployed();
        let result = await proxy.getAttr.call('10', 'prev');
        assert.equal(result, 0, "getAttr returns incorrectly");
    });

    it("should check setAttr sets property", async () => {
        let proxy = await testASCSDLL.deployed();
        await proxy.setAttr('10', 'next', '25');
        await proxy.setAttr('25', 'prev', '10');
        let prev = await proxy.getAttr.call('25', 'prev');
        let next = await proxy.getAttr.call('10', 'next');
        assert.equal(next, '25', "setAttr set attribute incorrectly");
        assert.equal(prev, '10', "setAttr set attribute incorrectly");
    });


});

