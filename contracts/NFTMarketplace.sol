//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


//internal import for nft openzipline
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFRMarketplace is ERC721URIStorage{
    using Counters for Counters.Counter;

    Counters.Counter private _rokenIds;
    Counters.Counter private _itmesSold;

    uint256 listingPrice= 0.0015 ether; 

    address payable owner;

    mapping(uint256 => MarketItem) private idMarketItem;

    struct MarketItem{
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    event idMarketItemCreated(
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

      modifier onlyOwner{
        require(msg.sender == owner, "only owner of the contract of the market  can change the listing price"
        );
        _;
      }

    constructor() ERC721("NFT Metaverse Token", "MYNFT"){
        owner == payable(msg.sender);
    }

    function updateListingPrice(uint256 _listingPrice)

     public 
     payable
     onlyOwner
     {
       listingPrice = _listingPrice;
      }

      function getListingPrice() public view returns (uint256){
        return listingPrice;

        //Let create "CREATE NFT TOKEN FUNCTION"

        function createToken(string memory tokenURI, uint256 price) public
        _tokenIds.increment();

        uint256 newTOkenId = tokenIds.current();

        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, tokenURI);


        createMarketItem(newTokenId, price);

        return newTokenId;
      }

      //CREATING MARKET ITEMS

      function createMarketItem(uint256 tokenId, uint256 price) private{
      require(price > 0, "Price must be atleast 1" );
      require(msg.value == listingPrice, "Price must be equal to listing price");
      

      idMarketItem[tokenId] = MarketItem(
        tokenId,
        payable(msg.sender),
        payable(address(this)),
        price,
        false,
      );

      _transfer(msg.sender, address(this ), tokenId);

      emit idMarketItemCreated(tokenId, msg.sender, address(this), price, false);

      }


      //function for resale token
      function reSellToken(uint256 tokenId, uint256 price) public payable{
        require(idMarketItem[tokenId].owner == msg.sender, "Only item owner can perform this purchase");

        require(msg.value == listingPrice, "Price must be equal to listing price");

        idMarketItem[tokenId].sold = false;
        idMarketItem[tokenId].price = price;
        idMarketItem[tokenId].seller = payable(msg.sender);
        idMarketItem[tokenId].owner = payable(address(this));


        _itemsSold.decrement();

        _transfer(msg.sender, address(this), tokenId);
      }


      //Function creeate market sell
      function createMarketSale(uint256 tokenId) public payable{
        uint256 price = idMarketItem[tokenId].price;

        require(msg.value == price, "Please submit the asking price in order to complete the purchase");

        idMarketitem[tokenId].owner = payable(msg.sender);
        idMarketItem[tokenId].sold = true;
        idMarketItem[tokenId].owner  = payable(address(0));


        _itemsSold.increment();

        _transfer(address(this), msg.sender, tokenId);

        payable(owner). transfer(listingPrice);
        payable(idMarketItem[tokenId].seller).transfer(msg.value);
      }

      //Getting unsold nft data
      function fetchMarketItem() public view returns(MarketItem[] memory){
        uint256 itemCount = _tokenIds.current();
        uint256 unSoldItemCount = _tokenIds.current(); - _itemsSold.current();
        uint256 currentIndex = 0;


        MarketItem[] memory items = new MarketItem[](unSoldItemCount);
        for (uint256 i = 0; i < itemCount; i++){
          if(idMarketItem[i + 1].owner == address(this)){
            uint256 currentId = i + 1;

            MarketItem storage currentItem = idMarketItem[currentId];
            items[currentIndex] = currentItem;
            currentIndex += 1;

          }
        }
        return items;
      }

      //Purchase Item
      function fetchMyNFT() public view returns(MarketItem[] memory){
        uint256 totalCount = _tokienIds.current();
        uint256 itemCount = 0;
        uint256 currentIndex = 0;

        for(uint256 i = 0; i < totalCount; i++){
          if(idMarketItem[i + 1].owner == msg.sender){
            itemCount += 1;
          }
        }
        MarketItem[]memory items = new MarketItem[](itemCount);
        for(uin256 i = 0; i < totalCount; i++){

          if(idMarketItem[i + 1].owner == msg.sender) {
          uint256 currntId = i + 1;
          MarketItem storage curentItem = idMarketItem[currntId];
          items[currentIndex] = currentItem;
          currentIndex += 1;
          }
        }

        return items;
      }

      // Single user item
 function fetchItemsListed() public view returns (MarketItem [] memory){
  uint256 totalCount = _tokedIds.current();
  uint256 itemCount = 0;
  uint256 currentIndex = 0;

  for(uint256 i = 0; i < totalCount; i ++){
    if(idMarketItem[i + 1].seller == msg.sender){
      itemCount += 1;
    }
  }

  MarketItem[] memory items = new MarketItem[](itemCount);
  for(uint256 i = 0; < totalCount; i++){
    id(idMarketItem[i + 1].seller == msg.sender){
      uint256 currentId = i + 1;

      MarketItem storage currentItem = idMarketItem[currentId];
      items[currentIndex] = currentItem;
      currentIndex += 1;
    }
  }
  return items;
 }


}