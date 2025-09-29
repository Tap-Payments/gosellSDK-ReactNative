/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 */

import React, {useState, useEffect, useRef, useCallback} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Button,
  Platform,
  StatusBar,
  SafeAreaView,
  TouchableOpacity,
  EmitterSubscription,
} from 'react-native';
import Header from './components/Header';
import RNGoSell, {
  GoSellSDK,
  GoSellSDKModels,
  SDKResult,
} from '@tap-payments/gosell-sdk-react-native';
import sdkConfigurations from './sdkConfigurations';

const App = () => {
  const [statusNow, setStatusNow] = useState('not started');
  const [result, setResult] = useState('');

  const sdkModuleRef = useRef<GoSellSDK | null>(null);
  const sdkModelsRef = useRef<GoSellSDKModels | null>(null);
  const subscriptionRef = useRef<EmitterSubscription | null>(null);

  const printSDKResult = useCallback((result: SDKResult) => {
    if (!result) return;
    Object.keys(result).map(key => {
      console.log(`${result['trx_mode']}\t${key}:\t\t\t${result[key]}`);
    });
  }, []);

  const handleSDKResult = useCallback(
    (result: SDKResult) => {
      console.log('trx_mode::::');
      console.log(result['trx_mode']);
      switch (result['trx_mode']) {
        case 'CHARGE':
          console.log('Charge');
          console.log(result);
          printSDKResult(result);
          break;

        case 'AUTHORIZE':
          printSDKResult(result);
          break;

        case 'SAVE_CARD':
          printSDKResult(result);
          break;

        case 'TOKENIZE':
          Object.keys(result).map(key => {
            console.log(
              `TOKENIZE \t${key}:\t\t\t${JSON.stringify(result[key])}`,
            );
          });
          // responseID = tapSDKResult['token'];
          break;
      }
    },
    [printSDKResult],
  );

  const changeState = useCallback(
    (
      newName: React.SetStateAction<string>,
      resultValue: React.SetStateAction<string>,
      callback: () => void,
    ) => {
      console.log('the new value is' + newName);
      setStatusNow(newName);
      setResult(resultValue);
      if (callback) callback();
    },
    [],
  );

  const handleResult = useCallback(
    (error: any, status: SDKResult) => {
      var myString = JSON.stringify(status, null, 2);
      console.log('status is ' + status.sdk_result);
      console.log(myString);
      var resultStr = String(status.sdk_result);
      switch (resultStr) {
        case 'SUCCESS':
          handleSDKResult(status);
          break;
        case 'FAILED':
          handleSDKResult(status);
          break;
        case 'SDK_ERROR':
          console.log('sdk error............');
          console.log(status['sdk_error_code']);
          console.log(status['sdk_error_message']);
          console.log(status['sdk_error_description']);
          console.log('sdk error............');
          break;
        case 'NOT_IMPLEMENTED':
          break;
      }
      changeState(resultStr, myString, () => {
        console.log('done');
      });
    },
    [handleSDKResult, changeState],
  );

  const startSDK = useCallback(() => {
    console.log('start SDK');
    console.log(sdkModuleRef.current);

    // startPayment(sdkConfigurations, terminationTimeoutInMilliseconds, handleResult)
    // Set terminationTimeoutInMilliseconds to 0 to prevent termination the session automatically
    sdkModuleRef.current &&
      sdkModuleRef.current.startPayment(sdkConfigurations, 0, handleResult);
  }, [handleResult]);

  useEffect(() => {
    // Initialize SDK modules
    if (!sdkModuleRef.current && RNGoSell && RNGoSell.goSellSDK) {
      sdkModuleRef.current = RNGoSell.goSellSDK;
    }
    if (!sdkModelsRef.current && RNGoSell && RNGoSell.goSellSDKModels) {
      sdkModelsRef.current = RNGoSell.goSellSDKModels;
    }

    // Set up listener
    if (RNGoSell && RNGoSell.goSellListener && RNGoSell.goSellSDKModels) {
      subscriptionRef.current = RNGoSell.goSellListener.addListener(
        RNGoSell.goSellSDKModels.Listener.paymentInit,
        (charge: any) => {
          console.log(charge);
        },
      );
    }

    // Cleanup function
    return () => {
      if (subscriptionRef.current) {
        subscriptionRef.current.remove();
      }
    };
  }, []);

  const statusbar =
    Platform.OS == 'ios' ? (
      <StatusBar backgroundColor="blue" barStyle="light-content" />
    ) : (
      <View />
    );

  return (
    <SafeAreaView style={styles.safeAreaView}>
      <View style={styles.container}>
        {statusbar}
        <Header title="Plugin Example app" />
        <Text style={styles.statusText}> Status: {statusNow}</Text>
        <Text style={styles.resultText}>{result}</Text>
        <View style={styles.bottom}>
          {Platform.OS == 'ios' ? (
            <TouchableOpacity onPress={startSDK}>
              <View style={styles.payButtonBg}>
                <Text style={styles.payButtonText}>Start Payment</Text>
              </View>
            </TouchableOpacity>
          ) : (
            <Button
              onPress={startSDK}
              {...styles.payButtonBg}
              title="Start Payment"
            />
          )}
        </View>
      </View>
    </SafeAreaView>
  );
};

export default App;
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
