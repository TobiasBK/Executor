// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6 <0.9.0;

/**
 * @dev A contract that allows the owner to call another contract using .call
 */
contract Executor {
    address private owner;

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
     * @dev Fallback function recevies any ether sent to this contract
     */
    fallback() external payable {}

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
    function executor(address _externalAddr, bytes memory _externalData)
        public
        payable
        onlyOwner
    {
        (bool success, ) = _externalAddr.call{value: msg.value}(_externalData);

        emit Result(success, "Failed to execute");
    }
}
