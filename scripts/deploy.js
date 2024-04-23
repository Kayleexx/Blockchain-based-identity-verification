async function main() {
    // Hardhat Ethereum library import
    const { ethers } = require("hardhat");
  
    // Contract deployment information
    const IdentityVerificationSystem = await ethers.getContractFactory("IdentityVerificationSystem");
    console.log("Deploying IdentityVerificationSystem...");
  
    // Deploying the contract
    const identityVerificationSystem = await IdentityVerificationSystem.deploy();
  
    // Waiting for contract deployment
    await identityVerificationSystem.deployed();
  
    // Displaying contract address
    console.log("IdentityVerificationSystem deployed to:", identityVerificationSystem.address);
  }
  
  // Executing the main function
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
  