pragma solidity ^0.8.0;

interface ERC1155 {
    function balanceOf(address owner, uint256 id) external view returns (uint256);
    function approve(address spender, uint256 id, uint256 value) external;
    function transferFrom(address from, address to, uint256 id, uint256 value) external;
    function transfer(address to, uint256 id, uint256 value) external;
    function ownerOf(uint256 id) external view returns (address);
    function takeOwnership(uint256 id) external;
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

contract ERC1155Mintable is ERC1155 {
    mapping (address => mapping (uint256 => uint256)) private _balances;
    mapping (uint256 => address) private _owners;

    constructor() public {
        _owners[0] = address(this);
    }

    function balanceOf(address owner, uint256 id) public view returns (uint256) {
        return _balances[owner][id];
    }

    function approve(address spender, uint256 id, uint256 value) public {
        require(_owners[id] == address(this), "Token must be minted by the contract");
        _balances[spender][id] = value;
    }

    function transferFrom(address from, address to, uint256 id, uint256 value) public {
        require(_balances[from][id] >= value, "Not enough balance");
        _balances[from][id] -= value;
        _balances[to][id] += value;
    }

    function transfer(address to, uint256 id, uint256 value) public {
        transferFrom(address(this), to, id, value);
    }

    function ownerOf(uint256 id) public view returns (address) {
        return _owners[id];
    }

    function takeOwnership(uint256 id) public {
        require(_owners[id] == address(this), "Token must be minted by the contract");
        _owners[id] = msg.sender;
    }

    function supportsInterface(bytes4 interfaceId) public view returns (bool) {
        return interfaceId == ERC1155.interfaceId || interfaceId == ERC1155Mintable.interfaceId;
    }

    function mintFungible(uint256 id, uint256 value) public {
        require(_owners[id] == address(0), "Token with id already exists");
        _owners[id] = address(this);
        _balances[address(this)][id] = value;
    }

    function mintNonFungible(uint256 id) public {
        require(_owners[id] == address(0), "Token with id already exists");
        _owners[id] = msg.sender;
    }
}
