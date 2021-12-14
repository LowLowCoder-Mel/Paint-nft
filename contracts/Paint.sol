// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./ERC721Base.sol";

contract Paint is ERC721Base, ReentrancyGuard {
    using Counters for Counters.Counter;

    Counters.Counter public idTracker;

    constructor(
        string memory name,
        string memory symbol,
        string memory baseTokenURI,
        string memory contractURI
    ) ERC721Base(name, symbol, baseTokenURI, contractURI) {
        idTracker.increment(); // the first id = #1
    }

    /* ========== OWNER METHODS ========== */

    function withdrawContractBalance(address _receiver) external nonReentrant onlyOwner {
        require(_receiver != address(0), "Invalid receiver");
        // access contract balance
        uint256 withdrawalAmount = address(this).balance;
        // transfer balance
        payable(_receiver).transfer(withdrawalAmount);
        // emit event
        emit ContractBalanceWithdrawn(_receiver, withdrawalAmount);
    }

    /* ========== USER METHODS ========== */

    function mint() external payable nonReentrant whenNotPaused onlyOwner {
        require(tx.origin == msg.sender, "Allowed for EOA only");
        _mint(msg.sender, idTracker.current());
        idTracker.increment();
    }

    /* ========== EVENTS ========== */
    
    event ContractBalanceWithdrawn(address indexed account, uint256 amount);
}
