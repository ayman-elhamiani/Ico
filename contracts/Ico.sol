// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
 
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "./KYC.sol";
import "./Pausable.sol"; 
 
contract Ico is ERC20Capped{

  ERC20 public _ERC20token;
  KYC public _KYC;
  address public wallet;
  event RecipientChanged(uint when, address newRecipient);

 
  // Crowdsale Stages
  enum CrowdsaleStage { presale, publicsale }
  // Default to presale stage
  CrowdsaleStage public stage = CrowdsaleStage.presale;
  //rate
  uint256 public rate = 500 ;
  event RateChanged(uint when, uint256 newRate);

  //investing cap
  uint256 public investorMinCap = 2;
  uint256 public investorHardCap = 500;

  mapping(address => uint256) public contributions;
  uint256 public _totalSupply;
  uint256 public MaxSupply;
  event TokensPurchased(address who, uint amount);

 //done
   bool public isFinalized = false;
   uint256 public goal;

 //time start && end
 uint256 public openingTime;
 uint256 public closingTime;

 enum State { Active, Refunding, Closed }
  State public state = State.Active;
  event Finalized();
  event Closed();
  event RefundsEnabled();
  event Refunded(address indexed beneficiary, uint256 weiAmount);


 
  //timer
  modifier onlyWhileOpen {
   // solium-disable-next-line security/no-block-members
   require(block.timestamp >= openingTime && block.timestamp <= closingTime,"lwaaaaaa9t");
   _;
 }
 
 constructor(ERC20 _token, address payable _wallet, uint256 _cap, KYC _kyc, uint256 _goal, uint256 _openingTime, uint256 _closingTime) ERC20(_token.name(), _token.symbol()) ERC20Capped(_cap){
           _ERC20token = _token;
           _KYC = _kyc;
           goal = _goal;
           wallet = _wallet;
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

   function changeRecipient(address payable _newRecipient) public {
        require(_newRecipient != address(0), "address 0.");
        wallet = _newRecipient;
        emit RecipientChanged(block.timestamp, _newRecipient);
    }

 function goalReached() public view returns (bool) {
   console.log("hi");
   console.log(totalSupply());
    return totalSupply() >= goal;
  }

 
 function buytoken(uint256 _weiAmount) public payable{
   require(_weiAmount != 0, "ta7at flous ashrif");
   require(openingTime < block.timestamp + 20 minutes &&  closingTime > block.timestamp, "not start yet or end ");
   require(_KYC.isAllowed(msg.sender), " KYC is not completed ");
   uint256 _existingContribution = contributions[msg.sender];
   uint256 _newContribution = _existingContribution + _weiAmount;
   require(_newContribution >= investorMinCap && _newContribution <= investorHardCap,"salam");
       contributions[msg.sender] = _newContribution;
       console.log(_newContribution);
       console.log(_weiAmount * rate);
      //  console.log(_newContribution);

       _mint(msg.sender, _weiAmount * rate);
       _totalSupply = _totalSupply+ (_weiAmount * rate);
       MaxSupply = (_totalSupply *100)/70;
       emit TokensPurchased(msg.sender, _newContribution);
       (bool success, /* data */) = wallet.call{ value: _weiAmount}("");

 }
 
 
 function finalize() public payable{
    require(!isFinalized);
    // require(closingTime < block.timestamp);

    finalization();
    emit Finalized();

    isFinalized = true;
  }
 
   function finalization() internal {
    if (goalReached()) {
      close();
    } else {
      enableRefunds();
    }
  }

    function close() internal {
    require(state == State.Active);
    state = State.Closed;
    transfer(wallet, _totalSupply);
    _mint(msg.sender, MaxSupply - _totalSupply);
    emit Closed();
    
  }

   function enableRefunds() internal {
    require(state == State.Active);
    state = State.Refunding;
    // wallet.transfer(msg.value);
    emit RefundsEnabled();
  }

  function refund(address investor) public payable{
    require(state == State.Refunding);
    console.log("done");
    console.log(contributions[investor]);
    uint256 depositedValue = contributions[investor];
    contributions[investor] = 0;
    console.log("done2");
    console.log(contributions[investor]);
    (bool success, /* data */) = investor.call{ value: depositedValue }("");
    console.log("done3");
    emit Refunded(investor, depositedValue);
  }
 
}
