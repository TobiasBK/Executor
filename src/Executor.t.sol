// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6 <0.9.0;

import "ds-test/test.sol";

import "./Executor.sol";

// contract Callee {
//     uint256 count;

//     function counter(uint256 _num) public view returns (uint256) {
//         uint256 newCount = count + _num;
//         return newCount;
//     }
// }

contract ExecutorTest is DSTest {
    Executor private executor;

    function setUp() public {
        executor = new Executor();
    }

    function test_executor() public {}

    function testFail_executor() public {}
}
