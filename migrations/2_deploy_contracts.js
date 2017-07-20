var ASCSDLL = artifacts.require("./ASCSDLL.sol");
var testASCSDLL = artifacts.require("./testASCSDLL.sol");

module.exports = function(deployer) {
    deployer.deploy(ASCSDLL);
    deployer.link(ASCSDLL, testASCSDLL);
    deployer.deploy(testASCSDLL);
};
