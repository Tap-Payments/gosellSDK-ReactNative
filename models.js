const Languages = {
    EN: 'en',
    AR: 'ar',
};

const PaymentTypes = {
    ALL: 'PaymentType.ALL',
    CARD: 'PaymentType.CARD',
    WEB: 'PaymentType.WEB',
    APPLE_PAY: 'PaymentType.APPLE_PAY'
}


const AllowedCadTypes = {
    CREDIT: 'CREDIT',
    DEBIT: 'DEBIT',
    ALL: 'ALL'
}

const UiDisplayModes = {
    FOLLOW_DEVICE: 'FOLLOW_DEVICE',
    LIGHT: 'LIGHT',
    DARK: 'DARK'
}

const TrxMode = {
    PURCHASE: 'TransactionMode.PURCHASE',
    AUTHORIZE_CAPTURE: 'TransactionMode.AUTHORIZE_CAPTURE',
    SAVE_CARD: 'TransactionMode.SAVE_CARD',
    TOKENIZE_CARD: 'TransactionMode.TOKENIZE_CARD'
}

const SDKMode = {
    Sandbox: 'SDKMode.Sandbox',
    Production: 'SDKMode.Production'
}


const Listener = {
    paymentInit: 'paymentInit',
    applePayCancelled: 'applePayCancelled',
}

const SDKAppearanceMode = {
    Fullscreen: 1,
    Windowed: 0,
}


module.exports = {
    Languages: Languages,
    PaymentTypes: PaymentTypes,
    AllowedCadTypes: AllowedCadTypes,
    TrxMode: TrxMode,
    SDKMode: SDKMode,
    UiDisplayModes: UiDisplayModes,
    Listener: Listener,
    SDKAppearanceMode: SDKAppearanceMode
}
