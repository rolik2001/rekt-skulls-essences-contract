require("@nomicfoundation/hardhat-toolbox");
require('@openzeppelin/hardhat-upgrades');
require("hardhat-gas-reporter");
require('hardhat-contract-sizer');

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    ganache: {
      url: "http://127.0.0.1:8545",
      from: "",
      // accounts: [privateKey1, privateKey2, ...]
      accounts: []
    },

    goerli:{
      url:"https://goerli.infura.io/v3/5692ba0997d84589be96eef773ab2e88",
      from:"0x1ea973d812C10Eaf19F3623d76555894DCB368e8",
      accounts:["2b85e973f83e404f80569c43ae3554a783e407cd19d20e08d869e50b7bc014c9"]
    }
  },
  solidity: {
    version: "0.8.12",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
};
