pragma solidity ^0.4.21;

/**
 * The Buyer contract does this and that...
 */
/**
 * The contractName contract does this and that...
 */
contract Central {
	function buyorder(address company, uint oPrice,uint nshares);
	function mapcreate(address buyer);
}
/**
 * The contractName contract does this and that...
 */
contract Company {
	function getTotalShare() returns(uint);
}

contract coinjoin{
	function transfertoseller(address seller,uint amount);
	
}

contract Buyer {
	address public buyerAddress;
	uint public funds;
	address public coinjoinadd;
    address public cwallet;
	struct Companys{
        uint noOfStocks;
        uint percentageOfCompany;
        bool check;
    }
 mapping (address => Companys)public listOfCompanies;
    uint public noOfCompanies;
    address[] public companies;
	function Buyer (address centralexchange, address cj) payable{
		buyerAddress = msg.sender;
		coinjoinadd= cj;
	
	//	require (msg.sender.balance >= msg.value);
		 funds = msg.value;

		 Central c = Central(centralexchange);
		 c.mapcreate(msg.sender);
	}
 
 function () payable{
}
	function  addBalance () public payable {
		
		require (msg.sender == buyerAddress);

	//	require (msg.value <= msg.sender.balance);
		
		funds += msg.value ;

		
	}
	function checkFunds() public{
	    funds = this.balance;
	}
		function  getAddress () external returns(address a)  {
		return buyerAddress;
	}
	function transfer (address sellercompany,address company,uint nshares,uint price) external payable {
require(this.balance>=price*nshares);
coinjoin cjoin = coinjoin(coinjoinadd);
		coinjoinadd.transfer(price*nshares);
 		cjoin.transfertoseller(sellercompany,price*nshares);
		//funds -= price*nshares;
		
	funds = this.balance;
 		if(listOfCompanies[company].check == false)
 {
 noOfCompanies +=1;
 companies.push(company);
 Company c = Company(company);
 
 listOfCompanies[company] = Companys(nshares,uint(nshares)*uint(100)/uint(c.getTotalShare()),true);

 }
else
{
	listOfCompanies[company].noOfStocks += nshares;
	Company c1 = Company(company);
	listOfCompanies[company].percentageOfCompany = uint(listOfCompanies[company].noOfStocks)*uint(100)/uint(c1.getTotalShare());
}


	}
	

    function  placeBuyOrder (address centralexchange,address company, uint noOfStocks,uint oprice) public  {
    	Central c = Central(centralexchange);
    	c.buyorder(company,noOfStocks,oprice );
    }
    
}

