/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, { Component } from 'react';
import { StyleSheet, Text, View, NativeModules, Button, Alert, Platform, StatusBar, SafeAreaView, TouchableOpacity } from 'react-native';

import Header from './components/Header';

export default class App extends Component {


  constructor(props) {
    super(props);
    this.state = { statusNow: "not started" };
    this.changeState = this.changeState.bind(this);
    this.startSDK = this.startSDK.bind(this);
  }

  startSDK() {

    // console.log('this' + this)
    var transactionCurrency = "kwd";
    var shipping = [{
      name: "shipping 1",
      description: "shiping description 1",
      amount: 100.0
    }];

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

    var taxes = [{ "name": "tax1", "description": "tax describtion", "amount": { "type": "F", "value": 10.0, "maximum_fee": 10.0, "minimum_fee": 1.0 } }, { "name": "tax1", "description": "tax describtion", "amount": { "type": "F", "value": 10.0, "maximum_fee": 10.0, "minimum_fee": 1.0 } }];
    var customer = { "isdNumber": "965", "number": "00000000", "customerId": "", "first_name": "test", "middle_name": "test", "last_name": "test", "email": "test@test.com" };
    var paymentReference = { "track": "track", "payment": "payment", "gateway": "gateway", "acquirer": "acquirer", "transaction": "trans_910101", "order": "order_262625", "gosellID": null };

    var allConfigurations = {
      appCredentials: {
        production_secrete_key: "sk_test_cvSHaplrPNkJO7dhoUxDYjqA",
        language: "en",
        sandbox_secrete_key: "sk_test_kovrMB0mupFJXfNZWx6Etg5y",
        bundleID: "company.tap.goSellSDKExample"
      },
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

    console.log('start SDK');
    NativeModules.GoSellSdkReactNativePlugin.startPayment(allConfigurations, (error, status) => {
      console.log(`received error => ${error}`);
      console.log(`received status => ${status}`);

      var myString = JSON.stringify(status);
      console.log('callback is done');
      console.log('status is ' + status.sdk_result);
      console.log(myString);
      var resultStr = String(status.sdk_result);

      this.changeState(resultStr, myString, () => { console.log('done') })

    })

  }

  changeState(newName, resultValue, callback) {
    console.log('the new value is' + newName);
    this.setState(
      {
        statusNow: newName,
        result: resultValue,
      },
      callback,
    );
  }




  render() {
    const statusbar = (Platform.OS == 'ios') ? <StatusBar backgroundColor="blue" barStyle="light-content" /> : <View />
    const { statusNow } = this.state;
    return (

      <View style={styles.container}>
        <Text style={styles.welcome}>goSellSDK-ReactNative!!</Text>
        <Text> Status is {statusNow}</Text>
        <Button
          onPress={this.startSDK}
          title="Start Payment"
          color="#FF6347"
        />
        {/* <Button title="Change state" onPress={() => this.changeState('my name here')} /> */}
      </View>

    );
  }
}
const styles = StyleSheet.create({

  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },

});