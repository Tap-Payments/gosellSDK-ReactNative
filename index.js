
import { NativeModules, NativeEventEmitter } from 'react-native';
import goSellModels from './models'
const { RNGosellSdkReactNative } = NativeModules;

const RNGosellEmitter = new NativeEventEmitter(RNGosellSdkReactNative);

module.exports = { goSellSDK: RNGosellSdkReactNative, goSellSDKModels: { ...goSellModels }, goSellListener: RNGosellEmitter };


