const { expect } = require("chai");

describe("Token contract", function () {
  let Token;
  let hardhatToken;

  beforeEach(async () =>{
    [deployer, user1, user2,user3, ...users] = await ethers.getSigners();
    Token = await ethers.getContractFactory("Token");
    hardhatToken = await Token.deploy("Black Eye Token","BET",100000);

    ico = await ethers.getContractFactory("Ico");
    hardhatIco = await ico.deploy(hardhatToken.address,10);

  }) 

  it("contract is correct", async function(){
    expect(await hardhatIco.num()).to.equal(0);
  });


  
});