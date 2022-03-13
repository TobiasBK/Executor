# Executor

A smart contract that executes anything the owner sends it with `.call`.

[dapp.tools](dapp.tools) used for development.

## On `.call`

Solidity uses `.call` as a low-level function to interface with other contracts. It returns `true` normally (if it compiles), and will return `false` if it encounters an exception.

Another way to interact with other contracts is to use this style:
`contractAddressToCall.functionToCall(parameters)`. But this only works if you have all the information at deployment time.

With less information available at the time of deployment, use the `.call` method. To call functions in other contracts or send payment to payable functions, the recommended style is:

`(bool success, bool returnBytes) = addr.call{...}(abi.encodeWithSignature(...), ...)`

## On calldata

In Solidity:

- memory - lifetime is limited to a function call
- storage - the location where the state variables are stored
- calldata - special data location that contains the function arguments, only available for external function call parameters. Calldata is non-modifiable; saves gas as an input.

## References

- https://ethereum.stackexchange.com/questions/8270/what-does-soliditys-call-function-mean
- https://ethereum.stackexchange.com/questions/2826/call-function-on-another-contract
- https://ethereum.stackexchange.com/questions/3667/difference-between-call-callcode-and-delegatecall
- https://www.zupzup.org/smart-contract-interaction/
- https://eip2535diamonds.substack.com/p/understanding-delegatecall-and-how?utm_source=url
- https://medium.com/@houzier.saurav/calling-functions-of-other-contracts-on-solidity-9c80eed05e0f
- https://ethereum.stackexchange.com/questions/119960/what-role-does-abi-encoding-play-in-digital-signature
- https://solidity-by-example.org/

### On data storage

- https://docs.soliditylang.org/en/v0.5.3/types.html#data-location
- https://stackoverflow.com/questions/68997666/what-is-bytes-calldata-data
- https://blog.openzeppelin.com/ethereum-in-depth-part-2-6339cf6bddb9/

### Testing

- https://github.com/pickle-finance/protocol/tree/master/src/tests
