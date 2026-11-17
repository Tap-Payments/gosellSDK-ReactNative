// The iOS part of @tap-payments/gosell-sdk-react-native comes from this repository (see ios/Podfile)
// instead of node_modules, so the example always builds the wrapper's current native code.
module.exports = {
  dependencies: {
    '@tap-payments/gosell-sdk-react-native': {
      platforms: {
        ios: null,
      },
    },
  },
};
