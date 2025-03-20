// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedEcommerce {
    struct Product {
        uint256 id;
        address seller;
        string name;
        uint256 price;
        bool isAvailable;
    }

    mapping(uint256 => Product) public products;
    uint256 public nextProductId;
    
    event ProductListed(uint256 id, address seller, string name, uint256 price);
    event ProductPurchased(uint256 id, address buyer, uint256 price);

    function listProduct(string memory name, uint256 price) public {
        products[nextProductId] = Product(nextProductId, msg.sender, name, price, true);
        emit ProductListed(nextProductId, msg.sender, name, price);
        nextProductId++;
    }

    function buyProduct(uint256 productId) public payable {
        require(products[productId].isAvailable, "Product not available");
        require(msg.value == products[productId].price, "Incorrect payment amount");

        address payable seller = payable(products[productId].seller);
        seller.transfer(msg.value);
        products[productId].isAvailable = false;

        emit ProductPurchased(productId, msg.sender, msg.value);
    }
}
