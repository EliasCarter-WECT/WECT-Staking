require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-verify");
require("dotenv").config();

module.exports = {
  solidity: "0.8.28",
  networks: {
    cronos: {
      url: "https://evm.cronos.org",
      accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: process.env.CRONOSCAN_API_KEY,
    customChains: [
      {
        network: "cronos",
        chainId: 25,
        urls: {
          apiURL: "https://api.cronoscan.com/api",
          browserURL: "https://cronoscan.com/"
        }
      }
    ]
  }
};