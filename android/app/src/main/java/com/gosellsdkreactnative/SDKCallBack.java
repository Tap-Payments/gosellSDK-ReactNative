package com.gosellsdkreactnative;

import java.util.HashMap;

public interface SDKCallBack {
    public void onSuccess(HashMap<String,String> result);
    public void onFailure();
}
