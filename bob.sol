//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

contract Bob {
    string private _name ;
    string private _symbol ;
    uint8 private _decimals = 18;
    uint256 private _totalSupply;
    uint256 private _maxSupply;
    address public owner;
    mapping (address=> uint)public _balances; //铸币余额映射
   mapping(address => mapping(address => uint256)) public allowance;
    event Approval(address indexed owner, address indexed to, uint256 value);
    

    //构造函数，初始化属性，将这个地址赋值给管理者
    constructor(string memory name,string memory symbol,uint256 maxSupply)public {
        _name=name;
        _symbol=symbol;
        _maxSupply=maxSupply;
        owner =msg.sender;
    }


    //修饰器，判断是不是管理者
    modifier onlyOwner{
        require(msg.sender==owner,"account is not owner");
        _;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }
    function maxSupply() public view returns (uint256) {
        return _maxSupply;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];}

    function name() public view returns (string memory) {
        return _name;}

    function symbol() public view returns (string memory) {
        return _symbol;}      
    
   
   function setOwner(address _owner) public onlyOwner {
       owner=_owner;
       //设置管理者账户
   }
   function mint(address to, uint256 amount) public onlyOwner {
        require(totalSupply() + amount <= _maxSupply, "Over maxSupply");
        _totalSupply +=amount;
        _balances[to] += amount
        
    }
     //代币授权,被授权方可以支配授权方的amount数量的代币。
    function approve(address to, uint amount) public returns (bool) {
        allowance[msg.sender][to] = amount;
        emit Approval(msg.sender, to, amount);
        return true;
    }
    //实现转账功能，调用方扣除amount数量代币，接收方增加相应代币。
    function transfer(address to,uint256 amount) public returns (bool){
        address from =msg.sender;
        uint256 fromBalance=_balances[from];
        require(fromBalance>= amount,"Over user balance");

        _balances[from]-=amount;
        _balances[to] += amount;

        return true;
    }

}
