package com.gosellsdkreactnative;

import android.app.Activity;
import android.app.Application;
import android.os.Build;

import androidx.annotation.RequiresApi;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;

import java.util.HashMap;
import java.util.Map;


/**
 * GoSellSdkFlutterPlugin
 */
public class GoSellSdkReactNativePlugin extends ReactContextBaseJavaModule implements SDKCallBack {
    private Activity _activity;
    private Callback jsCallback;
    private GoSellSdKDelegate delegate;
    private Application application;

    public GoSellSdkReactNativePlugin(ReactApplicationContext reactContext) {
        super(reactContext);
        this.application = (Application) reactContext.getApplicationContext();
        this._activity = reactContext.getCurrentActivity();
        System.out.println("_activity = " + _activity);
        setup(application, _activity);
    }


    @Override
    public String getName() {
        return "GoSellSdkReactNativePlugin";
    }

    /**
     * setup
     */

    private void setup(
            final Application application,
            final Activity activity) {
        this._activity = activity;
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


    @Override
    public void onSuccess(HashMap<String,String> result) {
        System.out.println(" on success callback : "+ result);
        jsCallback.invoke(null, result);
    }

    @Override
    public void onFailure(Map<String, Object> resultMap) {
        System.out.println(" on failure callback : "+resultMap);
        jsCallback.invoke(null,resultMap.entrySet());
    }
}


