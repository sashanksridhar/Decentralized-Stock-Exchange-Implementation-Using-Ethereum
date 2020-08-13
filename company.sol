pragma solidity ^0.4.21;

/**
 * The Company contract does this and that...
 */
/**
  * The ce contract does this and that...
  */
 contract centralInterface {
 		function IPO (address sell,uint oPrice,uint nshares);
 		function sell (address buyeraccept ,address sellercompany,uint nshares);
 		function sellOrderFunc (address company,uint nshares,uint oPrice);
 		function  getAddress (address buyer) returns(address a);
 }
 contract Buyer{
 
     function getAddress() returns(address a);
 }
  
contract Company {
	struct  ShareHolders {
		
		uint amountOfShares;
		uint percentageOfCompany;
		bool check;
	}
	string public companyName;
	uint public totalValue;
	uint public offerPrice;
	uint public noOfSharesToBeSold;
	uint public totalNumberOfShares;

	address public majorShareHolder;

	mapping ( address => ShareHolders)public listofshareholders;
	uint public countOfShareHolders;
	address[] public stockholders;
 
 function () payable{
}

	function Company (string cname,uint oprice, uint tshares) {
		offerPrice = oprice;
		totalNumberOfShares = tshares;
		totalValue = totalNumberOfShares * offerPrice;

	//	require (msg.sender.balance >= totalValue * 1 ether);
		majorShareHolder = msg.sender;
		companyName = cname;
		
		listofshareholders[majorShareHolder] = ShareHolders(tshares,100,true);
		countOfShareHolders=1;
		stockholders.push(msg.sender);
	}	
	function launchIPO (address centralExchange,uint nshares) public {
		
		require (msg.sender == majorShareHolder);
		require (nshares<=totalNumberOfShares);
		noOfSharesToBeSold = nshares;

		centralInterface center = centralInterface(centralExchange);
		center.IPO(msg.sender,offerPrice,noOfSharesToBeSold);
		
	}
	function setOfferPrice (uint price) external {
		offerPrice = price;
		totalValue = totalNumberOfShares*offerPrice;

	}
	function getOfferPrice () external returns(uint) {
		return offerPrice;
	}
	function getTotalShare ()external returns(uint)  {
		return totalNumberOfShares;
	}
	
	function sellToBuyer(address exhange,address buyer,uint nshares)
	{
	    centralInterface c = centralInterface(exhange);
		c.sell(buyer,msg.sender,nshares);
	}
	function  sellStocks (address buyer,address seller,uint nshares) external {
		listofshareholders[seller].amountOfShares = listofshareholders[seller].amountOfShares-nshares;
		noOfSharesToBeSold -= nshares;
		listofshareholders[seller].percentageOfCompany = uint(listofshareholders[seller].amountOfShares)*uint(100)/uint(totalNumberOfShares);
		if(listofshareholders[buyer].check==false)
		{
			listofshareholders[buyer] = ShareHolders(nshares,uint(nshares)*uint(100)/uint(totalNumberOfShares),true);
			stockholders.push(buyer);
			countOfShareHolders++;
		}
		else
		{
			listofshareholders[buyer].amountOfShares +=nshares;
			listofshareholders[buyer].percentageOfCompany =uint(listofshareholders[seller].amountOfShares)*uint(100)/uint(totalNumberOfShares);
		}
		if(listofshareholders[seller].amountOfShares==0)
		{
			listofshareholders[seller].check=false;
			for(uint i=0;i<countOfShareHolders;i++)
			{
				if(stockholders[i]==seller)
				{
					delete stockholders[i];
					stockholders[i] = stockholders[countOfShareHolders-1];
					stockholders.length--;
					countOfShareHolders--;
					break;
				}
			}
		}
		if(listofshareholders[majorShareHolder].percentageOfCompany<listofshareholders[buyer].percentageOfCompany)
		{
			majorShareHolder=buyer;
		}
		
	}
	
	function  placeSellOrder (address centralexchange, uint noOfStocks,uint oprice) public  {
    	centralInterface c = centralInterface(centralexchange);
    	
    //	address buyercontract = c.getAddress(msg.sender);
    	require (listofshareholders[msg.sender].amountOfShares>=noOfStocks);
    	
    	
    	c.sellOrderFunc(msg.sender,noOfStocks,oprice );
    }
	

}
