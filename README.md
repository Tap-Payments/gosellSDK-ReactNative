# gosellSDK-ReactNative
React-Ntive plugin compatible version of goSellSDK library for both Android and iOS that fully covers payment/authorization/card saving/card tokenization process inside your Android application.
Original SDKS

- React-Native (https://github.com/Tap-Payments/gosellSDK-ReactNative)
- Android (https://github.com/Tap-Payments/goSellSDK-Android)
- AndroidX (https://github.com/Tap-Payments/goSellSDK-AndroidX)
- iOS (https://github.com/Tap-Payments/goSellSDK-ios)

## Getting Started

# Table of Contents

---

1. [Requirements](#requirements)
2. [Installation](#installation)
   1. [Install goSellSDK using npm](#installation_with_npm)
3. [Usage](#usage)
   1. [Configure Your App](#configure_your_app)
   2. [Configure SDK Session](#configure_sdk_session)
   3. [Transaction Modes](#transaction_modes)
   4. [Customer](#customer)
   5. [Use Tap Pay Button](#tap_pay_button)
   6. [Start Payment](#start_payment)
   7. [Handle SDK Result](#handle_sdk_result)
   8. [Apple Pay Setup](#apple_pay)
4. [Common Issues](#common_issues)

<a href="requirements"></a>

# Requirements

---

To use the SDK the following requirements must be met:

1. **Visual Studio - InteliJ Idea**
2. **react: 16.13.1** or newer
3. **react-native: 0.63.3** or newer
4. **iOS 11** or later
5. **XCode 12** or later

<a name="installation"></a>

# Installation

---

<a name="installation_with_npm"></a>

### Install goSellSDK using npm
###### Open Terminal
**Install npm packages**
```
npm install
```
**Install goSellSdkReactNative package**
```
npm i @tap-payments/gosell-sdk-react-native@1.0.28
```

### Install pods for iOS
```
cd ios
pod install
pod update
```

### Install pods for iOS for M1
```
sudo arch -x86_64 gem install ffi
arch -x86_64 pod install
```


### Install for Andoid
1. Make sure to set **minimum version to 21 in gradle**
2. Add **multiDexEnabled true** build gradle of app in android
3. Make sure to support **JDK 8**

---

<a name="configure_your_app"></a>

## Configure your app

Create `sdkConfigurations.js` file to set the configurations.

`goSellSDK` should be set up. To set it up, add the following lines of code inside `sdkConfigurations.js` in your project.
Import RNGoSell from `@tap-payments/gosell-sdk-react-native` package.
``` javascript
import RNGoSell from '@tap-payments/gosell-sdk-react-native';
const {
Languages,
PaymentTypes,
AllowedCadTypes,
TrxMode,
SDKMode
}= RNGoSell.goSellSDKModels;
```

Set app credentials using your **bundle / package ID** and your **sandbox** and **production** keys generated by `TAP Payments` as the below
``` javascript
const appCredentials = {
    production_secrete_key: (Platform.OS == 'ios') ? 'iOS-Live-KEY' : 'Android-Live-KEY',
    language: Languages.EN,
    sandbox_secrete_key: (Platform.OS == 'ios') ? 'iOS-SANDBOX-KEY' : 'Android-SANDBOX-KEY',
    bundleID: (Platform.OS == 'ios') ? 'iOS-PACKAGE-NAME' : 'ANDROIID-PACKAGE-NAME',
}
```

---

<a name="configure_sdk_session"></a>
**Configure SDK Session Example**

###### Transaction Currency
``` javascript
const transactionCurrency = 'kwd';
```
###### Shipping
``` javascript
const shipping = [
    {
        name: 'shipping 1',
        description: 'shiping description 1',
        amount: 100.0,
    },
];
```
###### Payment Items
``` javascript
const paymentitems = [
    {
        amount_per_unit: 1,
        description: 'Item 1 Apple',
        discount: {
            type: 'F',
            value: 10,
            maximum_fee: 10,
            minimum_fee: 1,
        },
        name: 'item1',
        quantity: {
            value: 1,
        },
        taxes: [
            {
                name: 'tax1',
                description: 'tax describtion',
                amount: {
                    type: 'F',
                    value: 10,
                    maximum_fee: 10,
                    minimum_fee: 1,
                },
            },
        ],
        total_amount: 100,
    },
];
```
###### Taxes
``` javascript
const taxes = [
    {
        name: 'tax1',
        description: 'tax describtion',
        amount: { type: 'F', value: 10.0, maximum_fee: 10.0, minimum_fee: 1.0 },
    },
    {
        name: 'tax1',
        description: 'tax describtion',
        amount: { type: 'F', value: 10.0, maximum_fee: 10.0, minimum_fee: 1.0 },
    },
];
 ```

<a name="customer"></a>

 ###### Customer
 
- New Customer (First time to pay using goSell SDK)
``` javascript
const customer = {
    isdNumber: '965',
    number: '00000000',
    customerId: '',
    first_name: 'test',
    middle_name: 'test',
    last_name: 'test',
    email: 'test@test.com',
};
```
> After the first transaction success, you receive the customerId in the response. Save it to be used in the next transaction.
- Existed Customer (paid before using goSell SDK)
 You need to set the customerId only and you can see the customer saved cards if the user has.
``` javascript
const customer = {
    isdNumber: '965',
    number: '00000000',
    customerId: 'cus_smdnd3346nd3dks3jd9drd7d',
    first_name: '',
    middle_name: '',
    last_name: '',
    email: '',
};
```

> Please note that goSell SDK using the customerId only if it's not Empty ('').

 ###### Payment Reference
 ``` javascript
const paymentReference = {
    track: 'track',
    payment: 'payment',
    gateway: 'gateway',
    acquirer: 'acquirer',
    transaction: 'trans_910101',
    order: 'order_262625',
    gosellID: null,
};
 ```
###### Set the final confugurations to be set to goSellSdk
``` javascript
const allConfigurations = {
    appCredentials: appCredentials,
    sessionParameters: {
        paymentStatementDescriptor: 'paymentStatementDescriptor',
        transactionCurrency: 'kwd',
        isUserAllowedToSaveCard: true,
        paymentType: PaymentTypes.ALL,
        amount: '100',
        shipping: shipping,
        allowedCadTypes:AllowedCadTypes.ALL,
        paymentitems: paymentitems,
        paymenMetaData: { a: 'a meta', b: 'b meta' },
        applePayMerchantID: 'applePayMerchantID',
        authorizeAction: { timeInHours: 10, time: 10, type: 'CAPTURE' },
        cardHolderName: 'Card Holder NAME',
        editCardHolderName: false,
        postURL: 'https://tap.company',
        paymentDescription: 'paymentDescription',
        destinations: 'null',
        trxMode: TrxMode.PURCHASE,
        taxes: taxes,
        merchantID: '',
        SDKMode: SDKMode.Sandbox,
        customer: customer,
        isRequires3DSecure: false,
        receiptSettings: { id: null, email: false, sms: true },
        allowsToSaveSameCardMoreThanOnce: false,
        paymentReference: paymentReference,
        uiDisplayMode: UiDisplayModes.DARK
    },
};

export default allConfigurations
```

---
<a name="transaction_modes"></a>
**Transaction Modes**

``` javascript 
trxMode: TransactionMode.PURCHASE
```


You can set the transaction mode into one of the following modes:
- **Purchase** 
   - ```TransactionMode.PURCHASE```<br/>
   > Normal customer charge.
- **Authorize** 
   - ```TransactionMode.AUTHORIZE_CAPTURE```<br/>
   > Only authorization is happening. You should specify an action after successful authorization: either capture the amount or void the charge after specific period of time.
- **Save Card** 
   - ```TransactionMode.SAVE_CARD```<br/>
   > Use this mode to save the card of the customer with Tap and use it later.
- **Tokenize Card** 
   - ```TransactionMode.TOKENIZE_CARD```<br/>
   > Use this mode if you are willing to perform the charging/authorization manually. The purpose of this mode is only to collect and tokenize card information details of your customer if you don't have PCI compliance certificate but willing to process the payment manually using our services.

---

<a name="tap_pay_button"></a>
**Use Tap Pay Button UI**
``` javascript
render() {
    const statusbar =
      Platform.OS == 'ios' ? (
        <StatusBar backgroundColor="blue" barStyle="light-content" />
      ) : (
          <View />
        );
    const { statusNow } = this.state;
    return (
      <SafeAreaView style={styles.safeAreaView}>
        <View style={styles.container}>
          {statusbar}
          <Header title="Plugin Example app" />
          <Text style={styles.statusText}> Status: {statusNow}</Text>
          <Text style={styles.resultText}>{this.state.result}</Text>
          <View style={styles.bottom}>
            {Platform.OS == 'ios' ?
              <TouchableOpacity onPress={this.startSDK}>
                <View style={styles.payButtonBg}>
                  <Text style={styles.payButtonText}>Start Payment</Text>
                </View>
              </TouchableOpacity>
              : <Button onPress={this.startSDK} {...styles.payButtonBg} title='Start Payment' />
            }
          </View>
        </View>
      </SafeAreaView>
    );
  }
```
``` javascript
const styles = StyleSheet.create({
  safeAreaView: {
    flex: 1,
    backgroundColor: '#000',
  },
  container: {
    flex: 1,
    backgroundColor: '#F5FCFF',
  },
  statusbar: {
    height: 20,
  },
  payButtonBg: {
    alignItems: 'center',
    color: '#25cf1f',
    backgroundColor: '#25cf1f',
    paddingVertical: 12,
    paddingHorizontal: 25,
    borderRadius: 25,
    position: 'absolute',
    bottom: 0,
    width: '90%',
    marginLeft: '6%',
    marginRight: '10%',
  },
  payButtonText: {
    color: '#FFF',
    fontSize: 20,
  },
  bottom: {
    flex: 1,
    justifyContent: 'flex-end',
    marginBottom: 36,
  },
  statusText: {
    textAlign: 'center',
    fontWeight: 'bold',
    fontSize: 25,
  },
  resultText: {
    textAlign: 'center',
    fontSize: 15,
    width: '90%',
    marginLeft: '6%',
    marginRight: '10%',
  },
});
```
---
<a name="start_payment"></a>
**Start Payment**

- In your `App.js` import RNGoSell from '@tap-payments/gosell-sdk-react-native'
- Import `sdkConfigurations` from './sdkConfigurations'
- Call start payment from
#### Parameters

- First parameter is the `sdkConfigurations` dictionary
-  Second parameter is integer value to set the `termination timeout in milliseconds`, the sdk will terminate the session after this time expire. `Set 0 if you don't want to terminate the session and keep it terminated normally clicking on cancel button by the user`
-  Third parameter is the `result callback`, you can handle the required action on recieving the the result through this callback.
``` javascript
import RNGoSell from '@tap-payments/gosell-sdk-react-native';
import sdkConfigurations from './sdkConfigurations';
// startPayment(sdkConfigurations, terminationTimeoutInMilliseconds, this.handleResult)
// Set terminationTimeoutInMilliseconds to 0 to prevent termination the session automatically
RNGoSell.goSellSDK.startPayment(sdkConfigurations, 0, this.handleResult) 
```
---
<a name="handle_sdk_result"></a>
**Handle SDK Result**

```javascript
handleResult(error, status) {
    var myString = JSON.stringify(status);
    console.log('status is ' + status.sdk_result);
    console.log(myString);
    var resultStr = String(status.sdk_result);
    switch (resultStr) {
      case 'SUCCESS':
        this.handleSDKResult(status)
        break
      case 'FAILED':
        this.handleSDKResult(status)
        break
      case "SDK_ERROR":
        console.log('sdk error............');
        console.log(status['sdk_error_code']);
        console.log(status['sdk_error_message']);
        console.log(status['sdk_error_description']);
        console.log('sdk error............');
        break
      case "NOT_IMPLEMENTED":
        break
    }
  }
  
  handleSDKResult(result) {
    console.log('trx_mode::::');
    console.log(result['trx_mode'])
    switch (result['trx_mode']) {
      case "CHARGE":
        console.log('Charge');
        console.log(result);
        this.printSDKResult(result);
        break;

      case "AUTHORIZE":
        this.printSDKResult(result);
        break;

      case "SAVE_CARD":
        this.printSDKResult(result);
        break;

      case "TOKENIZE":
        Object.keys(result).map((key) => {
          console.log(`TOKENIZE \t${key}:\t\t\t${result[key]}`);
        })

        // responseID = tapSDKResult['token'];
        break;
    }
  }

  printSDKResult(result) {
    if (!result) return
    Object.keys(result).map((key) => {
      console.log(`${result['trx_mode']}\t${key}:\t\t\t${result[key]}`);
    })
  }
```
---

<a name="apple_pay"></a>
**Apple pay setup**

Follow the steps shared in the following link to setup apple pay:<br/>
https://github.com/Tap-Payments/goSellSDK-ios#apple-pay

---

<a name="common_issues"></a>

## Common Issues
#### iOS
1. Undefined symbol:
   1. Undefined symbol: __swift_FORCE_LOAD_$_swiftWebKit
   2. Undefined symbol: __swift_FORCE_LOAD_$_swiftUniformTypeIdentifiers
   3. Undefined symbol: __swift_FORCE_LOAD_$_swiftCoreMIDI

   ###### Fix:
   - Add ```$(SDKROOT)/usr/lib/swift``` in **Build Settings > Library Search Paths**

2. Event Config Error: <event2/event-config.h> error
![error-react](https://user-images.githubusercontent.com/61692110/107148440-141ca600-6964-11eb-9334-39096262d55b.png)

   ###### Fix:
   1. In iOS Podfile, **replace ```use_flipper!``` with**   ```use_flipper!({ 'Flipper-Folly' => '2.3.0' })```
   2. Use command ```pod deintegrate``` then **remove Podfile.lock**
   3. Use command ```pod install``` then ```pod update```

