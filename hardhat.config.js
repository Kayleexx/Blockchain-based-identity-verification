require("@nomiclabs/hardhat-waffle");

module.exports = {
  solidity: {
    version: "0.8.20",
  },
  networks: {
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com/",
      accounts: ['c78aceb2d7f2519a5f5e6b44681041e17ede92182e1ef76c7a0e42a8abfe3149'],
    },
  },
};