const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = require ("ethers");

describe("Ico contract", function () {
 let Token;
 let hardhatToken;
 let ico;
 let hardhatIco;
 let whitelist;
 let hardhatWhitelist;
 beforeEach(async () =>{
 
   [deployer, user1, user2,user3, ...users] = await ethers.getSigners();
   Token = await ethers.getContractFactory("Token"); 
   hardhatToken = await Token.deploy("Black Eye Token","BET");
 
   whitelist = await ethers.getContractFactory("Whitelist")
   hardhatWhitelist = await whitelist.deploy();
 
   const openingTime = Math.floor(new Date().getTime() / 1000) +1000
   const closingTime = openingTime + 300000
   const cap = 100000
   ico = await ethers.getContractFactory("Ico");
   hardhatIco = await ico.deploy(hardhatToken.address, cap, hardhatWhitelist.address, openingTime, closingTime);
 
 })
 

 
 
 it("totalsupply is correct", async function(){
  await hardhatWhitelist.setKYCComleted(user1.address)
  await hardhatIco.validat(user1.address, '10')
  expect((await hardhatIco.totalSupply()).toString()).to.equal('50')
});

it("test transation 1", async function() {
  await hardhatWhitelist.setKYCComleted(user1.address)
  await hardhatIco.validat(user1.address, '10')
  expect(await hardhatIco.balanceOf(user1.address)).to.equal(50);
});

it("rate is correct", async function(){
  await hardhatIco.setCrowdsaleStage(1)
  expect((await hardhatIco.getrate()).toString()).to.equal('250')
});

it("contribution is correct", async function(){
  await hardhatWhitelist.setKYCComleted(user1.address)
  await hardhatIco.validat(user1.address, '10')
  expect((await hardhatIco.contribution(user1.address)).toString()).to.equal('10')
});


  
});