// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6 <0.9.0;

import "ds-test/test.sol";

import "./Executor.sol";

contract Calle {
    uint256 count = 1;

    function counter(uint256 _num) public view returns (uint256) {
        uint256 newCount;
        return newCount = count + _num;
    }
}

contract NotOwner {
    Executor private executor;

    constructor(address _executor) {
        executor = Executor(payable(_executor));
    }

    function setOwner(address _owner) public {
        executor.setOwner(_owner);
    }
}

contract SendEth {
    Executor private executor;

    constructor(address _executor) {
        executor = Executor(payable(_executor));
    }

    function send() public {
        payable(address(executor)).transfer(1 ether);
    }
}

contract TestMultiCall {
    Executor private executor;

    constructor(address _executor) {
        executor = Executor(payable(_executor));
    }

    function testMultiCall(uint256 _num) external pure returns (uint256) {
        return _num;
    }

    function getData(uint256 _num) external pure returns (bytes memory) {
        return abi.encodeWithSelector(this.testMultiCall.selector, _num);
    }
}

contract ExecutorTest is DSTest {
    Executor private executor;
    NotOwner private notOwner;
    SendEth private sendEth;
    Calle private calle;
    TestMultiCall private testMultiCall;

    function setUp() public {
        executor = new Executor();
        notOwner = new NotOwner(address(notOwner));
        sendEth = new SendEth(address(sendEth));
        calle = new Calle();
        testMultiCall = new TestMultiCall(address(testMultiCall));
    }

    receive() external payable {}

    //UNIT TESTING
    function test_receive() public {
        assertEq((address(executor).balance), 0);
        payable(address(executor)).transfer(1 ether);
        assertEq(address(executor).balance, 1 ether);
    }

    function test_withdraw() public {
        payable(address(executor)).transfer(1 ether);
        uint256 preSendBalance = address(this).balance;
        executor.withdraw();
        uint256 postSendBalance = address(this).balance;
        assertEq(preSendBalance + 1 ether, postSendBalance);
    }

    function test_setOwner() public {
        executor.setOwner(address(0x1));
        assertEq(executor.owner(), address(0x1));
    }

    function testFail_setOwner() public {
        notOwner.setOwner(address(notOwner));
    }

    function test_executeFunction() public {
        executor.basicExecute(address(calle), "");
    }

    function test_testMultiCall() public {}
}
