
package company.tap.goSellSDKExamplee;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class RNGosellSdkReactNativeModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNGosellSdkReactNativeModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNGosellSdkReactNative";
  }
}