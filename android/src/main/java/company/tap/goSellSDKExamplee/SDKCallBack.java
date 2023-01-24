package company.tap.goSellSDKExamplee;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by AhlaamK on 10/12/20.
 * <p>
 * Copyright (c) 2020    Tap Payments.
 * All rights reserved.
 **/
public interface SDKCallBack {
    public void onSuccess(HashMap<String,String> result);
    public void onFailure(Map<String, String> error);
    public void onPaymentInit(String chargeId);
}