// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

//import "./Pausable.sol";


contract Ico {
    ERC20 immutable private _ERC20token;
    uint8 private numAddressesWhitelisted;
    uint8 private maxWhitelistedAddresses;
    mapping(address => bool) private whitelistedAddresses;


  constructor(ERC20 _token, uint8 _maxWhitelistedAddresses){ 
            _ERC20token = _token;
            maxWhitelistedAddresses =  _maxWhitelistedAddresses;
  } 


  function addAddressToWhitelist() public {
        require(!whitelistedAddresses[msg.sender], "Sender has already been whitelisted");
        require(numAddressesWhitelisted < maxWhitelistedAddresses, "More addresses cant be added, limit reached");
        whitelistedAddresses[msg.sender] = true;
        numAddressesWhitelisted += 1;
    }
  function num() public view returns(uint256) {
        return numAddressesWhitelisted;
    }
}