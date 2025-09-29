declare module '@tap-payments/gosell-sdk-react-native' {
  import {NativeEventEmitter, EmitterSubscription} from 'react-native';

  // Models and Enums
  export interface Languages {
    EN: 'en';
    AR: 'ar';
  }

  export interface PaymentTypes {
    ALL: 'PaymentType.ALL';
    CARD: 'PaymentType.CARD';
    WEB: 'PaymentType.WEB';
    APPLE_PAY: 'PaymentType.APPLE_PAY';
  }

  export interface AllowedCadTypes {
    CREDIT: 'CREDIT';
    DEBIT: 'DEBIT';
    ALL: 'ALL';
  }

  export interface UiDisplayModes {
    FOLLOW_DEVICE: 'FOLLOW_DEVICE';
    LIGHT: 'LIGHT';
    DARK: 'DARK';
  }

  export interface TrxMode {
    PURCHASE: 'TransactionMode.PURCHASE';
    AUTHORIZE_CAPTURE: 'TransactionMode.AUTHORIZE_CAPTURE';
    SAVE_CARD: 'TransactionMode.SAVE_CARD';
    TOKENIZE_CARD: 'TransactionMode.TOKENIZE_CARD';
  }

  export interface SDKMode {
    Sandbox: 'SDKMode.Sandbox';
    Production: 'SDKMode.Production';
  }

  export interface Listener {
    paymentInit: 'paymentInit';
    applePayCancelled: 'applePayCancelled';
  }

  export interface SDKAppearanceMode {
    Fullscreen: 1;
    Windowed: 0;
  }

  // Configuration Types
  export interface Customer {
    isdNumber?: string;
    number?: string;
    customerId?: string;
    first_name?: string;
    middle_name?: string;
    last_name?: string;
    email?: string;
  }

  export interface PaymentReference {
    track?: string;
    payment?: string;
    gateway?: string;
    acquirer?: string;
    transaction?: string;
    order?: string;
    gosellID?: string | null;
  }

  export interface AppCredentials {
    production_secrete_key: string;
    language: string;
    sandbox_secrete_key: string;
    bundleID: string;
  }

  export interface Shipping {
    name: string;
    description: string;
    amount: number;
  }

  export interface Discount {
    type: string;
    value: number;
    maximum_fee: number;
    minimum_fee: number;
  }

  export interface Quantity {
    value: number;
  }

  export interface Tax {
    name: string;
    description: string;
    amount: {
      type: string;
      value: number;
      maximum_fee: number;
      minimum_fee: number;
    };
  }

  export interface PaymentItem {
    amount_per_unit: number;
    description: string;
    discount?: Discount;
    name: string;
    quantity: Quantity;
    taxes?: Tax[];
    total_amount: number;
  }

  export interface AuthorizeAction {
    timeInHours: number;
    time: number;
    type: string;
  }

  export interface ReceiptSettings {
    id: string | null;
    email: boolean;
    sms: boolean;
  }

  export interface SessionParameters {
    paymentStatementDescriptor?: string;
    transactionCurrency: string;
    isUserAllowedToSaveCard?: boolean;
    paymentType: string;
    amount: string;
    shipping?: Shipping[];
    allowedCadTypes?: string;
    paymentitems?: PaymentItem[];
    paymenMetaData?: Record<string, any>;
    applePayMerchantID?: string;
    authorizeAction?: AuthorizeAction;
    cardHolderName?: string;
    editCardHolderName?: boolean;
    postURL?: string;
    paymentDescription?: string;
    destinations?: string | null;
    trxMode: string;
    taxes?: Tax[];
    merchantID?: string;
    SDKMode: string;
    customer?: Customer;
    isRequires3DSecure?: boolean;
    receiptSettings?: ReceiptSettings;
    allowsToSaveSameCardMoreThanOnce?: boolean;
    paymentReference?: PaymentReference;
    uiDisplayMode?: string;
  }

  export interface SDKConfiguration {
    appCredentials: AppCredentials;
    sessionParameters: SessionParameters;
  }

  // Result Types
  export interface SDKResult {
    trx_mode: 'CHARGE' | 'AUTHORIZE' | 'SAVE_CARD' | 'TOKENIZE';
    sdk_result: 'SUCCESS' | 'FAILED' | 'SDK_ERROR' | 'NOT_IMPLEMENTED';
    sdk_error_code?: string;
    sdk_error_message?: string;
    sdk_error_description?: string;
    token?: string;
    [key: string]: any;
  }

  export type ResultCallback = (error: any, status: SDKResult) => void;

  // SDK Interface
  export interface GoSellSDK {
    startPayment(
      configuration: SDKConfiguration,
      timeoutInMilliseconds: number,
      callback: ResultCallback,
    ): void;
  }

  // Models Interface
  export interface GoSellSDKModels {
    Languages: Languages;
    PaymentTypes: PaymentTypes;
    AllowedCadTypes: AllowedCadTypes;
    TrxMode: TrxMode;
    SDKMode: SDKMode;
    UiDisplayModes: UiDisplayModes;
    Listener: Listener;
    SDKAppearanceMode: SDKAppearanceMode;
  }

  // Listener Interface
  export interface GoSellListener extends NativeEventEmitter {
    addListener(eventName: string, callback: (data: any) => void): EmitterSubscription;
  }

  // Main Module Interface
  export interface RNGoSell {
    goSellSDK: GoSellSDK;
    goSellSDKModels: GoSellSDKModels;
    goSellListener: GoSellListener;
  }

  const RNGoSell: RNGoSell;
  export default RNGoSell;
}
