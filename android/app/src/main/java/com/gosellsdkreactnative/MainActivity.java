package com.gosellsdkreactnative;

import android.content.Intent;

import com.facebook.react.ReactActivity;
import com.facebook.react.ReactInstanceManager;

public class MainActivity extends ReactActivity {
  private ReactInstanceManager mReactInstanceManager;

  /**
   * Returns the name of the main component registered from JavaScript. This is used to schedule
   * rendering of the component.
   */
  @Override
  protected String getMainComponentName() {
    return "gosellSDKReactNative";
  }
  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);

    mReactInstanceManager.onActivityResult(this,requestCode, resultCode, data);
  }
}
