pragma solidity 0.8.0;
import "./UniversalUpgradableNFT";

contract UpgradeToken {
    UniversalUpgradableNFT NFT;

    constructor(address UniversalUpgradableNFTAddress) {
        NFT = UniversalUpgradableNFTAddress(UniversalUpgradableNFTAddress);
    }
      function updateToMax(uint _tokenToBeUpdatedId) public payable{
            require(msg.value >= calculateEtherToSend(20),'You need to pay 20% of the contract balance');
            NFT.tokens[_tokenToBeUpdatedId].tokenLevel = NFT.TokenLevel.LevelThree;        
        }
          function downgrade(uint _tokenToBeDownGraded) public payable{
            require(msg.sender == tokens[_tokenToBeDownGraded].owner,'Only the owner can downgrade the token');
            require(tokens[_tokenToBeDownGraded].tokenLevel != TokenLevel.LevelZero,'The token cant be downgraded anymore');
            NFT.tokens[_tokenToBeDownGraded].tokenLevel = TokenLevel(uint(NFT.tokens[_tokenToBeDownGraded].tokenLevel) - 1);
            payable(msg.sender).transfer(NFT.calculateEtherToSend(5));
        
        }
         function upgradeToken(uint _tokenToBeUpgradedId) public payable{
        
       require(msg.value >= calculateEtherToSend(10),'You need to send 10% of contract balance');
        tokens[_tokenToBeUpgradedId].tokenLevel =TokenLevel(uint(tokens[_tokenToBeUpgradedId].tokenLevel) + 1);
        
        
    }
     function mutateToken(uint _tokenToBeUpgradedId,TokenType _designatedType) public payable{
        require(tokenOwners[msg.sender][uint(_designatedType)] == 0,'You can only have one kind of token type');
        require(msg.value >= calculateEtherToSend(15),'You need to send 15% of contract balance');
        tokens[_tokenToBeUpgradedId].tokenType = _designatedType;
        emit GenericEvent(msg.sender,tokens[tokenOwners[msg.sender][0]].tokenLevel,tokens[tokenOwners[msg.sender][1]].tokenLevel,tokens[tokenOwners[msg.sender][0]].tokenType,tokens[tokenOwners[msg.sender][1]].tokenType,lockedVaultTokens[msg.sender]);
        
    }   
}
