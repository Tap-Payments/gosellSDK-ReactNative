
import { NativeModules } from 'react-native';
import goSellModels from './models'
const { RNGosellSdkReactNative } = NativeModules;

module.exports = { goSellSDK: RNGosellSdkReactNative, goSellSDKModels: { ...goSellModels } };


