import { ethers } from "hardhat";

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  const [deployer] = await ethers.getSigners();
  // const Factory = await ethers.getContractFactory("CreaderV2factory");
  // const factory = await Factory.deploy();
  // await factory.deployed();
  const CopyrightNFT = await ethers.getContractFactory("CreaderV2Copyright");
  const copyrighNFT = await CopyrightNFT.deploy();
  await copyrighNFT.deployed();

  console.log(`deployed to ${copyrighNFT.address}`);
  await copyrighNFT.functions.mint("tttt");
  // console.log(`deployed to ${factory.address}`);
  // const copyright = await factory.functions.createCopyright(deployer.address);
  // console.log(`deployed to ${copyright}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
