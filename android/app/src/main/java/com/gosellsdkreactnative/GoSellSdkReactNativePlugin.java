package com.gosellsdkreactnative;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import retrofit2.Call;
import retrofit2.Response;


/**
 * GoSellSdkFlutterPlugin
 */
public class GoSellSdkReactNativePlugin extends ReactContextBaseJavaModule implements ActivityEventListener {
    private Activity _activity;
    public static WritableArray applist;
    private Callback callback;

    public GoSellSdkReactNativePlugin(ReactApplicationContext reactContext) {
        super(reactContext);
        this.application = (Application) reactContext.getApplicationContext();
    }

    @Override
    public String getName() {
        return "GoSellSdkReactNativePlugin";
    }

    @Override
    public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {

    }

    @Override
    public void onNewIntent(Intent intent) {

    }

    /**
     * LifeCycleObserver
     */
    private class LifeCycleObserver
            implements Application.ActivityLifecycleCallbacks, DefaultLifecycleObserver {
        private final Activity thisActivity;

        LifeCycleObserver(Activity activity) {
            this.thisActivity = activity;
        }

        @Override
        public void onCreate(@NonNull LifecycleOwner owner) {
            if (activity != null) {
                GoSellSdkReactNativePlugin plugin = new GoSellSdkReactNativePlugin();
                plugin.setup(application, activity);

            }
        }

        @Override
        public void onStart(@NonNull LifecycleOwner owner) {

        }

        @Override
        public void onResume(@NonNull LifecycleOwner owner) {
        }

        @Override
        public void onPause(@NonNull LifecycleOwner owner) {
        }

        @Override
        public void onStop(@NonNull LifecycleOwner owner) {
            onActivityStopped(thisActivity);
        }

        @Override
        public void onDestroy(@NonNull LifecycleOwner owner) {
            onActivityDestroyed(thisActivity);
        }

        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
            _activity = activity;


        }

        @Override
        public void onActivityStarted(Activity activity) {
        }

        @Override
        public void onActivityResumed(Activity activity) {
        }

        @Override
        public void onActivityPaused(Activity activity) {
        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
        }

        @Override
        public void onActivityDestroyed(Activity activity) {
            if (thisActivity == activity && activity.getApplicationContext() != null) {
                ((Application) activity.getApplicationContext())
                        .unregisterActivityLifecycleCallbacks(
                                this); // Use getApplicationContext() to avoid casting failures
            }
        }

        @Override
        public void onActivityStopped(Activity activity) {
            if (thisActivity == activity) {
                delegate.saveStateBeforeResult();
            }
        }
    }

    /**
     * class properties
     */
//    private MethodChannel channel;
    private GoSellSdKDelegate delegate;

    //   private ActivityPluginBinding activityBinding;
    private Application application;
    private Activity activity;
    // This is null when not using v2 embedding;
    private Lifecycle lifecycle;
    private LifeCycleObserver observer;


    /**
     * Default constructor for the plugin.
     *
     * <p>Use this constructor for production code.
     */
    public GoSellSdkReactNativePlugin() {
    }


    /**
     * setup
     */

    private void setup(
            final Application application,
            final Activity activity1) {
        this.activity = activity1;
        this.application = application;
        this.delegate = constructDelegate(activity1);

        observer = new LifeCycleObserver(activity);
        if (activity != null) {
            // V1 embedding setup for activity listeners.
            application.registerActivityLifecycleCallbacks(observer);

        } else {
            application.registerActivityLifecycleCallbacks((Application.ActivityLifecycleCallbacks) delegate);
        }
    }


    /**
     * construct delegate
     */

    private final GoSellSdKDelegate constructDelegate(final Activity setupActivity) {
        return new GoSellSdKDelegate(setupActivity);
    }





    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @ReactMethod
    public void startPayment(ReadableMap readableMap, Callback callback) {
        System.out.println( "callbacktype = " + callback);
        HashMap<String, Object> args = readableMap.toHashMap();
        System.out.println("args : " + args);
        System.out.println("readableMap : " + readableMap);
        System.out.println("callback..... started");

        if (getCurrentActivity() == null) {
            // rawResult.invoke("no_activity", "SDK plugin requires a foreground activity.", null);
            callback.invoke("no_activity", "SDK plugin requires a foreground activity.", null);
            return;
        }

        if (readableMap.toHashMap().equals("terminate_session")) {
            System.out.println("terminate session!");
            delegate.terminateSDKSession();
            return;
        }
      //  this.callback= callback;

     //   pickerCancelCallback = cancelCallback;
       // ReadableMapKeySetIterator iterator = objectHashMap.keySetIterator();
      //  ReadableMap data =  objectHashMap.getMap(  "appCredentials");
      //  callback.invoke(null, data);
     //   System.out.println("objectHashMap = " + objectHashMap + ", callback = " + callback);
     //   callback.invoke(objectHashMap.toHashMap());

        HashMap<String,Object> map = new HashMap<>();
      //  map.put("message","Session react");
       // callback.invoke("error1","message 23");

        System.out.println("call back invoked " + callback);
            //TODO how to pass the result callback???
           // callback.invoke(writableArray,writableMap);

      //  startPayment(objectHashMap, callback);

      //  callback.invoke( methodResultWrapper);

        delegate.startSDK(args,callback);


  //  }



}
}


