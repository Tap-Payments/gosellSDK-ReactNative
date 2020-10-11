# gosellSDK-ReactNative
React-Ntive plugin compatible version of goSellSDK library for both Android and iOS that fully covers payment/authorization/card saving/card tokenization process inside your Android application.
Original SDKS

- Android (https://github.com/Tap-Payments/goSellSDK-Android)
- AndroidX (https://github.com/Tap-Payments/goSellSDK-AndroidX)
- iOS (https://github.com/Tap-Payments/goSellSDK-ios)

## Getting Started

# Table of Contents

---

1. [Requirements](#requirements)
2. [Installation](#installation)
   1. [Installation with npm]
3. [Usage](#usage)
   1. [Configure Your App](#configure_your_app)
   2. [Configure SDK Session](#configure_sdk_session)
   3. [Use Tap Pay Button](#tap_pay_button)
   4. [Handle SDK Result](#handle_sdk_result)

<a href="requirements"></a>

# Requirements

---

To use the SDK the following requirements must be met:

1. **Visual Studio - InteliJ Idea**
2. **react: 16.13.1** or newer
3. **react-native: 0.63.3** or newer

<a name="installation"></a>

# Installation

---

<a name="installation_with_pubspec"></a>

### Include goSellSDK plugin as a dependency in your package.json

```dart
 "dependencies: {
     "go_sell_sdk_react_native": "0.0.1"
 }
```

---

<a name="configure_your_app"></a>

## Configure your app

`goSellSDK` should be set up. To set it up, add the following lines of code somewhere in your project and make sure they will be called before any usage of `goSellSDK`.

```dart
/**
 * Configure App. (You must get those keys from tap)
 */
      appCredentials: {
        production_secrete_key: (Platform.OS == 'ios') ? "iOS-Live-KEY" : "Android-Live-KEY",
        language: "en",
        sandbox_secrete_key: (Platform.OS == 'ios') ? "iOS-SANDBOX-KEY" : "Android-SANDBOX-KEY",
        bundleID: (Platform.OS == 'ios') ? "iOS-PACKAGE-NAME" : "ANDROIID-PACKAGE-NAME"
      }
```

---

<a name="configure_your_app"></a>


---

<a name="handle_sdk_result"></a>
**Handle SDK Result**

- Start SDK
startPayment
