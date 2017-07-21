const testASCSDLL = artifacts.require('testASCSDLL.sol');
const abi = require('ethereumjs-abi');

const re = new RegExp("(invalid opcode)","i");
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

    it("should check getPrev and getNext", async () => {
        let proxy = await testASCSDLL.deployed();
        let prev = await proxy.getPrev.call('25');
        let next = await proxy.getNext.call('10');
        assert.equal(next, '25', "getNext gets next incorrectly");
        assert.equal(prev, '10', "getPrev gets prev incorrectly");
    });

    it("should insert to an empty list", async () => {
        let proxy = await testASCSDLL.deployed();
        await proxy.insert('0', '10', [10, 0xabc], {from:accounts[1]}); 
        let next = await proxy.getNext.call('0', {from:accounts[1]});
        assert.equal(next, '10', "Inserted node is not in list");
        let nextAttr0 = await proxy.getAttr.call(next, 'numTokens', {from:accounts[1]});
        let nextAttr1 = await proxy.getAttr.call(next, 'commitHash', {from:accounts[1]});
        assert.equal(nextAttr0, 10, "Integer attribute inserted incorrectly");
        assert.equal(nextAttr1, Number('0xabc'));
    });

    it("should throw when trying to insert in wrong order", async () => {
        let proxy = await testASCSDLL.deployed();
        try {
            let tx = await proxy.insert('0', '8', [15, 0xabc], {from:accounts[1]});
            assert("insert allowed wrong ordering");
        }
        catch(err) {}
    });

    it("should update when trying to insert in existing node id", async () => {
        let proxy = await testASCSDLL.deployed();
        await proxy.insert('0', '10', [20, 0xabc], {from:accounts[1]}); 
        let next = await proxy.getNext.call('0', {from:accounts[1]});
        let nextAttr0 = await proxy.getAttr.call(next, 'numTokens', {from:accounts[1]});
        assert.equal(nextAttr0, 20, "Integer attribute updated incorrectly");
    });

    it("should remove node from list", async () => {
        let proxy = await testASCSDLL.deployed();
        await proxy.remove('10', {from:accounts[1]});
        let next0 = await proxy.getNext.call('0', {from:accounts[1]});
        let prev0 = await proxy.getPrev.call('0', {from:accounts[1]});
        assert.equal(prev0, '0', 'node not removed correctly');
        assert.equal(next0, '0', 'node not removed correctly');
        let nextRemoved = await proxy.getNext.call('10', {from:accounts[1]});
        let prevRemoved = await proxy.getPrev.call('10', {from:accounts[1]});
        assert.equal(prevRemoved, '10', 'node not removed correctly');
        assert.equal(nextRemoved, '10', 'node not removed correctly');

    });

});

