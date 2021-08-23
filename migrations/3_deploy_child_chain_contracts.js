const DAI = artifacts.require("DAI");
const USDC = artifacts.require("USDC");
const WETH = artifacts.require("WETH");
const WSX = artifacts.require("WSX");
const utils = require("./utils");
const config = require("./config");

module.exports = async (deployer, network, accounts) => {
  deployer.then(async () => {
    await deployer.deploy(DAI, "DAI", "DAI", 18, config.erc20Handler);
    await deployer.deploy(USDC, "USD Coin", "USDC", 6, config.erc20Handler);
    await deployer.deploy(
      WETH,
      "Wrapped Ether",
      "WETH",
      18,
      config.erc20Handler
    );
    await deployer.deploy(WSX, "Wrapped SX", "WSX", 18, config.erc20Handler);

    const contractAddresses = utils.getContractAddresses();

    contractAddresses.child.DAI = DAI.address;
    contractAddresses.child.USDC = USDC.address;
    contractAddresses.child.WETH = WETH.address;
    contractAddresses.child.WSX = WSX.address;

    utils.writeContractAddresses(contractAddresses);
  });
};
