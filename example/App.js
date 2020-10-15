/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, { Component } from 'react';
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
import RNGoSell from '@tap-payments/gosell-sdk-react-native';
import sdkConfigurations from './sdkConfigurations';


export default class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      statusNow: 'not started',
      result: '',
    };
    this.changeState = this.changeState.bind(this);
    this.startSDK = this.startSDK.bind(this);
    this.handleResult = this.handleResult.bind(this);
    this.handleSDKResult = this.handleSDKResult.bind(this);
    this.printSDKResult = this.printSDKResult.bind(this);

    if (!this.sdkModule && RNGoSell && RNGoSell.goSellSDK) {
      this.sdkModule = RNGoSell.goSellSDK
    }
    if (!this.sdkModule && RNGoSell && RNGoSell.goSellSDKModels) {
      this.sdkModels = RNGoSell.goSellSDKModels
    }
  }

  startSDK() {
    console.log('start SDK');
    console.log(this.sdkModule);

    this.sdkModule && this.sdkModule.startPayment(sdkConfigurations, this.handleResult)
  }

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
    this.changeState(resultStr, myString, () => {
      console.log('done');
    });
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
}
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
