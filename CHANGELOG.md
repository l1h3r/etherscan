# Etherscan Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [2.0.0]
### Added
- `Etherscan.get_transaction_receipt_status/1`
- Option to set HTTPoison options via `config :etherscan, request: []`

### Changed
- `Etherscan.API.Accounts.get_balance/1`
  - returns balance in ether. previously wei
- `Etherscan.API.Accounts.get_balances/1`
  - returns balance in ether. previously wei
- `Etherscan.API.Logs.get_logs/1`
  - returns error if given an invalid address. previously made request with invalid address
- `Etherscan.API.Proxy.get_eth_supply/0`
  - returns supply in ether. previously wei

## [0.1.5] - 2018-03-15
### Changed
- Update `httpoison` to `1.0.0`

## [0.1.4] - 2017-12-09
### Added
- Option to configure ethereum network via `config :etherscan, network: <SOME-NETWORK>`
- Support for log endpoints via `Etherscan.API.Logs`
- Support for Geth/Parity proxy endpoints via `Etherscan.API.Proxy`
- More documentation and usage examples

## [0.1.3] - 2017-10-11
### Added
- Option to configure api key via `config :etherscan, api_key: <YOUR-API-KEY>`

## [0.1.2] - 2017-09-27
### Changed
- Dependency/fixture update

## [0.1.1] - 2017-09-04
### Added
- Initial test coverage

## 0.1.0 - 2017-08-26
### Added
- First version

[Unreleased]: https://github.com/l1h3r/etherscan/compare/2.0.0...HEAD
[2.0.0]: https://github.com/l1h3r/etherscan/compare/0.1.5...2.0.0
[0.1.5]: https://github.com/l1h3r/etherscan/compare/0.1.4...0.1.5
[0.1.4]: https://github.com/l1h3r/etherscan/compare/0.1.3...0.1.4
[0.1.3]: https://github.com/l1h3r/etherscan/compare/0.1.2...0.1.3
[0.1.2]: https://github.com/l1h3r/etherscan/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/l1h3r/etherscan/compare/0.1.0...0.1.1
