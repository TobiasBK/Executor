// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6 <0.9.0;

// Am “executor” smart contract that just .calls() anything the owner sends it.
// Ueses calldata

//https://ethereum.stackexchange.com/questions/8270/what-does-soliditys-call-function-mean
//https://ethereum.stackexchange.com/questions/2826/call-function-on-another-contract
//https://ethereum.stackexchange.com/questions/3667/difference-between-call-callcode-and-delegatecall

// https://www.zupzup.org/smart-contract-interaction/

//https://eip2535diamonds.substack.com/p/understanding-delegatecall-and-how?utm_source=url

//https://medium.com/@houzier.saurav/calling-functions-of-other-contracts-on-solidity-9c80eed05e0f

//calldata non modifiable, saves gas as an input

//  function callSetN(address _e, uint _n) {
//     _e.call(bytes4(sha3("setN(uint256)")), _n); // E's storage is set, D is not modified
//   }

// function register(string _text) {
//     watch_addr.call(bytes4(sha3("register(string)")), _text);
// }

contract Callee {
    uint256 count;

    function counter(uint256 _num) public view returns (uint256) {
        uint256 newCount = count + _num;
        return newCount;
    }
}

contract Executor {
    address private owner;

    event Result(bool success, bytes data);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    /**
     * @dev Solidity's .call() is a low-level function for interacting with other smart contracts.
     * This is a great way to interface with smart contracts without the need for an ABI.
     */

    function executor(address _externalAddr) public payable onlyOwner {
        address addr = _externalAddr;
        (bool success, bytes memory data) = addr.call{
            value: msg.value,
            gas: 8000
        }(abi.encodeWithSignature("counter(uint256)", 7));

        emit Result(success, data);
    }
}
