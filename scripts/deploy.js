const {ethers, upgrades} = require("hardhat");

async function main() {
    console.log("Started Deployment")
    const RektSkullsEssence = await ethers.getContractFactory("RektSkullsEssence");
    const essence = await upgrades.deployProxy(RektSkullsEssence,
        [],
        {
          timeout: "0",
          pollingInterval: "12000",
        });
    await essence.deployed();
    console.log("RektSkullsEssence deployed to:", essence.address);
}

main();