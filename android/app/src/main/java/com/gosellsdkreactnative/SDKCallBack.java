package com.gosellsdkreactnative;

import java.util.HashMap;
import java.util.Map;

public interface SDKCallBack {
    public void onSuccess(HashMap<String,String> result);
    public void onFailure(Map<String, Object> resultMap);
}
