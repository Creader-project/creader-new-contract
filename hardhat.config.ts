import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config({ path: ".env" });

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  // networks: {
  //   goerli: {
  //     url: process.env.GOERLI_RPC_URL,
  //     accounts: [process.env.GOERLI_PRIVATE_KEY || ""],
  //   },
  // },
};

export default config;
