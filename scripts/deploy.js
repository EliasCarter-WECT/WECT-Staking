const hre = require("hardhat");

async function main() {
  console.log("Deploying WECT Staking contract...");

  const stakingToken = "0x9b09172AcD8b4618674e54a36afb45baF44D4277"; // WECT contractadres
  const rewardToken = "0x9b09172AcD8b4618674e54a36afb45baF44D4277"; // Zelfde token wordt als beloning gebruikt

  const WECTStaking = await hre.ethers.getContractFactory("WECTStaking");
  const wectStaking = await WECTStaking.deploy(stakingToken, rewardToken);

  await wectStaking.waitForDeployment();

  console.log("WECTStaking deployed to:", await wectStaking.getAddress());
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });