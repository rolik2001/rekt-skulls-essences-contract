const {ethers, upgrades} = require("hardhat");

async function main() {
    console.log("Started Deployment")
    const RektSkullsEssence = await ethers.getContractFactory("RektSkullsEssence");
    // const essence = await upgrades.deployProxy(RektSkullsEssence,
    //     [],
    //     {
    //       timeout: "0",
    //       pollingInterval: "12000",
    //     });
    // await essence.deployed();
    // console.log("RektSkullsEssence deployed to:", essence.address);
    const box = await upgrades.upgradeProxy("0xfaEc7a6B9ED6195e4b7B934130944526Db4F88dC", RektSkullsEssence);
    console.log("Box upgraded");
}

main();