
import { NativeModules } from 'react-native';
import goSellModels from './models'
const { RNGosellSdkReactNative } = NativeModules;

export default { goSellSDK: RNGosellSdkReactNative, goSellSDKModels: { ...goSellModels } };


