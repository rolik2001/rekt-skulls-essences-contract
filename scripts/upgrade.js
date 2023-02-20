const {ethers, upgrades} = require("hardhat");

async function main() {
    console.log("Started Upgrade")
    const RektSkullsEssence = await ethers.getContractFactory("RektSkullsEssence");
    await upgrades.upgradeProxy("0xfaEc7a6B9ED6195e4b7B934130944526Db4F88dC", RektSkullsEssence);
    console.log("RektSkullsEssence upgraded");
}

main();