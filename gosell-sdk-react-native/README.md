
# react-native-gosell-sdk-react-native

## Getting started

`$ npm install react-native-gosell-sdk-react-native --save`

### Mostly automatic installation

`$ react-native link react-native-gosell-sdk-react-native`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-gosell-sdk-react-native` and add `RNGosellSdkReactNative.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNGosellSdkReactNative.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import company.tap.goSellSDKExamplee.RNGosellSdkReactNativePackage;` to the imports at the top of the file
  - Add `new RNGosellSdkReactNativePackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-gosell-sdk-react-native'
  	project(':react-native-gosell-sdk-react-native').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-gosell-sdk-react-native/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-gosell-sdk-react-native')
  	```


## Usage
```javascript
import RNGosellSdkReactNative from 'react-native-gosell-sdk-react-native';

// TODO: What to do with the module?
RNGosellSdkReactNative;
```
  