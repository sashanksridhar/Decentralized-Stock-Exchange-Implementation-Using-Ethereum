pragma solidity ^0.4.21;
contract coinjoin {
    
  function coinjoin ()  payable{}
  function () payable{
}
  
  function transfertoseller (address seller, uint amount) external payable {
  	seller.transfer(amount);
  }
  
}
