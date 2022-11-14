// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol"; //use ERC20 standard

contract PickNPayToken is ERC20 {
  constructor() ERC20("PickNPay", "PnP") {

  }

  function mint(uint256 amount) public {  //Mint user-specified number of PnPTokens
    _mint(msg.sender, amount);
  }
}

