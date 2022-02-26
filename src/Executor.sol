// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6 <0.9.0;

/**
 * @dev A contract that allows the owner to call another contract using .call
 */
contract Executor {
    address public owner;

    event Deposit(address indexed sender, uint256 value);
    event Result(bool success, bytes data);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    /**
     * @dev Sets creator address of the contract as owner on setup
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev A type of fallback function to recieve ether when it is sent with NO calldata.
     * Also useful for testing, executes on .send() or .transfer().
     */
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    /**
     * @dev Allows owner to set a new owner address
     */
    function setOwner(address _owner) external onlyOwner {
        owner = _owner;
    }

    /**
     * @dev Allows owner to withdraw all ether
     */
    function withdraw() external onlyOwner {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }

    /**
     * @dev Solidity's .call is a low-level function for interacting with other smart contracts
     * This is a great way to interface with smart contracts without the need for an ABI
     */
    function executeFunction(address _externalAddr, bytes memory _externalData)
        public
        payable
        onlyOwner
    {
        (bool success, ) = _externalAddr.call{value: msg.value}(_externalData);

        emit Result(success, "Failed to execute");
    }
}
