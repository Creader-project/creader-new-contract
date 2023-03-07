interface IERC5585 {

    struct UserRecord {
        address user;
        string[] rights;
        uint expires
    }

    /// @notice Get all available rights of this NFT project
    /// @return All the rights that can be authorized to the user
    function getRights() external view returns(string[]);

    /// @notice NFT holder authorizes all the rights of the NFT to a user for a specified period of time
    /// @dev The zero address indicates there is no user
    /// @param tokenId The NFT which is authorized
    /// @param user The user to whom the NFT is authorized
    /// @param duration The period of time the authorization lasts
    function authorizeUser(uint256 tokenId, address user, uint duration) external;

    /// @notice NFT holder authorizes specific rights to a user for a specified period of time
    /// @dev The zero address indicates there is no user. It will throw exception when the rights are not defined by this NFT project
    /// @param tokenId The NFT which is authorized
    /// @param user The user to whom the NFT is authorized
    /// @param rights Rights autorised to the user, such as renting, distribution or display etc
    /// @param duration The period of time the authorization lasts
    function authorizeUser(uint256 tokenId, address user, string[] rights, uint duration) external;

    /// @notice NFT holder extends the duration of authorization
    /// @dev The zero address indicates there is no user. It will throw exception when the rights are not defined by this NFT project
    /// @param tokenId The NFT which has been authorized
    /// @param user The user to whom the NFT has been authorized
    /// @param duration The new duration of the authorization
    function extendDuration(uint256 tokenId, address user, uint duration) external;

    /// @notice NFT holder updates the rights of authorization
    /// @dev The zero address indicates there is no user
    /// @param tokenId The NFT which has been authorized
    /// @param user The user to whom the NFT has been authorized
    /// @param rights New rights autorised to the user
    function updateUserRights(uint256 tokenId, address user, string[] rights) external;

    /// @notice Get the authorization expired time of the specified NFT and user
    /// @dev The zero address indicates there is no user
    /// @param tokenId The NFT to get the user expires for
    /// @param user The user who has been authorized
    /// @return The authorization expired time
    function getExpires(uint256 tokenId, address user) external view returns(uint);

    /// @notice Get the rights of the specified NFT and user
    /// @dev The zero address indicates there is no user
    /// @param tokenId The NFT to get the rights
    /// @param user The user who has been authorized
    /// @return The rights has been authorized
    function getUserRights(uint256 tokenId, address user) external view returns(string[]);

    /// @notice The contract owner can update the number of users that can be authorized per NFT
    /// @param userLimit The number of users set by operators only
    function updateUserLimit(unit256 userLimit) external onlyOwner;

    /// @notice resetAllowed flag can be updated by contract owner to control whether the authorization can be revoked or not 
    /// @param resetAllowed It is the boolean flag
    function updateResetAllowed(bool resetAllowed) external onlyOwner;

    /// @notice Check if the token is available for authorization
    /// @dev Throws if tokenId is not a valid NFT
    /// @param tokenId The NFT to be checked the availability
    /// @return true or false whether the NFT is available for authorization or not
    function checkAuthorizationAvailability(uint256 tokenId) public view returns(bool);

    /// @notice Clear authorization of a specified user
    /// @dev The zero address indicates there is no user. The function  works when resetAllowed is true and it will throw exception when false  
    /// @param tokenId The NFT on which the authorization based
    /// @param user The user whose authorization will be cleared
    function resetUser(uint256 tokenId, address user) external;

    /// @notice This is an OPTIONAL function that the operator MAY call, he can set the starting time of staking as a reward of the authorization for each user 
    /// @dev The zero address indicates there is no user
    /// @param user To which user the staking time will be set
    /// @param stakingTime The starting time of the staking for each user
    function updateStakingTime(address[] user, uint[] stakingTime) external;


    /// @notice Emitted when the user of a NFT is changed or the authorization expires time is updated
    /// param tokenId The NFT on which the authorization based
    /// param indexed user The user to whom the NFT authorized
    /// @param rights Rights autorised to the user
    /// param expires The expires time of the authorization
    event authorizeUser(uint256 indexed tokenId, address indexed user, string[] rights, uint expires);
}