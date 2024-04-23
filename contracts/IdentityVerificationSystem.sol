//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract IdentityVerificationSystem {
    address public admin;
    uint256 public userIdCounter;
    using Strings for uint256;

    struct UserInfo {
        bytes32 uniqueId;
        string email;
        bool isAuthorized;
        mapping(uint256 => Transaction) transactions;
        
    }

    struct Transaction {
        uint256 timestamp;
        string action;
    }

    mapping(address => UserInfo) public users;
    mapping(bytes32 => address) public userAddressesByUniqueId;

    event UserAuthorized(address indexed userAddress, bytes32 uniqueId);
    event TransactionAdded(address indexed userAddress, bytes32 uniqueId, uint256 timestamp, string action, string email);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyAuthorizedUser() {
        require(users[msg.sender].isAuthorized, "User is not authorized");
        _;
    }

    modifier onlyUserWithId(bytes32 _uniqueId) {
        require(userAddressesByUniqueId[_uniqueId] == msg.sender, "Unauthorized user ID");
        _;
    }

    constructor() {
        admin = msg.sender;
        userIdCounter = 1;
    }

    // Function to authorize user
    function authorizeUser(address _userAddress) external onlyAdmin {
        bytes32 uniqueId = generateRandomId(_userAddress);

        require(!users[_userAddress].isAuthorized, "User is already authorized");

        UserInfo storage newUser = users[_userAddress];
        newUser.uniqueId = uniqueId;
        newUser.isAuthorized = true;

        userAddressesByUniqueId[uniqueId] = _userAddress;

        emit UserAuthorized(_userAddress, uniqueId);
    }

    // Function to transact
    function transact(string memory _action, string memory _email, bytes32 _uniqueId) external onlyUserWithId(_uniqueId) onlyAuthorizedUser {
        UserInfo storage user = users[msg.sender];

        uint256 timestamp = block.timestamp;

        require(user.transactions[timestamp].timestamp == 0, "Transaction already performed at this timestamp");

        user.transactions[timestamp] = Transaction({
            timestamp: timestamp,
            action: _action
        });

        user.email = _email;

        emit TransactionAdded(msg.sender, _uniqueId, timestamp, _action, _email);
    }

    // Function to view user info (for admin)
    function viewInfo(address _userAddress) external view onlyAdmin returns (address, bool, uint256) {
        UserInfo storage user = users[_userAddress];
        return (_userAddress, user.isAuthorized, user.transactions[user.transactions[0].timestamp].timestamp);
    }

    // Function to get unique ID
    function getUniqueId() external view onlyAuthorizedUser returns (bytes32) {
        return users[msg.sender].uniqueId;
    }

    // Function to get user counter (for admin)
    function getUserCounter() external view onlyAdmin returns (uint256) {
        return userIdCounter;
    }

    // Function to generate random ID
    function generateRandomId(address _userAddress) internal returns (bytes32) {
        return keccak256(abi.encodePacked(_userAddress, userIdCounter++));
    }

    // Function to verify external credentials
    function verifyCredentials() external {
        // Implementation for verifying external credentials
    }

    // Function to update profile information
    function updateProfile(string memory _email) external onlyAuthorizedUser {
        UserInfo storage user = users[msg.sender];
        user.email = _email;
        // Update other profile information fields as needed
    }

    // Function to revoke user authorization
    function revokeAuthorization(address _userAddress) external onlyAdmin {
        users[_userAddress].isAuthorized = false;
        
    }
}
