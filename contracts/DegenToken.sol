// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DegenToken is IERC20{
    string public TokenName;
    string public Symbol;
    address public Owner;
    mapping(address => uint256) private Balance;
    mapping(address => string[]) private PurchasedItems; 
    uint256 private  TotalSupply = 0;

    // It maps an owner's address to a mapping of spender addresses to the allowance amount granted by the owner to the spender.

    mapping(address => mapping(address => uint256)) private Allowance;

    event Burn(address from, uint256 value);
    event Mint(address to, uint256 value);

    constructor() {
        TokenName = "Degen";
        Symbol = "DGN";
        Owner = msg.sender;
    }

    function totalSupply() external view returns (uint256) {
        return TotalSupply;
    }

    function balanceOf(address account) public view returns (uint) {
        return Balance[account];
    }

    function transfer(address to, uint256 value) public returns (bool) {
        
        require(value>0,"Value must be greater than 0");
        require(value<=Balance[msg.sender],"Value must be greater than 0");

        Balance[msg.sender] -= value;
        Balance[to] += value;
        return true;
    }


    function burn(uint256 value) public returns(bool) {
        address sender = msg.sender;
        assert(value>0);
        require(value<=Balance[sender],"Insufficient Balance!!!!");
        Balance[sender] -= value;
        TotalSupply -= value;
        return true;
    }

    function mint(address to, uint256 value) public returns(bool) {
        require(msg.sender == Owner, "Only owner can mint tokens"); 
        assert(value>0);
        Balance[to] += value;
        TotalSupply += value;
        return true;
    }

    function getPurchases(address account) public view returns(string[] memory) {
        return PurchasedItems[account];
    }

    function redeem(string memory itemName, uint256 value) public{
        address sender = msg.sender;
        require(value<=Balance[sender],"Insufficient balance!!!");
        Balance[sender] -= value;
        PurchasedItems[sender].push(itemName);
    }


    function allowance(address owner, address spender) external view returns (uint256) {
        return Allowance[owner][spender];
    }

    function approve(address spender, uint value) external returns (bool) {
        address owner = msg.sender;
        uint OwnerBalance = Balance[owner];
        require(value<=OwnerBalance,"Insufficient Balance!!!!");
        Balance[owner] -= value;
        Allowance[owner][spender] += value;
        emit Approval(owner, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {

        require(value<=Balance[from],"Insufficient Balance!!!!");
        Balance[from] -= value;
        Balance[to] += value;
        return true;
    }



}
