
package company.tap.goSellSDKExamplee;

import android.app.Activity;
import android.app.Application;
import android.os.Build;

import androidx.annotation.RequiresApi;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;

import java.util.HashMap;
import java.util.Map;

public class RNGosellSdkReactNativeModule extends ReactContextBaseJavaModule implements SDKCallBack {

  private Callback jsCallback;
  private GoSellSdKDelegate delegate;
  private Application application;
  private final ReactApplicationContext reactContext;
  private Activity _activity;



  public RNGosellSdkReactNativeModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
    this.application = (Application) reactContext.getApplicationContext();
    this._activity = reactContext.getCurrentActivity();
    System.out.println("_activity = " + _activity);
    setup(application, _activity);

  }

  @Override
  public String getName() {
    return "RNGosellSdkReactNative";
  }

  @Override
  public void onSuccess(HashMap<String,String> result) {
    System.out.println(" on success callback : "+ result);
    WritableMap writableMap = new WritableNativeMap();
    for (Map.Entry<String, String> entry : result.entrySet()) {
      writableMap.putString(entry.getKey(), entry.getValue());
    }
    System.out.println(" on success callback : "+ writableMap);
    jsCallback.invoke(null, writableMap);
  }

  @Override
  public void onFailure(Map<String, String> resultMap) {

    System.out.println(" on failure callback : "+resultMap);
      WritableMap writableMap = new WritableNativeMap();
      for (Map.Entry<String, String> entry : resultMap.entrySet()) {
        writableMap.putString(entry.getKey(), entry.getValue());
      }
      System.out.println(" on failure writableMap : "+writableMap);
      jsCallback.invoke(null,writableMap);
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
    HashMap<String, Object> args = readableMap.toHashMap();
    System.out.println("args : " + args);
    System.out.println("readableMap : " + readableMap);
    System.out.println("callback..... started" + delegate);
    Activity currentActivity = getCurrentActivity();
    if (currentActivity == null) {
      jsCallback.invoke("no_activity", "SDK plugin requires a foreground activity.", null);
      return;
    }

    if (readableMap.toHashMap().equals("terminate_session")) {
      System.out.println("terminate session!");
      delegate.terminateSDKSession();
      return;
    }

    System.out.println("call back invoked " + jsCallback);
    delegate.startSDK(args, this , currentActivity);


  }
}