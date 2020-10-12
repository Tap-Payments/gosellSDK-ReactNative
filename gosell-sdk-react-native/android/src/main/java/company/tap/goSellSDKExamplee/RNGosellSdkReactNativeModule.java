
package company.tap.goSellSDKExamplee;

import android.app.Activity;
import android.app.Application;
import android.os.Build;
import android.support.annotation.RequiresApi;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;

import java.util.HashMap;

public class RNGosellSdkReactNativeModule extends ReactContextBaseJavaModule  implements SDKCallBack {

  private Callback jsCallback;
  private GoSellSdKDelegate delegate;
  private Application application;
  private final ReactApplicationContext reactContext;

  public RNGosellSdkReactNativeModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    this.application = (Application) reactContext.getApplicationContext();

  }

  @Override
  public String getName() {
    return "RNGosellSdkReactNative";
  }


  @Override
  public void onSuccess(HashMap<String, String> result) {

  }

  @Override
  public void onFailure() {

  }
  /**
   * setup
   */

  private void setup(
          final Application application,
          final Activity activity) {
    this.application = application;
    this.delegate = constructDelegate(activity);
  }


  /**
   * construct delegate
   */

  private final GoSellSdKDelegate constructDelegate(final Activity setupActivity) {
    System.out.println("setupActivity = " + setupActivity + "delegate>>>" + delegate);
    return new GoSellSdKDelegate(setupActivity);
  }



  @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  @ReactMethod
  public void startPayment(ReadableMap readableMap, Callback callback) {
    jsCallback = callback;
    HashMap<String, Object> args = (HashMap<String, Object>) readableMap;
    System.out.println("args : " + args);
    System.out.println("readableMap : " + readableMap);
    System.out.println("callback..... started" + delegate);
    Activity currentActivity = getCurrentActivity();
    if (currentActivity == null) {
      jsCallback.invoke("no_activity", "SDK plugin requires a foreground activity.", null);
      return;
    }

    if (readableMap.equals("terminate_session")) {
      System.out.println("terminate session!");
      delegate.terminateSDKSession();
      return;
    }

    System.out.println("call back invoked " + jsCallback);
    delegate.startSDK(args, this , currentActivity);


  }
}