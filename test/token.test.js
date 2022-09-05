const { expect } = require("chai");
// describe("verify name",function(){
 
// });




describe("Token contract", function () {
  let Token;
  let hardhatToken;

  beforeEach(async () =>{
    [deployer, user1, user2,user3, ...users] = await ethers.getSigners();
    Token = await ethers.getContractFactory("Token");
    hardhatToken = await Token.deploy("Black Eye Token","BET");
  }) 

  it("name is correct", async function(){
    expect(await hardhatToken.name()).to.equal("Black Eye Token");
  });

  it("symbol is correct", async function(){
    expect(await hardhatToken.symbol()).to.equal("BET");
  });
  
});