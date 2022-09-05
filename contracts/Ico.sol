// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "./Whitelist.sol";
 
 
contract Ico is ERC20Capped{
    ERC20 public _ERC20token;
   Whitelist public _KYC;
 
  // Crowdsale Stages
 enum CrowdsaleStage { presale, publicsale }
 // Default to presale stage
 CrowdsaleStage public stage = CrowdsaleStage.presale;
 uint256 public rate = 5 ;
  event RateChanged(uint when, uint256 newRate);

  //investing cap
  uint256 public investorMinCap = 2;
  uint256 public investorHardCap = 500;
  mapping(address => uint256) public contributions;
  event TokensPurchased(address who, uint amount);

 //done
   bool public isFinalized = false;

 //time start && end
 uint256 public openingTime;
 uint256 public closingTime;
 
  //timer
  modifier onlyWhileOpen {
   // solium-disable-next-line security/no-block-members
   require(block.timestamp >= openingTime && block.timestamp <= closingTime,"lwaaaaaa9t");
   _;
 }
 
 constructor(ERC20 _token, uint256 _cap, Whitelist _kyc, uint256 _openingTime, uint256 _closingTime) ERC20(_token.name(), _token.symbol()) ERC20Capped(_cap){
           _ERC20token = _token;
           _KYC = _kyc;
           require(_openingTime >= block.timestamp );
           require(_closingTime >= _openingTime);
           openingTime = _openingTime;
           closingTime = _closingTime;
 }
 
 function setCrowdsaleStage(uint8 _stage) public {
   if(uint8(CrowdsaleStage.presale) == _stage) {
     stage = CrowdsaleStage.presale;
   } else if (uint8(CrowdsaleStage.publicsale) == _stage) {
     stage = CrowdsaleStage.publicsale;
   }
 
   if(stage == CrowdsaleStage.presale) {
     rate = 500;
   } else if (stage == CrowdsaleStage.publicsale) {
     rate = 250;
   }
   emit RateChanged(block.timestamp, rate);
 }
 
 function getrate() public view returns (uint256){
   return rate;
 }
  function contribution(address _who) public view returns (uint256) {
        return contributions[_who];
  }
 
 function validat(address _beneficiary, uint256 _weiAmount) public{
   require(_weiAmount != 0, "ta7at folous ashrif");
   //time
   require(openingTime < block.timestamp + 20 minutes &&  closingTime > block.timestamp, "time is end ");
   require(_KYC.isAllowed(_beneficiary), "Crowdsale: Caller KYC is not completed yet.");
   uint256 _existingContribution = contributions[_beneficiary];
   uint256 _newContribution = _existingContribution + _weiAmount;
   require(_newContribution >= investorMinCap && _newContribution <= investorHardCap,"salam");
       contributions[_beneficiary] = _newContribution;
       console.log(_newContribution);
        console.log(_weiAmount * rate);
      //  console.log(_newContribution);

       _mint(_beneficiary, _weiAmount * rate);
       emit TokensPurchased(_beneficiary, _newContribution);
 }
 

 
 
}
