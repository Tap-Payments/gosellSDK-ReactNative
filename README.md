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
   1. Install goSellSDK using npm (#installation_with_npm)
3. [Usage](#usage)
   1. [Configure Your App](#configure_your_app)
   2. [Configure SDK Session](#configure_sdk_session)
   3. [Use Tap Pay Button](#tap_pay_button)
   4. [Handle SDK Result](#handle_sdk_result)
4. [Common Issues](#common_issues)

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

<a name="installation_with_npm"></a>

### Install goSellSDK using npm
###### Open Terminal
```
npm i @tap-payments/gosell-sdk-react-native@0.0.1-beta.14
```

### Install pods for iOS
```
cd ios
pod install
```

---

<a name="configure_your_app"></a>

## Configure your app

`goSellSDK` should be set up. To set it up, add the following lines of code somewhere in your project and make sure they will be called before any usage of `goSellSDK`.

``` javascript
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

<a name="configure_sdk_session"></a>
**Configure SDK Session Example**

###### Transaction Currency
``` javascript
var transactionCurrency = "kwd";
var shipping = [{
name: "shipping 1",
description: "shiping description 1",
amount: 100.0
}];
```
###### Payment Items
``` javascript
var paymentitems = [
{
  "amount_per_unit": 1,
  "description": "Item 1 Apple",
  "discount": {
    "type": "F",
    "value": 10,
    "maximum_fee": 10,
    "minimum_fee": 1
  },
  "name": "item1",
  "quantity": {
    "value": 1
  },
  "taxes": [
    {
      "name": "tax1",
      "description": "tax describtion",
      "amount": {
        "type": "F",
        "value": 10,
        "maximum_fee": 10,
        "minimum_fee": 1
      }
    }
  ],
  "total_amount": 100
}
];
```
###### Taxes
``` javascript
var taxes = [{ "name": "tax1", 
"description": "tax describtion",
"amount": { "type": "F", "value": 10.0, "maximum_fee": 10.0, "minimum_fee": 1.0 } },
{ "name": "tax1", 
"description": "tax describtion", 
"amount": { "type": "F", "value": 10.0, "maximum_fee": 10.0, "minimum_fee": 1.0 } }];
 var customer = { "isdNumber": "965", 
 "number": "00000000",
 "customerId": "", 
 "first_name": "test",
 "middle_name": "test",
 "last_name": "test", 
 "email": "test@test.com" };
 ```
 ###### Payment Reference
 ``` javascript
 var paymentReference = { "track": "track",
 "payment": "payment", 
 "gateway": "gateway",
 "acquirer": "acquirer",
 "transaction": "trans_910101",
 "order": "order_262625",
 "gosellID": null };
 ```
``` javascript
var allConfigurations = {
appCredentials: appCredentials,
sessionParameters: {
  paymentStatementDescriptor: "paymentStatementDescriptor",
  transactionCurrency: "kwd",
  isUserAllowedToSaveCard: true,
  paymentType: "PaymentType.ALL",
  amount: "100",
  shipping: shipping,
  allowedCadTypes: "CREDIT",
  paymentitems: paymentitems,
  paymenMetaData: { "a": "a meta", "b": "b meta" },
  applePayMerchantID: "applePayMerchantID",
  authorizeAction: { "timeInHours": 10, "time": 10, "type": "CAPTURE" },
  cardHolderName: "Card Holder NAME",
  editCardHolderName: false,
  postURL: "https://tap.company",
  paymentDescription: "paymentDescription",
  destinations: "null",
  trxMode: "TransactionMode.PURCHASE",
  taxes: taxes,
  merchantID: "",
  SDKMode: "SDKMode.Sandbox",
  customer: customer,
  isRequires3DSecure: false,
  receiptSettings: { "id": null, "email": false, "sms": true },
  allowsToSaveSameCardMoreThanOnce: false,
  paymentReference: paymentReference,
}
};
```

---

<a name="tap_pay_button"></a>
**Use Tap Pay Button**
``` javascript
render() {
    const statusbar = (Platform.OS == 'ios') ? <StatusBar backgroundColor="blue" barStyle="light-content" /> : <View />
    const { statusNow } = this.state;
    return (
      <SafeAreaView style={styles.safeAreaView}>
        <View style={styles.container}>
          {statusbar}
          <Text style={styles.statusText}> Status: {statusNow}</Text>
          <Text style={styles.resultText} >{this.state.result}</Text>
          <View style={styles.bottom}>
            <TouchableOpacity onPress={this.startSDK} >
              <View style={styles.payButtonBg}>
                <Text style={styles.payButtonText}>
                  Start Payment
                </Text>
              </View>
            </TouchableOpacity>
          </View>
        </View>
      </SafeAreaView>
    );
  }
}
```
``` javascript
const styles = StyleSheet.create({
  safeAreaView: {
    flex: 1,
    backgroundColor: '#000'
  },
  container: {
    flex: 1,
    // justifyContent: 'center',
    // alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  statusbar: {
    height: 20
  },
  payButtonBg: {
    alignItems: 'center',
    backgroundColor: '#25cf1f',
    paddingVertical: 12,
    paddingHorizontal: 25,
    borderRadius: 25,
    position: 'absolute',
    bottom: 0,
    width: '90%',
    marginLeft: '6%',
    marginRight: '10%'
  },
  payButtonText: {
    color: '#FFF',
    fontSize: 20
  },
  bottom: {
    flex: 1,
    justifyContent: 'flex-end',
    marginBottom: 36
  },
  statusText: {
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: 25
  },
  resultText: {
    textAlign: 'center',
    fontSize: 15,
    width: '90%',
    marginLeft: '6%',
    marginRight: '10%'
  }
});
```


---

<a name="common_issues"></a>

## Common Issues
#### iOS
1. Undefined symbol:
   1. Undefined symbol: __swift_FORCE_LOAD_$_swiftWebKit
   2. Undefined symbol: __swift_FORCE_LOAD_$_swiftUniformTypeIdentifiers
   3. Undefined symbol: __swift_FORCE_LOAD_$_swiftCoreMIDI

   ###### Fix:
   - Add $(SDKROOT)/usr/lib/swift in **Build Settings > Library Search Paths**
