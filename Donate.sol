// SPDX-License-Identifier: Unlicense
pragma solidity >=0.4.22 <0.9.0;
//pragma solidity ^0.8.4;

import "./MintPnPToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Donate is Ownable {

    PickNPayToken yourToken; //import PickNPay Token
    uint256 public tokensETH = 10; // 10 tokens per 1 Ether
    address constant public ShelterAddress = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148; //fixed shelter address

    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    constructor() {
    }

    function addToken(address tokenAddress) external {
        yourToken = PickNPayToken(tokenAddress);
    }


    function buyTokens() public payable returns (uint256 tokenAmount) {
        require(msg.value > 0, "Please send ETH to proceed"); //checks that ETH is sent

        uint256 amountToDonate = msg.value * tokensETH;  // donor will send 2 ETH which will buy (2x10) tokens
        uint256 PickNPayBalance = yourToken.balanceOf(address(this)); //balance of the reserve
        require(PickNPayBalance >= amountToDonate, "PickNPay has insufficient tokens");

        (bool sent) = yourToken.transfer(ShelterAddress, amountToDonate); //transfer tokens to shelter address
        require(sent, "Failed to transfer token to user");

        emit BuyTokens(ShelterAddress, msg.value, amountToDonate);
        return amountToDonate;
    }

   //-------------------------------------------------------------------------------------------------------------

    //Precatution
    //send all the ETH stored in the smart contract into the owner’s wallet. Can only be run by the owner of the contract.
    function withdraw() public onlyOwner {
        uint256 ownerBalance = address(this).balance;
        require(ownerBalance > 0, "No ETH present available");
        (bool sent,) = msg.sender.call{value : address(this).balance}("");
        require(sent, "Failed to withdraw");
    }

    // To allow contract to receive ether
    fallback() external payable {} 
    receive() external payable {}
}