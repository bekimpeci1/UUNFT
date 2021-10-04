// SPDX-License-Identifier:UNLICENSED 

pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract UUNFT is ERC721("UpgradableNFT","UUNFT") { // also implement Ownalbe 

    address public manager;
    enum TokenType {Fire,Water}
    enum TokenLevel {LevelZero,LevelOne, LevelTwo, LevelThree}
    enum TokenVault {NoVault,TokenVaultOne, TokenVaultTwo} // Default NoVault
    uint64 tokenId = 1; 
    event isUpgradable(string message);
    event isMutabale(string message);
    event hasUpgraded(string message);
    //add events
    constructor () {
        manager = msg.sender;
    }
    uint[4][4][] someArraYName;

    function getMaxLevelOfATokenType(TokenType _tokenType) public view{
        uint toptokenLevel  = 0;
        for(uint i = 4; i > 0; i--) {
            if(someArraYName[uint(_tokenType)][i].length > 0) {
                toptokenLevel = i;
                break;
            }
        }
    }
   

    mapping(uint => TokenMetaData) public tokens;
    mapping(address => uint[4]) public tokenOwners;
    mapping(address => TokenVault) public lockedVaultTokens;
    //If lockedVaultTokens[msg.sender] == NoVault
    //lockedVaultTokens[msg.sender] == _tokenVault;
    //We can only unlock tokens from the current vault, not from other valult;
    //require lockedVaultTokens[msg.sender] == theVaultTheUserIsCurrenctlyUsing, 'Tokens are loced in valut ' + TokenVault(lockedVaultTokens[msg.sender]);

    //tokenId should be 64 bit
    /*
        function findMaxLevelYtpe (TokenType tokenType) return address{
            enumaret etrhough the values in  amapping
            uint initalLevel = TokenLevel.LevelZero;
            for(uint i = 0; i < mapping.length; i+=) {
                if(mapping[].)
            }
        }
    */
    //A function to give the possibily of showing a leaderboard/ the height level of a tkoenType

    
    struct TokenMetaData {
        uint id;
        uint timestamp;
        address owner;
        TokenLevel tokenLevel;
        TokenType tokenType;
        //TokenVault tokenVault;
    }

    //function getTokenData
    function getTokenData(uint _tokenId) public view returns (TokenMetaData memory) {
        return tokens[_tokenId];
    }
    //function getTokensOfAnOwner returns uint[]
    function getTokensOfAnOwner(address _owner) public view returns(uint[4] memory) {
        return tokenOwners[_owner];
    }


    //IMPORTANT NOTES
    //Can only have a handluf of tokens, what number do you suggest?
    //User can only have 1 token type (token type should be unique)
    //User can only have  4 tokens
    //An address can only lock his/her tokens in only one vault
    //And it should be all or nothing locked

    ////10 eth, 10%, 1 0,9 .... When a user wins a game we need to give him some ETH
    //I suggested that we dont make it hardcode, like always 1 ETH
    //but E.g. if there is like 10 ETH in a pool, than the winner takes 10% of it,
    //so in the begining its first 10 ETH, the winner takes 1 ETH, than 9 are left, the
    //winner takes 0.9 eth etc etc...
    function CreateToken(TokenType _tokenType) public{//alsow user need to pay ETH in order to create a token
        require(tokenOwners[msg.sender][uint(_tokenType)] != 0,'You cant overwrite your token'); 
        tokens[tokenId].id = tokenId;
        tokens[tokenId].timestamp = block.timestamp;
        tokens[tokenId].tokenType = _tokenType;
        tokenOwners[msg.sender][uint(_tokenType)] = tokenId; 
        tokenId++;
    }
    function upgradeToken(uint _tokenToBeUpgradedId, uint _tokenToBeSacrificedId) public{
        require(tokens[_tokenToBeUpgradedId].owner == msg.sender && tokens[_tokenToBeSacrificedId].owner == msg.sender,'You are not the owner of these tokens');
        require(tokens[_tokenToBeUpgradedId].tokenLevel == tokens[_tokenToBeSacrificedId].tokenLevel);
        //this isnt anymore necessery since all tokenes should be in the same vault
        //a user cant have 1 token in vault 1 and the other in vault 2
        // require(tokens[_tokenToBeUpgradedId].tokenVault == tokens[_tokenToBeSacrificedId].tokenVault); 
        removeTokenById(_tokenToBeSacrificedId);
        tokens[_tokenToBeUpgradedId].tokenLevel =TokenLevel(uint(tokens[_tokenToBeUpgradedId].tokenLevel) + 1);
        
    }
    function removeTokenById(uint _tokenToBeBurnedId) public{
        for(uint i = 0; i < tokenOwners[msg.sender].length; i++) {
            if(tokenOwners[msg.sender][i] == _tokenToBeBurnedId) {
                tokenOwners[msg.sender][i] = tokenOwners[msg.sender][tokenOwners[msg.sender].length-1];
                tokenOwners[msg.sender][tokenOwners[msg.sender].length-1] == 0;
                break;
            }
        }
    }

    function mutateToken(uint _tokenToBeUpgradedId, uint _tokenToBeSacrificedId,TokenType _designatedType) public {
        require(tokens[_tokenToBeUpgradedId].owner == msg.sender && tokens[_tokenToBeSacrificedId].owner ==msg.sender, 'You do not own these 2 tokens');
        // require(tokens[_tokenToBeUpgradedId].tokenVault == tokens[_tokenToBeSacrificedId].tokenVault); See line 88
        require(TokenLevel(uint(tokens[_tokenToBeUpgradedId].tokenLevel))==TokenLevel(uint(tokens[_tokenToBeSacrificedId].tokenLevel) -1));
        require(tokenOwners[msg.sender][uint(_designatedType)] != 0,'You can only have one kind of token type');
        removeTokenById(_tokenToBeSacrificedId);
        tokens[_tokenToBeUpgradedId].tokenType = _designatedType;
    }

        //This should be changed to a modifier and have the requremen statemnt from upgrade token
//    function isUpgradable(uint _tokenId) public view {
//        //Check if they are in the same vault and the same level
//        require(tokens[_tokenId].owner == msg.sender);
//        //just like the code in the modifier(at least the logic of it)
//        for(uint i =0; i < tokenOwners[msg.sender].length-1;i++) {
//            if(tokenOwners[msg.sender][i].tokenLevel == tokens[_tokenId].tokenData[_tokenId]tokenLevel && tokenOwners[msg.sender][i].tokenData[])
//        }
      
//        if(tokens[_tokenId].tokenData[_tokenId].tokenLevel == tokens[_tokenId].tokenData[_tokenId].tokenLevel && tokens[_tokenId].tokenData[_tokenId].tokenVault == tokens[_tokenId].tokenData[_tokenId].tokenVault) {
//            emit isUpgradable("It is upgradable");
//        } else {
//            emit isUpgradable("It is not upgradable")
//        }
//    }

     //This should be changed to a modifier and have the requremen statemnt from mutate token
//    function isMutable(uint _tokenId) view public{
//        //Check if they are in the same vault and that there is at least 1 token that is below 1 level
//         require(tokens[_tokenId].owner == msg.sender);
//         if(tokens[_tokenId].tokenData[_tokenToBeUpgradedId].tokenVault == tokens[_tokenToBeSacrificedId].tokenData[_tokenToBeSacrificedId].tokenVault && TokenLevel(uint(tokens[_tokenToBeUpgradedId].tokenData[_tokenToBeUpgradedId].tokenLevel)) == TokenLevel(uint(tokens[_tokenToBeSacrificedId].tokenData[_tokenToBeSacrificedId].tokenLevel) -1))
//        //just like the code in the modifier(at least the logic of it)
//    }
       function Disasamble(uint _tokenToBeDisasabledId) public {
           require(msg.sender == tokens[_tokenToBeDisasabledId].owner,'Only the owner can burn a token');
           removeTokenById(_tokenToBeDisasabledId);
           //Here we also need to decide how many ether we need to send to the owner that is burning their token
           //Also we decided to use ETH, that removes the need to create our own erc-20 token
       }
//     function Disasamble(uint _tokenToBeDisasabledId)  public{
//         // require(tokens[_tokenToBeDisasabledId].owner == msg.sender);
//         //this function needs for an erc 20 token to be impplemented first, since the one who is burning it
//         //needs to pay a fee, but I believe the logic is gonna be a little like this
//         //Get Moeny
//         //Give the token default values and then isCreated become false, so later when we need to check
//         //if token exiists its gonna return false
//     }

//function downgrade  we recieve eth, level goes down by 1 if not 0
        function downgrade(uint _tokenToBeDownGraded) public {
            require(msg.sender == tokens[_tokenToBeDownGraded].owner,'Only the owner can downgrade the token');
            require(tokens[_tokenToBeDownGraded].tokenLevel != TokenLevel.LevelZero,'The token cant be downgraded anymore');
            tokens[_tokenToBeDownGraded].tokenLevel = TokenLevel(uint(tokens[_tokenToBeDownGraded].tokenLevel) - 1);
            //send some ETH (We need to create a method to calculate how much ether so sent, if you have any idea feel free to share)
        }

        function updateToMax(uint _tokenToBeUpdatedId) public payable{
            //pay some amount of ether (value cant be set as hardcode, i think it should be calc. using a function)
            //require(msg.value == etherSend,'You need to pay x ETH in order to update to max');
            tokens[_tokenToBeUpdatedId].tokenLevel = TokenLevel.LevelThree; //(need to check if there is a way that gets the last value in a enum, and not
            //just hardcode it)
        }


        function Stake(TokenVault _tokenVault) public {
            require(lockedVaultTokens[msg.sender] == _tokenVault,'You can only stake your tokens in 1 valut at a time');
            lockedVaultTokens[msg.sender] = _tokenVault;
        }

        function unStake(TokenVault _currentTokenVault) public {
            require(lockedVaultTokens[msg.sender] != TokenVault.NoVault,'You dont have staked tokens');
            require(lockedVaultTokens[msg.sender] == _currentTokenVault,'You cant unstake from a different token vault, please go back to the currect vault');
            lockedVaultTokens[msg.sender] = TokenVault.NoVault;
        }

        function checkIfTokensAreStaked() public view returns(bool){
            return lockedVaultTokens[msg.sender] == TokenVault.NoVault ? true: false;
        }
}