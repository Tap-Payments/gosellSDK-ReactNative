package com.gosellsdkreactnative;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.uimanager.IllegalViewOperationException;
import com.facebook.react.uimanager.PixelUtil;
import com.facebook.react.util.RNLog;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;

import java.util.HashMap;
import java.util.Map;

import kotlin.Result;
import retrofit2.Call;
import retrofit2.Response;


/**
 * GoSellSdkFlutterPlugin
 */
public class GoSellSdkReactNativePlugin extends ReactContextBaseJavaModule implements ActivityEventListener {
    private Activity _activity;
    public static WritableArray applist;
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
            if(activity!=null){
                GoSellSdkReactNativePlugin plugin = new GoSellSdkReactNativePlugin();
                plugin.setup( application, activity);
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
            final Activity activity) {
        this.activity = activity;
        this.application = application;
        this.delegate = constructDelegate(activity);

        observer = new LifeCycleObserver(activity);
        if (activity != null) {
            // V1 embedding setup for activity listeners.
            application.registerActivityLifecycleCallbacks(observer);

        } else {

        }
    }



    /**
     * construct delegate
     */

    private final GoSellSdKDelegate constructDelegate(final Activity setupActivity) {
        return new GoSellSdKDelegate(setupActivity);
    }

    /**
     * MethodChannel.Result wrapper that responds on the platform thread.
     */

    public static class MethodResultWrapper implements retrofit2.Callback {
       /* private MethodChannel.Result methodResult;
        private Handler handler;

        MethodResultWrapper(MethodChannel.Result result) {
            methodResult = result;
            handler = new Handler(Looper.getMainLooper());
        }

        @Override
        public void success(final Object result) {

            System.out.println("success coming from delegate : " + result);

            handler.post(
                    new Runnable() {
                        @Override
                        public void run() {
                            methodResult.success(result);
                        }
                    });
        }

        @Override
        public void error(
                final String errorCode, final String errorMessage, final Object errorDetails) {
            System.out.println("error encountered................." + errorCode);

            handler.post(
                    () -> methodResult.error(errorCode,errorMessage,errorDetails));
        }

        @Override
        public void notImplemented() {
            handler.post(
                    () -> methodResult.notImplemented());
        }
*/
        @Override
        public void onResponse(Call call, Response response) {
            System.out.println("success coming from delegate : " + response.body());
        }

        @Override
        public void onFailure(Call call, Throwable t) {
            System.out.println("error encountered................." + call);

           /* handler.post(
                    () -> methodResult.error(errorCode,errorMessage,errorDetails));*/
        }
    }


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
  @ReactMethod
 public void startPayment(ReadableMap objectHashMap, Callback callback) {
        HashMap<String, Object> args = objectHashMap.toHashMap();
        System.out.println("args : " + args);
        System.out.println("callback..... started");

        if (getCurrentActivity() == null) {
           // rawResult.invoke("no_activity", "SDK plugin requires a foreground activity.", null);
            callback.invoke("no_activity", "SDK plugin requires a foreground activity.", null);
            return;
        }

        if (objectHashMap.toHashMap().equals("terminate_session")) {
            System.out.println("terminate session!");
            delegate.terminateSDKSession();
            return;
        }
        ReadableMapKeySetIterator iterator = objectHashMap.keySetIterator()
     // WritableMap resultData = new WritableNativeMap();
     // resultData.putMap("map",objectHashMap);
     // callback.invoke(resultData);

        //TODO how to pass the result callback???
        delegate.startSDK(callback, args);

    }



}
}

