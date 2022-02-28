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
        (bool itWorked, ) = _externalAddr.call{value: msg.value}(_externalData);

        emit Result(itWorked, "Failed to execute");
    }

    /**
     * @dev Call multiple functions in another contract.
     * This is a view function and therefore uses staticcall.
     */
    function multiCallView(
        address[] calldata _targetFuncs,
        bytes[] calldata _targetData
    ) external view onlyOwner returns (bytes[] memory) {
        require(
            _targetFuncs.length == _targetData.length,
            "Array lengths aren't equal"
        );
        bytes[] memory findings = new bytes[](_targetData.length);
        for (uint256 i = 0; i <= _targetFuncs.length; i++) {
            (bool itWorked, bytes memory finding) = _targetFuncs[i].staticcall(
                _targetData[i]
            );
            require(itWorked, "MulticallView: failed");
            findings[i] = finding;
        }
        return findings;
    }

    /**
     * @dev Call multiple functions in another contract.
     * This is not a view function and therefore uses call (meaning you can write to the other contract).
     */
    function multiCall(
        address[] calldata _targetFuncs,
        bytes[] calldata _targetData
    ) external onlyOwner returns (bytes[] memory) {
        require(
            _targetFuncs.length == _targetData.length,
            "Array lengths aren't equal"
        );
        bytes[] memory findings = new bytes[](_targetData.length);
        for (uint256 i = 0; i <= _targetFuncs.length; i++) {
            (bool itWorked, bytes memory finding) = _targetFuncs[i].call(
                _targetData[i]
            );
            require(itWorked, "Multicall: failed");
            findings[i] = finding;
        }
        return findings;
    }
}
