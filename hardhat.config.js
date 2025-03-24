require("@nomicfoundation/hardhat-toolbox");
require("@openzeppelin/hardhat-upgrades");

// npx hardhat vars list
// npx hardhat vars set TEST_API_KEY
const INFURA_API_KEY = vars.get("INFURA_API_KEY");
const POLYGONSCAN_AMOY_API_KEY = vars.get("POLYGONSCAN_AMOY_API_KEY");
const POLYGONSCAN_API_KEY = vars.get("POLYGONSCAN_API_KEY");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.29",
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
    metadata: {
      useLiteralContent: false,
    },
  },
  sourcify: {
    enabled: true,
  },
  networks: {
    localhost: {
      accounts: [vars.get("TEST_PK")],
      url: "http://127.0.0.1:8545",
    },
    amoy: {
      url: `https://polygon-amoy.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [vars.get("TEST_PK")],
    },
    polygon: {
      url: `https://polygon-mainnet.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [vars.get("MAIN_PK")],
    },
  },
  etherscan: {
    apiKey: {
      // Pour la vérification, on utilise la clé associée au réseau "amoy"
      polygonAmoy: POLYGONSCAN_API_KEY,
      polygon: POLYGONSCAN_API_KEY,
    },
    customChains: [
      {
        network: "amoy",
        chainId: "80002",
        urls: {
          // https://docs.polygonscan.com/getting-started/endpoint-urls
          // npx hardhat verify --network amoy 0xE28b99E2a7D4456a67d42bd9b8D27e47D8d0e2b2 [constructor arguments]
          // npx hardhat verify --network amoy 0xE28b99E2a7D4456a67d42bd9b8D27e47D8d0e2b2 --constructor-args scripts/args/kolocash-args.js
          apiURL: "https://api-amoy.polygonscan.com/api",
          browserURL: "https://amoy.polygonscan.com/",
        },
      },
    ],
  },
};
