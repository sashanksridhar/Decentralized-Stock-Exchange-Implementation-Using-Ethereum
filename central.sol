pragma solidity ^0.4.21;

/**
 * The  Central contract does this and that...
 */
 /**
  * The CO contract does this and that...
  */
 contract Company {
 	function setOfferPrice (uint price);
 	function getOfferPrice () returns(uint price);
 	function  sellStocks (address buyer,address seller,uint nshares);
 	
 }
 /**
  * The contractName contract does this and that...
  */
 contract Buyer {
 		function transfer (address sellercompany,address company,uint nshares,uint price);
 		function getAddress() returns(address a);
 }
 
contract  Central {
	struct  CompanyDetails {
		
		
		uint offerPrice;
		uint noOfSharesToBeSold;
		
	}
	struct buyerDetails {
		
		uint offerPrice;
		uint noOfShares;
		
	}
	
	
	mapping (address => mapping(address => CompanyDetails)) public sellorder;
	mapping (address => mapping(address => buyerDetails)) public buyinglist;
	mapping (address => mapping (address => bool))public buyersExist;
	mapping ( address => mapping (address => bool) )public sellersExist;
	mapping (address => address[])public buyers;
	mapping (address => address[])public sellers;
	
	mapping (address => address) buyeraddress;
	
	
	function  Central () {
		
	}	

	function mapcreate(address buyer) external{
		buyeraddress[buyer] = msg.sender;
	}
	function  getAddress (address buyer) external returns(address a)  {
		return buyeraddress[buyer];
	}
	
	function IPO (address sell,uint oPrice,uint nshares) external {
		sellorder[msg.sender][sell]  = CompanyDetails(oPrice,nshares);
		sellersExist[msg.sender][sell] = true;
		sellers[msg.sender].push(sell);
	}

	function buyorder(address company,uint nshares,uint oPrice) external{
	
		
		if(!buyersExist[company][msg.sender])
		{
		buyersExist[company][msg.sender] = true;
		buyinglist[company][msg.sender] = buyerDetails(oPrice,nshares);
		buyers[company].push(msg.sender);

		}
		else
		{
			buyinglist[company][msg.sender].offerPrice = oPrice;
			buyinglist[company][msg.sender].noOfShares = nshares;
		}
// 		Company c = Company(company);
// 		c.setOfferPrice((c.getOfferPrice() +oPrice)/2);
checkForBuyer(company,nshares,oPrice,msg.sender);
		
	}
	function checkForBuyer(address company,uint nshares,uint oPrice,address buyer)
	{
	    
	    for(uint i = 0;i<sellers[company].length;i++)
	    {
	        address seller = sellers[company][i];
	        uint price = sellorder[company][seller].offerPrice;
	        uint shares = sellorder[company][seller].noOfSharesToBeSold;
	        if(price==oPrice)
	        {
	            if(shares>=nshares)
	            {
	                sell(buyer,company,seller,nshares);
	               
	                break;
	            }
	            if(shares<nshares)
	            {
	                sell(buyer,company,seller,shares);
	                
	            }
	        }
	    }
	    
	}
		function checkForSeller(address company,uint nshares,uint oPrice,address seller)
	{
	    
	    for(uint i = 0;i<buyers[company].length;i++)
	    {
	        address buyer = buyers[company][i];
	        uint price = buyinglist[company][buyer].offerPrice;
	        uint shares = buyinglist[company][buyer].noOfShares;
	        if(price==oPrice)
	        {
	            if(shares<nshares)
	            {
	                sell(buyer,company,seller,shares);
	               
	                break;
	            }
	            if(shares>=nshares)
	            {
	                sell(buyer,company,seller,nshares);
	                
	            }
	        }
	    }
	    
	}
function sellOrderFunc (address company,uint nshares,uint oPrice)external {
if(!sellersExist[msg.sender][company])
{
	sellersExist[msg.sender][company] = true;
	sellorder[msg.sender][company] = CompanyDetails(oPrice,nshares);
	sellers[msg.sender].push(company);
}
else{
	sellorder[msg.sender][company].offerPrice = oPrice;
	sellorder[msg.sender][company].noOfSharesToBeSold = nshares;
}
// Company c = Company(msg.sender);
// c.setOfferPrice((c.getOfferPrice()+oPrice)/2);
checkForSeller(msg.sender,nshares,oPrice,company);
}

	function sell (address buyeraccept ,address company,address sellercompany,uint nshares)  {
		sellorder[company][sellercompany].noOfSharesToBeSold -= nshares;
		if(sellorder[company][sellercompany].noOfSharesToBeSold==0)
		{
			sellersExist[company][sellercompany] = false;
			for(uint i = 0;i< sellers[company].length;i++)
			{
				if(sellers[company][i]==sellercompany)
				{
					delete sellers[company][i];
					sellers[company][i] = sellers[company][sellers[company].length-1];
					sellers[company].length--;
					break;
				}
			}
		}
		uint price = buyinglist[company][buyeraccept].offerPrice;
		buyinglist[company][buyeraccept].noOfShares-=nshares;
		if(buyinglist[company][buyeraccept].noOfShares==0)
		{
			buyersExist[company][buyeraccept] = false;
			for(i = 0;i< buyers[company].length;i++)
			{
				if(buyers[company][i]==buyeraccept)
				{
					delete buyers[company][i];
					buyers[company][i] = buyers[company][buyers[company].length-1];
					buyers[company].length--;
					break;
				}
			}
		}

 		Buyer b = Buyer(buyeraccept);
 		b.transfer(sellercompany,company,nshares,price);
 		Company c = Company(company);
 		c.sellStocks(b.getAddress(),sellercompany,nshares);
 			c.setOfferPrice(price);

	}
	
	// function changeOfferPrice (uint oPrice) external {
	// 	sellorder[msg.sender].offerPrice = oPrice;
	// 	sellorder[msg.sender].totalValue = oPrice*totalNumberOfShares;
	// }

	// function changeNoOfShares (uint nshares) external {
	// 	sellorder[msg.sender].noOfSharesToBeSold = nshares;
		
	// }

	// function  increaseTotalNoOfSharesByPrice(uint offerPrice) external{
	// 	sellorder[msg.sender].offerPrice = offerPrice;
	// 	sellorder[msg.sender].totalNumberOfShares = sellorder[msg.sender].totalValue/offerPrice;
	// }
	
	// function increaseTotalNoOfShares(uint tshares) external {
	// 	sellorder[msg.sender].totalNumberOfShares = tshares;
	// 	sellorder[msg.sender].offerPrice = sellorder[msg.sender].totalValue/ tshares;
	// }
	
	
	
	
}
