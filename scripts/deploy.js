const { ethers } = require("hardhat");

async function main() {

  const Tokenn = await ethers.getContractFactory("Token");
  const deployedToken = await Tokenn.deploy("Black","BET");

}

// Call the main function and catch if there is any error
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
