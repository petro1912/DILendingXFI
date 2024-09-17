## DILending Protocol
“DI Lending” Protocol is the DeFI Lending protocol which puts the idle liquidity (principal) and collateral assets into other external staking/yield farming protocols to maximize capital utilization and revenue in the pool.

This repository is smart contract project that is responsible for backend part of DI Lending. 

## Tech Stack

Language and development suites
```shell
solidity: ^0.8.18
foundry: 0.2.0
```

External Libraries
```shell
openzeppelin-contracts@5.0.2
solady@0.0.235
```

## Documentation

https://dilending.gitbook.io/di-lending

### Factory contract
[LendingPoolFactory.sol](https://github.com/petro1912/DILendingXFI/blob/master/src/LendingPoolFactory.sol)
This contract is a factory contract that creates a `Lending Pool` contract for each principal token, and there can only be one pool for each principal token in the protocol. 

[LendingPool.sol](https://github.com/petro1912/DILendingXFI/blob/master/src/LendingPool.sol)
This contract is a pool contract that is responsible for loans to one principal token and its features are implemented by several libraries.
```sh
Supply
Borrow
Liquidation
InterestRateModel
AccountingLib
InvestmentLib // this is not yet implemented
```



## Usage

### Mock Features
For test only, protocol uses mock contracts.
[mock tokens](https://github.com/petro1912/DILendingXFI/tree/master/src/mock/tokens)
[mock stakings](https://github.com/petro1912/DILendingXFI/tree/master/src/mock/staking)


### Build
install external libraries
```shell
forge install
```
build
```shell
$ forge build
```
### Format

```shell
$ forge fmt
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Deploy.s.sol:DeployScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```