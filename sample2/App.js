/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, {Component} from 'react';
import {
  StyleSheet,
  Text,
  View,
  NativeModules,
  Button,
  Alert,
  Platform,
  StatusBar,
  SafeAreaView,
  TouchableOpacity,
} from 'react-native';
import Header from './components/Header';
import GoSellSdkReactNativePlugin from '@tap-payments/gosell-sdk-react-native';




export default class App1 extends Component {
  constructor(props) {
    super(props);
    this.state = {
      statusNow: 'not started',
      result: '',
    };
    this.changeState = this.changeState.bind(this);
    this.startSDK = this.startSDK.bind(this);
    
    if (!this.sdkModule&&GoSellSdkReactNativePlugin){ 
      this.sdkModule = GoSellSdkReactNativePlugin
    }

  }

  startSDK() {
    // console.log('this' + this)
    var transactionCurrency = 'kwd';
    var shipping = [
      {
        name: 'shipping 1',
        description: 'shiping description 1',
        amount: 100.0,
      },
    ];

    var paymentitems = [
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

    var taxes = [
      {
        name: 'tax1',
        description: 'tax describtion',
        amount: {type: 'F', value: 10.0, maximum_fee: 10.0, minimum_fee: 1.0},
      },
      {
        name: 'tax1',
        description: 'tax describtion',
        amount: {type: 'F', value: 10.0, maximum_fee: 10.0, minimum_fee: 1.0},
      },
    ];
    var customer = {
      isdNumber: '965',
      number: '00000000',
      customerId: '',
      first_name: 'test',
      middle_name: 'test',
      last_name: 'test',
      email: 'test@test.com',
    };
    var paymentReference = {
      track: 'track',
      payment: 'payment',
      gateway: 'gateway',
      acquirer: 'acquirer',
      transaction: 'trans_910101',
      order: 'order_262625',
      gosellID: null,
    };

    var allConfigurations = {
      appCredentials: {
        production_secrete_key: 'sk_test_cvSHaplrPNkJO7dhoUxDYjqA',
        language: 'en',
        sandbox_secrete_key: 'sk_test_cvSHaplrPNkJO7dhoUxDYjqA',
        bundleID: 'company.tap.goSellSDKExamplee',
      },
      sessionParameters: {
        paymentStatementDescriptor: 'paymentStatementDescriptor',
        transactionCurrency: 'kwd',
        isUserAllowedToSaveCard: true,
        paymentType: 'PaymentType.ALL',
        amount: '100',
        shipping: shipping,
        allowedCadTypes: 'CREDIT',
        paymentitems: paymentitems,
        paymenMetaData: {a: 'a meta', b: 'b meta'},
        applePayMerchantID: 'applePayMerchantID',
        authorizeAction: {timeInHours: 10, time: 10, type: 'CAPTURE'},
        cardHolderName: 'Card Holder NAME',
        editCardHolderName: false,
        postURL: 'https://tap.company',
        paymentDescription: 'paymentDescription',
        destinations: 'null',
        trxMode: 'TransactionMode.PURCHASE',
        taxes: taxes,
        merchantID: '',
        SDKMode: 'SDKMode.Sandbox',
        customer: customer,
        isRequires3DSecure: false,
        receiptSettings: {id: null, email: false, sms: true},
        allowsToSaveSameCardMoreThanOnce: false,
        paymentReference: paymentReference,
      },
    };

    console.log('start SDK');
    console.log(this.sdkModule);

    this.sdkModule&&  this.sdkModule.startPayment(allConfigurations, (error, status) => {
      var myString = JSON.stringify(status);
      // console.log('callback is done');
      console.log('status is ' + status.sdk_result);
      console.log(myString);
      var resultStr = String(status.sdk_result);

      this.changeState(resultStr, myString, () => {
        console.log('done');
      });
    });
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
    console.log(GoSellSdkReactNativePlugin);


    const statusbar =
      Platform.OS == 'ios' ? (
        <StatusBar backgroundColor="blue" barStyle="light-content" />
      ) : (
        <View />
      );
    const {statusNow} = this.state;
    return (
      <SafeAreaView style={styles.safeAreaView}>
        <View style={styles.container}>
          {statusbar}
          <Header title="Plugin Example app" />
          <Text style={styles.statusText}> Status: {statusNow}</Text>
          <Text style={styles.resultText}>{this.state.result}</Text>
          <View style={styles.bottom}>
            <TouchableOpacity onPress={this.startSDK}>
              <View style={styles.payButtonBg}>
                <Text style={styles.payButtonText}>Start Payment</Text>
              </View>
            </TouchableOpacity>
          </View>
        </View>
      </SafeAreaView>
    );
  }
}
const styles = StyleSheet.create({
  safeAreaView: {
    flex: 1,
    backgroundColor: '#000',
  },
  container: {
    flex: 1,
    // justifyContent: 'center',
    // alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  statusbar: {
    height: 20,
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
