export type Languages = {
  EN: 'en';
  AR: 'ar';
};

export type PaymentTypes = {
  ALL: 'ALL';
  CARD: 'CARD';
  WEB: 'WEB';
  APPLE_PAY: 'APPLE_PAY';
};

export type AllowedCadTypes = {
  CREDIT: 'CREDIT';
  DEBIT: 'DEBIT';
  ALL: 'ALL';
};

export type UiDisplayModes = {
  FOLLOW_DEVICE: 'FOLLOW_DEVICE';
  LIGHT: 'LIGHT';
  DARK: 'DARK';
};

export type TrxMode = {
  PURCHASE: 'PURCHASE';
  AUTHORIZE_CAPTURE: 'AUTHORIZE_CAPTURE';
  SAVE_CARD: 'SAVE_CARD';
  TOKENIZE_CARD: 'TOKENIZE_CARD';
};

export type SDKMode = {
  Sandbox: 'Sandbox';
  Production: 'Production';
};

export type Listener = {
  paymentInit: 'paymentInit';
};

export type SDKAppearanceMode = {
  Fullscreen: 1;
  Windowed: 0;
};
