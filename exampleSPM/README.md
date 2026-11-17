# goSell React Native example (Swift Package Manager)

The same app as [`../example`](../example), iOS only, but goSellSDK reaches the iOS app through
**Swift Package Manager** instead of CocoaPods.

How it works: `ios/Podfile` sets `ENV['GOSELL_USE_SPM'] = '1'`. The wrapper's podspec
(`RNGosellSdkReactNative.podspec`) then declares goSellSDK with React Native's `spm_dependency`
(React Native 0.75+), and `pod install` adds the `goSellSDK-iOS` Swift package to the wrapper's pod target.
To do the same in your own app, set the flag before running `pod install`:

```sh
GOSELL_USE_SPM=1 bundle exec pod install
```

## Run it

```sh
yarn install                 # also creates keys.json from keys.example.json
# put your Tap sandbox / production keys and bundle ID in keys.json (it's git-ignored)
cd ios && bundle exec pod install && cd ..
yarn ios
```
