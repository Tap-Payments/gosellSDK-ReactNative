package company.tap.goSellSDKExamplee;

import android.app.Activity;
import android.os.Build;
import android.os.CountDownTimer;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import company.tap.gosellapi.GoSellSDK;
import company.tap.gosellapi.internal.api.callbacks.GoSellError;
import company.tap.gosellapi.internal.api.models.Authorize;
import company.tap.gosellapi.internal.api.models.Charge;
import company.tap.gosellapi.internal.api.models.SaveCard;
import company.tap.gosellapi.internal.api.models.Token;
import company.tap.gosellapi.open.controllers.SDKSession;
import company.tap.gosellapi.open.delegate.SessionDelegate;
import company.tap.gosellapi.open.exception.CurrencyException;
import company.tap.gosellapi.open.models.CardsList;
import company.tap.gosellapi.open.models.TapCurrency;


public class GoSellSdKDelegate implements SessionDelegate {

    private SDKSession sdkSession;
    private Activity activity;
    private RNGosellSdkReactNativeModule callback;

    public GoSellSdKDelegate(Activity _activity) {
        this.activity = _activity;
    }


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void startSDK(
            HashMap<String, Object> sdkConfigurations, RNGosellSdkReactNativeModule result, Activity activity1, int timeout) {
        activity = activity1;
//Commented to testing
      /* if (!setPendingMethodCallAndResult(methodCall, result)) {
            finishWithAlreadyActiveError(result);
            return;
        }*/

        if (timeout > 0) {
            new CountDownTimer(timeout, 1) {
                public void onTick(long millisUntilFinished) {}
                public void onFinish() {
                    terminatePayment();
                }
            }.start();
        }

        // start SDK
        showSDK(sdkConfigurations, result);
    }

    public void terminatePayment() {
        System.out.println("terminate session!");
        Log.d("MainActivity", "Session Terminated.........");
        if (activity != null) {
            sdkSession.cancelSession(activity);
        }
    }


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private void showSDK(HashMap<String, Object> sdkConfigurations, RNGosellSdkReactNativeModule result) {
        HashMap<String, Object> sessionParameters = (HashMap<String, Object>) sdkConfigurations
                .get("sessionParameters");
        /**
         * Required step. Configure SDK with your Secret API key and App Bundle name
         * registered with tap company.
         */
        HashMap<String, String> appConfigurations = (HashMap<String, String>) sdkConfigurations.get("appCredentials");
        String sandboxKey = appConfigurations.get("sandbox_secrete_key");
        String productionKey = appConfigurations.get("production_secrete_key");
        String activeKey = sandboxKey;
        if ("SDKMode.Production".equalsIgnoreCase(sessionParameters.get("SDKMode").toString()))
            activeKey = productionKey;
        // System.out.println("activeKey : " + activeKey);
        configureApp(activeKey, appConfigurations.get("bundleID"), appConfigurations.get("language"), activity);

        // configureSDKThemeObject();

        /**
         * Required step. Configure SDK Session with all required data.
         */
        configureSDKSession(sessionParameters, result);
        sdkSession.start(activity);
    }


    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private void configureApp(String secrete_key, String bundleID, String language, Activity activity1) {
        System.out.println("act val :" + this.activity);
        this.activity = activity1;
        GoSellSDK.init(this.activity, secrete_key, bundleID); // to be replaced by merchant
        GoSellSDK.setLocale(language); // to be replaced by merchant
    }

    /**
     * Configure SDK Session
     *
     * @param sessionParameters
     * @param result
     */
    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    private void configureSDKSession(HashMap<String, Object> sessionParameters, RNGosellSdkReactNativeModule result) {
        callback = result;
        // Instantiate SDK Session
        if (sdkSession == null)
            sdkSession = new SDKSession(); // ** Required **

        // pass your activity as a session delegate to listen to SDK internal payment
        // process follow
        sdkSession.addSessionDelegate(this); // ** Required **

        // initiate PaymentDataSource
        sdkSession.instantiatePaymentDataSource(); // ** Required **

        // sdk mode
        sdkSession.setTransactionMode(
                DeserializationUtil.getTransactionMode(sessionParameters.get("trxMode").toString()));

        // set transaction currency associated to your account
        TapCurrency transactionCurrency;
        try {
            transactionCurrency = new TapCurrency(
                    (String) Objects.requireNonNull(sessionParameters.get("transactionCurrency")));
        } catch (CurrencyException c) {
            Log.d("GoSellSDKDelegate : ", "Unknown currency exception thrown : "
                    + (String) Objects.requireNonNull(sessionParameters.get("transactionCurrency")));
            transactionCurrency = new TapCurrency("KWD");
        } catch (Exception e) {
            Log.d("GoSellSDKDelegate : ", "Unknown currency: "
                    + (String) Objects.requireNonNull(sessionParameters.get("transactionCurrency")));
            transactionCurrency = new TapCurrency("KWD");
        }

        sdkSession.setTransactionCurrency(transactionCurrency); // ** Required **

        // Using static CustomerBuilder method available inside TAP Customer Class you
        // can populate TAP Customer object and pass it to SDK
        sdkSession.setCustomer(DeserializationUtil.getCustomer(sessionParameters)); // ** Required **

        // Set Total Amount. The Total amount will be recalculated according to provided
        // Taxes and Shipping
        BigDecimal amount;
        try {
            amount = new BigDecimal(
                    Double.parseDouble((String) Objects.requireNonNull(sessionParameters.get("amount"))));
        } catch (Exception e) {
            Log.d("GoSellSDKDelegate : ", "Invalid amount can't be parsed to double : "
                    + (String) Objects.requireNonNull(sessionParameters.get("amount")));
            amount = BigDecimal.ZERO;
        }
        sdkSession.setAmount(amount); // ** Required **

        sdkSession.setPaymentItems(DeserializationUtil.getPaymentItems(sessionParameters.get("paymentitems")));//**Optional you can pass empty array list**//

        // Set Taxes array list
        sdkSession.setTaxes(DeserializationUtil.getTaxes(sessionParameters.get("taxes")));// ** Optional ** you can pass empty array list

        // Set Shipping array list
        sdkSession.setShipping(DeserializationUtil.getShipping(sessionParameters.get("shipping")));// ** Optional ** you can pass empty array list

        // Post URL
        sdkSession.setPostURL(sessionParameters.get("postURL").toString());// ** Optional **

        // Payment Description
        sdkSession.setPaymentDescription(sessionParameters.get("paymentDescription").toString()); // ** Optional **

        // Payment Extra Info
        sdkSession.setPaymentMetadata(DeserializationUtil.getMetaData(sessionParameters.get("paymenMetaData")));// **Optional** you can pass empty array hashmap//

        // Payment Reference
        sdkSession.setPaymentReference(DeserializationUtil.getReference(sessionParameters.get("paymentReference"))); // **Optional**you can pass null

        // Payment Statement Descriptor
        sdkSession.setPaymentStatementDescriptor(sessionParameters.get("paymentStatementDescriptor").toString()); // **Optional**//

        // Enable or Disable Saving Card
        sdkSession.isUserAllowedToSaveCard((boolean) sessionParameters.get("isUserAllowedToSaveCard")); // ** Required you can pass boolean //


        // Enable or Disable 3DSecure
        sdkSession.isRequires3DSecure((boolean) sessionParameters.get("isRequires3DSecure"));

        // Set Receipt Settings [SMS - Email ]
        sdkSession.setReceiptSettings(DeserializationUtil.getReceipt(sessionParameters.get("receiptSettings"))); // **Optional** you can pass Receipt object or null

        // Set Authorize Action
        sdkSession.setAuthorizeAction(DeserializationUtil.getAuthorizeAction(sessionParameters.get("authorizeAction"))); // **Optional**you can pass AuthorizeAction object or null

        sdkSession.setDestination(DeserializationUtil.getDestinations(sessionParameters.get("destinations"))); //**Optional you can pass Destinations object or null //

        sdkSession.setMerchantID(sessionParameters.get("merchantID").toString()); // ** Optional ** you can pass  merchant id or null


        sdkSession.setCardType(DeserializationUtil.getCardType(sessionParameters.get("allowedCadTypes").toString())); //**Optional ** You can pass [CREDIT/DEBIT] id.

        sdkSession.setPaymentType(DeserializationUtil.getPaymentType(sessionParameters.get("paymentType").toString()));

        sdkSession.setDefaultCardHolderName(sessionParameters.get("cardHolderName").toString()); // ** Optional ** you can pass default CardHolderName of the user .So you don't need to type it.

        sdkSession.isUserAllowedToEnableCardHolderName((boolean) sessionParameters.get("editCardHolderName")); // **Optional** you can enable/ disable  default CardHolderName .

    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private void sendChargeResult(Charge charge, String paymentStatus, String trx_mode) {
        HashMap<String, String> resultMap = new HashMap<>();
        if (charge.getStatus() != null)
            resultMap.put("status", charge.getStatus().name());
        resultMap.put("description", charge.getDescription());
        resultMap.put("message", charge.getResponse().getMessage());
        resultMap.put("charge_id", charge.getId());
        if (charge.getCard() != null) {
            resultMap.put("card_first_six", charge.getCard().getFirstSix());
            resultMap.put("card_last_four", charge.getCard().getLast4());
            resultMap.put("card_object", charge.getCard().getObject());
            resultMap.put("card_brand", charge.getCard().getBrand());
            if (charge.getCard().getExpiry() != null) {
                resultMap.put("card_exp_month", charge.getCard().getExpiry().getMonth());
                resultMap.put("card_exp_year", charge.getCard().getExpiry().getYear());
            } else {
                resultMap.put("card_exp_month", charge.getCard().getExp_month());
                resultMap.put("card_exp_year", charge.getCard().getExp_year());
            }
        }
        if (charge.getAcquirer() != null) {
            resultMap.put("acquirer_id", charge.getAcquirer().getId());
            resultMap.put("acquirer_response_code", charge.getAcquirer().getResponse().getCode());
            resultMap.put("acquirer_response_message", charge.getAcquirer().getResponse().getMessage());
        }
        if (charge.getSource() != null) {
            resultMap.put("source_id", charge.getSource().getId());
            if (charge.getSource().getChannel() != null)
                resultMap.put("source_channel", charge.getSource().getChannel().name());
            resultMap.put("source_object", charge.getSource().getObject());
            resultMap.put("source_payment_type", charge.getSource().getPaymentType());
        }

        if (charge.getCustomer() != null) {
            resultMap.put("customer_id", charge.getCustomer().getIdentifier());
            resultMap.put("customer_first_name", charge.getCustomer().getFirstName());
            resultMap.put("customer_middle_name", charge.getCustomer().getMiddleName());
            resultMap.put("customer_last_name", charge.getCustomer().getLastName());
            resultMap.put("customer_email", charge.getCustomer().getEmail());
        }
        
        resultMap.put("sdk_result", paymentStatus);
        resultMap.put("trx_mode", trx_mode);
        resultMap.put("id", charge.getId());
        System.out.println("resultMap on success = " + resultMap);
        System.out.println("callback on success = " + callback);
        callback.onSuccess(resultMap);
        callback = null;
    }

    private void sendTokenResult(Token token, String paymentStatus, boolean saveCard) {
        HashMap<String, String> resultMap = new HashMap<>();

        resultMap.put("token", token.getId());
        resultMap.put("token_currency", token.getCurrency());
        if (token.getCard() != null) {
            resultMap.put("card_first_six", token.getCard().getFirstSix());
            resultMap.put("card_last_four", token.getCard().getLastFour());
            resultMap.put("card_object", token.getCard().getObject());
            resultMap.put("card_exp_month", "" + token.getCard().getExpirationYear());
            resultMap.put("card_exp_year", "" + token.getCard().getExpirationMonth());
        }
        resultMap.put("save_card", String.valueOf(saveCard));
        resultMap.put("sdk_result", paymentStatus);
        resultMap.put("trx_mode", "TOKENIZE");

        callback.onSuccess(resultMap);
        callback = null;
    }

   

    private void sendSDKError(int errorCode, String errorMessage, String errorBody) {
        HashMap<String, String> resultMap = new HashMap<>();
        resultMap.put("sdk_result", "SDK_ERROR");
        resultMap.put("sdk_error_code", String.valueOf(errorCode));
        resultMap.put("sdk_error_message", errorMessage);
        resultMap.put("sdk_error_description", errorBody);
        callback.onFailure(resultMap);
        callback = null;
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @Override
    public void paymentSucceed(@NonNull Charge charge) {
        System.out.println("paymentSucceed = " + charge.getCard() + " charge information" + charge.getId()+"getTransactionMode");
        sendChargeResult(charge, "SUCCESS", "CHARGE");
       
        Toast.makeText(activity, charge.getId(), Toast.LENGTH_SHORT).show();
    }

    @Override
    public void paymentFailed(@Nullable Charge charge) {
        sendChargeResult(charge, "FAILED", "CHARGE");
    }

    @Override
    public void authorizationSucceed(@NonNull Authorize authorize) {
        sendChargeResult(authorize, "SUCCESS", "AUTHORIZE");
    }

    @Override
    public void authorizationFailed(Authorize authorize) {
        sendChargeResult(authorize, "FAILED", "AUTHORIZE");
    }

    @Override
    public void cardSaved(@NonNull Charge charge) {
        System.out.println("charge in save card"+charge);
        sendSavedCardResult(charge, "SUCCESS", "SAVE_CARD");
    }

    @Override
    public void cardSavingFailed(@NonNull Charge charge) {
        sendSavedCardFailure(charge, "FAILED", "SAVE_CARD");
    }

    @Override
    public void cardTokenizedSuccessfully(@NonNull Token token) {
        // sendTokenResult(token, "SUCCESS");
    }

    @Override
    public void savedCardsList(@NonNull CardsList cardsList) {
    }

    @Override
    public void sdkError(@Nullable GoSellError goSellError) {
        if (goSellError != null) {
            System.out.println("SDK Process Error : " + goSellError.getErrorBody());
            System.out.println("SDK Process Error : " + goSellError.getErrorMessage());
            System.out.println("SDK Process Error : " + goSellError.getErrorCode());
        }

        sendSDKError(goSellError.getErrorCode(), goSellError.getErrorMessage(), goSellError.getErrorBody());
        Toast.makeText(activity.getBaseContext(), goSellError.getErrorMessage(), Toast.LENGTH_LONG).show();
    }

    @Override
    public void sessionIsStarting() {
        System.out.println(" Session Is Starting.....");
    }

    @Override
    public void sessionHasStarted() {
        System.out.println(" Session Has Started .......");
    }

    @Override
    public void sessionCancelled() {
        Log.d("MainActivity", "Session Cancelled.........");
        HashMap<String, String> resultMap = new HashMap<>();
        resultMap.put("sdk_result", "CANCELLED");
        callback.onFailure(resultMap);
        callback = null;
    }

    @Override
    public void sessionFailedToStart() {
        Log.d("MainActivity", "Session Failed to start.........");
    }

    @Override
    public void invalidCardDetails() {
        System.out.println(" Card details are invalid....");
    }

    @Override
    public void backendUnknownError(String message) {
        System.out.println("Backend Un-Known error.... : " + message);
        sendSDKError(Constants.ERROR_CODE_BACKEND_UNKNOWN_ERROR, message, message);
    }

    @Override
    public void invalidTransactionMode() {
        System.out.println(" invalidTransactionMode  ......");
        sendSDKError(Constants.ERROR_CODE_INVALID_TRX_MODE, "invalidTransactionMode", "invalidTransactionMode");

    }

    @Override
    public void invalidCustomerID() {
        System.out.println("Invalid Customer ID .......");
        sendSDKError(Constants.ERROR_CODE_INVALID_CUSTOMER_ID, "Invalid Customer ID ", "Invalid Customer ID ");
    }

    @Override
    public void userEnabledSaveCardOption(boolean saveCardEnabled) {
        System.out.println("userEnabledSaveCardOption :  " + saveCardEnabled);
    }

    @Override
    public void cardTokenizedSuccessfully(@NonNull Token token, boolean saveCardEnabled) {
        sendTokenResult(token, "SUCCESS", saveCardEnabled);
    }

    private void sendSavedCardResult(Charge charge, String paymentStatus, String trx_mode){
        HashMap<String, String> resultMap = new HashMap<>();
        if (charge instanceof SaveCard) {
            System.out.println("Card  are Saved Succeeded : first six digits : " + ((SaveCard) charge).getCard().getFirstSix() + "  last four :" + ((SaveCard) charge).getCard().getLast4());
        }
        resultMap.put("card_first_six", ((SaveCard) charge).getCard().getFirstSix());
        resultMap.put("card_last_four",((SaveCard) charge).getCard().getLast4());
        resultMap.put("card_status",charge.getStatus().toString());
        resultMap.put("card_brand",charge.getCard().getBrand());
        resultMap.put("customer_id",charge.getCustomer().getIdentifier());
        resultMap.put("card_message", charge.getResponse().getMessage());
        resultMap.put("sdk_result", paymentStatus);
        resultMap.put("trx_mode", trx_mode);
        resultMap.put("charge_id", charge.getId());
        callback.onSuccess(resultMap);
        callback = null;
        System.out.println("Card Saved is Succeeded : first six digits : " + ((SaveCard) charge).getCard().getFirstSix() + "  last four :" + ((SaveCard) charge).getCard().getLast4());
    }

    private void sendSavedCardFailure(Charge charge, String paymentStatus, String trx_mode){
        HashMap<String, String> resultMap = new HashMap<>();
        if (charge instanceof SaveCard) {
            resultMap.put("card_status", charge.getStatus().toString());
            resultMap.put("card_description", charge.getDescription());
            resultMap.put("card_message", charge.getResponse().getMessage());
            resultMap.put("sdk_result", paymentStatus);
            resultMap.put("trx_mode", trx_mode);
            callback.onFailure(resultMap);
            callback = null;
            System.out.println("Card Saved is failed " + charge.getResponse().getMessage());
        }
    }

}