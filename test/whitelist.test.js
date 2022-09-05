const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("whitelist contract", function () {

 let whitelist;
 let hardhatWhitelist;
 beforeEach(async () =>{
 
   [deployer, user1, user2,user3, ...users] = await ethers.getSigners();
 
   whitelist = await ethers.getContractFactory("Whitelist")
   hardhatWhitelist = await whitelist.deploy();
 
 })
 
 it("user is allowed", async function(){
   await hardhatWhitelist.setKYCComleted(user1.address)
   expect(await hardhatWhitelist.isAllowed(user1.address)).to.equal(true)
 });
 
  
});