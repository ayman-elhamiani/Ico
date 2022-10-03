const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("whitelist contract", function () {

 let whitelist;
 let hardhatWhitelist;
 beforeEach(async () =>{
 
   [deployer, user1, user2,user3, ...users] = await ethers.getSigners();
 
   KYC = await ethers.getContractFactory("KYC")
   hardhatKYC = await KYC.deploy();
 
 })
 
 it("user is allowed", async function(){
   await hardhatKYC.setKYCComleted(user1.address)
   expect(await hardhatKYC.isAllowed(user1.address)).to.equal(true)
 });
 
  
});