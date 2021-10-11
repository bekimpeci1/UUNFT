// SPDX-License-Identifier:UNLICENSED 

//NOTES
/*
    Token should have a name
    At createToken the !=0 should be ==
 */

pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract UUNFT is ERC721("UpgradableNFT","UUNFT") { // also implement Ownalbe 

    address public manager;
    enum TokenType {Fire,Water}
    enum TokenLevel {LevelZero,LevelOne, LevelTwo, LevelThree}
    enum TokenVault {NoVault,TokenVaultOne, TokenVaultTwo} // Default NoVault
    uint8 tokenId = 1; 
    mapping(uint8 => TokenMetaData) public tokens;
    mapping(address => TokenVault) public lockedVaultTokens;
    mapping(address => uint8[4]) public tokenOwners;
    //add events
    constructor () payable{
        manager = msg.sender;
    }
 

   


    event GenericEvent(address,TokenLevel,TokenLevel,TokenType,TokenType,TokenVault);
    
    struct TokenMetaData {
        uint id;
        uint timestamp;
        address owner;
        TokenLevel tokenLevel;
        TokenType tokenType;
    }

    function getTokenData(uint _tokenId) public view returns (TokenMetaData memory) {
        return tokens[_tokenId];
    }
    
    function getTokensOfAnOwner(address _owner) public view returns(uint[4] memory) {
        return tokenOwners[_owner];
    }
    
    
    function CreateToken(TokenType _tokenType) public  payable{//alsow user need to pay ETH in order to create a token
        require(msg.value >= calculateEtherToSend(1),'You need to send more ETH');
        require(tokenOwners[msg.sender][uint(_tokenType)] == 0,'You cant overwrite your token'); 
        tokens[tokenId].id = tokenId;
        tokens[tokenId].timestamp = block.timestamp;
        tokens[tokenId].tokenType = _tokenType;
        tokens[tokenId].owner = msg.sender;
        tokenOwners[msg.sender][uint(_tokenType)] = tokenId; 
        
        emit GenericEvent(msg.sender,tokens[tokenOwners[msg.sender][0]].tokenLevel,tokens[tokenOwners[msg.sender][1]].tokenLevel,tokens[tokenOwners[msg.sender][0]].tokenType,tokens[tokenOwners[msg.sender][1]].tokenType,lockedVaultTokens[msg.sender]);
        tokenId++;
    }
    function upgradeToken(uint _tokenToBeUpgradedId) public payable{
        
       require(msg.value >= calculateEtherToSend(10),'You need to send 10% of contract balance');
        tokens[_tokenToBeUpgradedId].tokenLevel =TokenLevel(uint(tokens[_tokenToBeUpgradedId].tokenLevel) + 1);
        emit GenericEvent(msg.sender,tokens[tokenOwners[msg.sender][0]].tokenLevel,tokens[tokenOwners[msg.sender][1]].tokenLevel,tokens[tokenOwners[msg.sender][0]].tokenType,tokens[tokenOwners[msg.sender][1]].tokenType,lockedVaultTokens[msg.sender]);
        
        
    }
    function removeTokenById(uint _tokenToBeBurnedId) public{
        for(uint i = 0; i < tokenOwners[msg.sender].length; i++) {
            if(tokenOwners[msg.sender][i] == _tokenToBeBurnedId) {
                tokenOwners[msg.sender][i] = tokenOwners[msg.sender][tokenOwners[msg.sender].length-1];
                tokenOwners[msg.sender][tokenOwners[msg.sender].length-1] = 0;
                emit GenericEvent(msg.sender,tokens[tokenOwners[msg.sender][0]].tokenLevel,tokens[tokenOwners[msg.sender][1]].tokenLevel,tokens[tokenOwners[msg.sender][0]].tokenType,tokens[tokenOwners[msg.sender][1]].tokenType,lockedVaultTokens[msg.sender]);
                break;
            }
        }
    }
    
    function balance() public view returns(uint){
        return address(this).balance;
    }
    function getVault(address o) public view returns(TokenVault) {
        return lockedVaultTokens[o];
    }

    function calculateEtherToSend(uint percentage) internal view returns(uint minAmountToSend) {
        minAmountToSend = (address(this).balance/100)*percentage; //the minimum amount is 1% of the contract balance
    }
    function mutateToken(uint _tokenToBeUpgradedId,TokenType _designatedType) public payable{
        require(tokenOwners[msg.sender][uint(_designatedType)] == 0,'You can only have one kind of token type');
        require(msg.value >= calculateEtherToSend(15),'You need to send 15% of contract balance');
        tokens[_tokenToBeUpgradedId].tokenType = _designatedType;
        emit GenericEvent(msg.sender,tokens[tokenOwners[msg.sender][0]].tokenLevel,tokens[tokenOwners[msg.sender][1]].tokenLevel,tokens[tokenOwners[msg.sender][0]].tokenType,tokens[tokenOwners[msg.sender][1]].tokenType,lockedVaultTokens[msg.sender]);
        
    }

     function giveWinnerProfit(address _winner) public payable {
         require(msg.sender == manager,'Only the manager can awake this functionality');
         payable(_winner).transfer(calculateEtherToSend(10));
         
     }

     fallback() external payable{}
     receive() external payable{}

    
       function Disasamble(uint _tokenToBeDisasabledId) public {
           require(msg.sender == tokens[_tokenToBeDisasabledId].owner,'Only the owner can burn a token');
           removeTokenById(_tokenToBeDisasabledId);
           _burn(_tokenToBeDisasabledId);
           payable(msg.sender).transfer(calculateEtherToSend(5));
           emit GenericEvent(msg.sender,tokens[tokenOwners[msg.sender][0]].tokenLevel,tokens[tokenOwners[msg.sender][1]].tokenLevel,tokens[tokenOwners[msg.sender][0]].tokenType,tokens[tokenOwners[msg.sender][1]].tokenType,lockedVaultTokens[msg.sender]);
        
       }

        function downgrade(uint _tokenToBeDownGraded) public payable{
            require(msg.sender == tokens[_tokenToBeDownGraded].owner,'Only the owner can downgrade the token');
            require(tokens[_tokenToBeDownGraded].tokenLevel != TokenLevel.LevelZero,'The token cant be downgraded anymore');
            tokens[_tokenToBeDownGraded].tokenLevel = TokenLevel(uint(tokens[_tokenToBeDownGraded].tokenLevel) - 1);
            payable(msg.sender).transfer(calculateEtherToSend(5));
           emit GenericEvent(msg.sender,tokens[tokenOwners[msg.sender][0]].tokenLevel,tokens[tokenOwners[msg.sender][1]].tokenLevel,tokens[tokenOwners[msg.sender][0]].tokenType,tokens[tokenOwners[msg.sender][1]].tokenType,lockedVaultTokens[msg.sender]);
        
        }

        function updateToMax(uint _tokenToBeUpdatedId) public payable{
            require(msg.value >= calculateEtherToSend(20),'You need to pay 20% of the contract balance');
            tokens[_tokenToBeUpdatedId].tokenLevel = TokenLevel.LevelThree;
            emit GenericEvent(msg.sender,tokens[tokenOwners[msg.sender][0]].tokenLevel,tokens[tokenOwners[msg.sender][1]].tokenLevel,tokens[tokenOwners[msg.sender][0]].tokenType,tokens[tokenOwners[msg.sender][1]].tokenType,lockedVaultTokens[msg.sender]);
        
        }


        function Stake(TokenVault _tokenVault) public {
            require(lockedVaultTokens[msg.sender] == TokenVault.NoVault,'You can only stake your tokens in 1 valut at a time');
            lockedVaultTokens[msg.sender] = _tokenVault;
            emit GenericEvent(msg.sender,tokens[tokenOwners[msg.sender][0]].tokenLevel,tokens[tokenOwners[msg.sender][1]].tokenLevel,tokens[tokenOwners[msg.sender][0]].tokenType,tokens[tokenOwners[msg.sender][1]].tokenType,lockedVaultTokens[msg.sender]);
        
        }

        function unStake(TokenVault _currentTokenVault) public {
            require(lockedVaultTokens[msg.sender] != TokenVault.NoVault,'You dont have staked tokens');
            require(lockedVaultTokens[msg.sender] == _currentTokenVault,'You cant unstake from a different token vault, please go back to the currect vault');
            lockedVaultTokens[msg.sender] = TokenVault.NoVault;
            emit GenericEvent(msg.sender,tokens[tokenOwners[msg.sender][0]].tokenLevel,tokens[tokenOwners[msg.sender][1]].tokenLevel,tokens[tokenOwners[msg.sender][0]].tokenType,tokens[tokenOwners[msg.sender][1]].tokenType,lockedVaultTokens[msg.sender]);
        
        }
        
      
}