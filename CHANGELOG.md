

## 1.0.67 - 2024-08-12

- Update Android dependency.

## 1.0.66 - 2024-08-12

- Remove setupApplePay.

## 1.0.65 - 2024-08-08

- Fix payment agreement json

## 1.0.64 - 2024-08-08

- Add payment agreement in save card response 

## 1.0.63 - 2024-07-22

- Fix parsing receipt in android

## 1.0.61 - 2024-07-02

- Upgrade readme

## 1.0.60 - 2024-07-02

- Upgrade android version

## 1.0.59 - 2024-07-02

- Fix ios transaction fails when there is no phone number.

## 1.0.58 - 2024-07-02

- Remove fonts from android.

## 1.0.57 - 2024-04-28

- Disabling opening a payment option while executing a transaction.

## 1.0.56 - 2024-04-15

- Update android
### Impact on existing integrations:
- May need to update gradles to support latest apis support sdk 34
- compileSdkVersion 34
- targetSdkVersion 34
- Project build.gradle classpath 'com.android.tools.build:gradle:7.3.1'
- Gradle wrapper.properties distributionUrl=https\://services.gradle.org/distributions/gradle-7.4.2-bin.zip


## 1.0.55 - 2024-04-01

- Add recite

## 1.0.54 - 2024-03-12

- Update Android native lib

## 1.0.53 - 2024-01-29

- Add payment reference in response

## 1.0.52 - 2023-12-25

- Enable scan feature for iOS

## 1.0.51 - 2023-12-21

- Update iOS native lib

## 1.0.50 - 2023-12-21

- Update iOS native lib

## 1.0.49 - 2023-12-14

- Update Android native lib

## 1.0.48 - 2023-12-11

- Update ios native lib

## 1.0.47 - 2023-12-05

- Add sdk appearance param

## 1.0.46 - 2023-12-05

- Add supported payments methods

## 1.0.45 - 2023-11-28

- Update ios native lib


## 1.0.44 - 2023-11-26

- min sdk for android 21


## 1.0.43 - 2023-11-26

- min sdk for android 21


## 1.0.42 - 2023-11-06

- Add allowed payment types


## 1.0.41 - 2023-10-24

- Add apple pay tokenized failed callback
- Add apple pay tokenized success callback

## 1.0.40 - 2023-08-23

- Update Android GoSellSdk
## 1.0.39 - 2023-08-23

- Update Android GoSellSdk
## 1.0.38 - 2023-08-23

- Update Android GoSellSdk
## 1.0.37 - 2023-08-23

- Update iOS GoSellSdk
## 1.0.36 - 2023-02-17

- Add issuer response

## 1.0.35- 2023-02-17

- Update iOS/Android GoSellSdk
## 1.0.34 - 2023-02-17

## 1.0.34 - 2023-02-17

- Fix static framrworks option in iOS
## 1.0.33 - 2023-01-24

- add charge id callback

## 1.0.32 - 2023-01-12

- iOS> update iOS sdk version

## 1.0.31 - 2022-12-01

- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing
- Android> googlePay issue fixing

## 1.0.30 - 2022-11-02

- iOS> goSellSDK pods issue fixed
- iOS> goSellSDK pods issue fixing
- iOS> goSellSDK pods issue fixing
- iOS> goSellSDK pods issue fixing
- iOS> goSellSDK pods issue fixing
- iOS> goSellSDK pods issue fixing
- iOS> goSellSDK pods issue fixing
- iOS> goSellSDK pods issue fixing
- iOS> goSellSDK pods issue fixing


## 1.0.29 - 2022-09-27

- Android> asyncPaymentStarted methods prints bug fixed
- Android> asyncPaymentStarted methods prints bug fixed retrofit version tested
- Android> asyncPaymentStarted methods prints bug fixed and Retrofit version updated

## 1.0.28 - 2022-09-20

- Android> Inside GoSellSDKDelegate asyncPaymentStarted method added

## 1.0.27 - 2022-09-19

- Android> Retrofit library and androix version updated

## 1.0.26

- iOS> Transaction mode default value updated and will thorw exception on Invalid Trx mode
- iOS> Transaction mode default value updated and will thorw exception on Invalid Trx mode



## 1.0.25
- Updated configuration file and set back to original

## 1.0.24

- iOS> Transaction mode work updated

## 1.0.23

- iOS> Transaction mode added


## 1.0.22

## 1.0.21

- Android > align saved card text in arabic view from right to left same as iOS
- iOS > MM/YY update text in arabic to be same as android
- iOS > in case of dark mode activated > slider shows in dark color

## 1.0.20

- Typing name on the card and clicking “Space” from keyboard > user can’t see space while typing

## 1.0.19

- “Customer first name is required” error in Android while performing a transaction with non-3ds card
- “next” is taking the cursor to “expiry date” instead of CVV

## 1.0.18

## 1.0.17

- Save Card Mode: The return key should hide the keyboard
- Card name should not allow type Arabic characters
- Toggle button blinking issue fixed
- iOS in Save Card mode -Text difference between IOS & Android. This is fixed
- Android Tokenize Mode: Text on tokenize button updated with the amount
- Save Card Mode, Tokenize Mode: Enabled Windowed mode by default
- While entering a card number in iOS, Tokenize mode, while typing on space, the cursor is not moving. But while entering the next letter, the space is visible.
- Arabic placeholder for the expiry date mm/yy synced with Android.
- Save Card Mode: The return key should hide the keyboard
- Save Card Mode: Greyed button action stopped.