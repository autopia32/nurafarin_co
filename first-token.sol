pragma solidity >=0.7.0 <0.9.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address tokenOwner) external view returns (uint256);
    function allowance(address owner, address delegate) external view returns (uint256);

    function transfer(address reciever, uint256 numTokens) external returns (bool);
    function approve(address delegate, uint256 numTokens) external returns (bool);
    function transferFrom(address owner, address buyer, uint256 numTokens) external returns (bool);

    event Transfer(address from,address to, uint256 value);
    event Approval(address owner,address spender, uint256 value);
}

contract FirstToken is IERC20 {

    string name;
    string symbol;
    uint8 decimal;
    uint256 totalSupply_ = 100000;
    address owner;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    constructor() {
        name = "nura";
        symbol = "nra";
        decimal = 3;
//        totalSupply_ = 1000000;
        balances[msg.sender] = totalSupply_;
        owner = msg.sender;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function mint(uint256 minting, address reciever) public {
        require(owner == msg.sender);
        balances[reciever] += minting;
        totalSupply_ += minting;
    }

    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function transfer(address reciever,uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - numTokens;
        balances[reciever] = balances[reciever] + numTokens;
        emit Transfer(msg.sender, reciever, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint256) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns(bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner] - numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender] - numTokens;
        balances[buyer] = balances[buyer] + numTokens;

        return true;
    }


}