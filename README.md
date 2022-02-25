# Executor

A smart contract that executes anything the owner sends it with .call()

This is a work in progress...

Uses [dapp.tools](dapp.tools) for development.

## Notes

- calldata non-modifiable; saves gas as an input

`function callSetN(address _e, uint _n) {
    _e.call(bytes4(sha3("setN(uint256)")), _n); // E's storage is set, D is not modified
}`

`function register(string _text) {
    watch_addr.call(bytes4(sha3("register(string)")), _text);
}`

## References

- https://ethereum.stackexchange.com/questions/8270/what-does-soliditys-call-function-mean
- https://ethereum.stackexchange.com/questions/2826/call-function-on-another-contract
- https://ethereum.stackexchange.com/questions/3667/difference-between-call-callcode-and-delegatecall
- https://www.zupzup.org/smart-contract-interaction/
- https://eip2535diamonds.substack.com/p/understanding-delegatecall-and-how?utm_source=url
- https://medium.com/@houzier.saurav/calling-functions-of-other-contracts-on-solidity-9c80eed05e0f