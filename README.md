Awake
===
![Code size](https://img.shields.io/github/languages/code-size/tr1ckyf0x/wakeonlan-ios) ![GitHub commit activity](https://img.shields.io/github/commit-activity/m/tr1ckyf0x/wakeonlan-ios) ![GitHub contributors](https://img.shields.io/github/contributors/tr1ckyf0x/wakeonlan-ios)

[![App Store](https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&amp;releaseDate=1638748800)](https://apps.apple.com/us/app/awake-wake-on-lan/id1575138731?itsct=apps_box_badge&amp;itscg=30200)

## Required tools
1. [Mint](https://github.com/yonaskolb/Mint)
2. [git-secret](https://git-secret.io) *(optionally, only if you have an access to secrets)*

## Bootstrap

* #### Reveal secrets *(only for maintainers)*
```bash
git secret reveal
```

* #### Bootstrap project
```bash
make bootstrap
```

* #### Open the generated `Wake on LAN.xcworkspace` and build the scheme `Wake on LAN`

## Code generation instructions
To generate new modules or `swiftgen` files please follow instructions for `foxgen` which will be built during bootstrap
```bash
mint run foxgen --help
```

## GPG key generation for git-secret *(only for maintainers)*

`gpg --full-generate-key`

```
Kind of key: RSA and RSA
Keysize: 4096
Key lifetime: 1 year
```

`gpg --armor --export your.email@address.com > public-key.gpg`

Send key to one of maintainers.

## Donate
![alt text](https://github.com/tr1ckyf0x/Stonks/blob/main/Packages/Modules/Sources/MenuBar/Resources/Assets.xcassets/Logo/bitcoin.imageset/bitcoin-btc-logo.svg "Bitcoin (BTC)")
Bitcoin (BTC): bc1q6fxdcdzlq8gn6s3kuvwkcxxwsw7c9ks3qal5z2

![alt text](https://github.com/tr1ckyf0x/Stonks/blob/main/Packages/Modules/Sources/MenuBar/Resources/Assets.xcassets/Logo/ethereum.imageset/ethereum-eth-logo.svg "Ethereum (ETH), USDT ERC20")
Ethereum (ETH), USDT ERC20: 0x4a52D891a55E44E3299e35637090E0f12B49A579

![alt text](https://github.com/tr1ckyf0x/Stonks/blob/main/Packages/Modules/Sources/MenuBar/Resources/Assets.xcassets/Logo/solana.imageset/solana-sol-logo%401x.png "Solana (SOL), USDC")
Solana (SOL), USDC: CmgkM2gEp6TpDgx2NbaBPChPJRayY8J1oMn1g3XFmZEG

![alt text](https://github.com/tr1ckyf0x/Stonks/blob/main/Packages/Modules/Sources/MenuBar/Resources/Assets.xcassets/Logo/bnb.imageset/bnb-bnb-logo.svg "BNB Binance Smart Chain (BSC Network)")
BNB Binance Smart Chain (BSC Network BEP20): 0x4a52D891a55E44E3299e35637090E0f12B49A579

![alt text](https://github.com/tr1ckyf0x/Stonks/blob/main/Packages/Modules/Sources/MenuBar/Resources/Assets.xcassets/Logo/tron.imageset/tron-trx-logo.svg "Tron (TRX), USDT TRC20")
Tron (TRX), USDT TRC20: TQEftARsfdcSxWK863arb7y3oG9FqP4d9j
