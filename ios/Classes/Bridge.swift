//
//  Bridge.swift
//  gosellSDKReactNative
//
//  Created by Kareem Ahmed on 9/29/20.
//

import Foundation
import UIKit
import goSellSDK
import TapCardVlidatorKit_iOS
import CardIO
import TapApplicationV2

@objc(Bridge)
public class Bridge: NSObject {
    let session = Session()
    public var argsSessionParameters:[String:Any]?
    public var argsAppCredentials:[String:String]?
    var reactResult: RCTResponseSenderBlock?
    var paymentInit: ((_ charge: [String: Any]) -> Void)?
    var argsDataSource:[String:Any]?{
        didSet{
            argsSessionParameters = argsDataSource?["sessionParameters"] as? [String : Any]
            argsAppCredentials = argsDataSource?["appCredentials"] as? [String : String]
        }
    }
    
    @objc public func startPayment(_ arguments: NSDictionary, timeout: Int, callback: @escaping RCTResponseSenderBlock, paymentInitCallback: @escaping (_ chargeId: [String: Any]) -> Void) {
        argsDataSource = arguments as? [String: Any]
        print("arguments: \(arguments)")
        GoSellSDK.reset()
        let secretKey = SecretKey(sandbox: sandBoxSecretKey, production: productionSecretKey)
        GoSellSDK.secretKey = secretKey
        GoSellSDK.mode = sdkMode
        GoSellSDK.language = sdkLang
        session.delegate = self
        session.dataSource = self
        session.appearance = self
        session.start()
        reactResult = callback
        paymentInit = paymentInitCallback
        if timeout > 0 {
            let timeoutSeconds = TimeInterval(timeout / 1000)
            Timer.scheduledTimer(timeInterval: timeoutSeconds, target: self, selector: #selector(terminateSession), userInfo: nil, repeats: false)
        }
    }
    
    @objc func terminateSession() {
        print("inside terminate session swift")
        session.stop()
    }
    
    //  @objc
    //  static func requiresMainQueueSetup() -> Bool {
    //	return true
    //  }
}

extension Bridge: SessionDataSource {
    public var customer: Customer?{
        if let customerString:[String: Any] = argsSessionParameters?["customer"] as? [String:Any] {
            do {
                if let customerIdentifier = customerString["customerId"] as? String, !customerIdentifier.isEmpty,
                   customerIdentifier.lowercased() != "null",customerIdentifier.lowercased() != "nil" {
                    return try Customer.init(identifier: customerIdentifier)
                } else {
                    if let customerDictionary = customerString as? [String: String] {
                        return try Customer.init(emailAddress: EmailAddress(emailAddressString: customerDictionary["email"] ?? ""), phoneNumber: PhoneNumber(isdNumber: customerDictionary["isdNumber"] ?? "", phoneNumber: customerDictionary["number"] ?? ""), firstName: customerDictionary["first_name"] ?? "", middleName: customerDictionary["middle_name"] ?? "", lastName: customerDictionary["last_name"] ?? "")
                    } else {
                        throw NSError()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public var cardHolderName: String?{
        if let cardHolderNameValue:String = argsSessionParameters?["cardHolderName"] as? String {
            return cardHolderNameValue
        }
        return ""
    }
    
    internal var isScanButtonVisible: Bool {
        return setCardScannerIconVisible
    }
    
    public var setCardScannerIconVisible: Bool {
#if canImport(CardIO)
        return CardIOUtilities.canReadCardWithCamera() && TapApplicationPlistInfo.shared.hasUsageDescription(for: .camera)
#else
        return false
#endif
    }
    
    public var cardHolderNameIsEditable: Bool{
        if let cardHolderNameIsEditableValue:Bool = argsSessionParameters?["editCardHolderName"] as? Bool {
            return cardHolderNameIsEditableValue
        }
        return true
    }
    
    
    
    public var currency: Currency? {
        if let currencyString:String = argsSessionParameters?["transactionCurrency"] as? String {
            return .with(isoCode: currencyString)
        }
        return .with(isoCode: "KWD")
    }
    
    
    public var merchantID: String?
    {
        guard let merchantIDString:String = argsSessionParameters?["merchantID"] as? String else {
            return ""
        }
        return merchantIDString
    }
    public var sandBoxSecretKey: String{
        if let sandBoxSecretKeyString:String = argsAppCredentials?["sandbox_secrete_key"] {
            return sandBoxSecretKeyString
        }
        return ""
    }
    public var sdkLang: String{
        if let sdkLangString:String = argsAppCredentials?["language"] {
            return sdkLangString
        }
        return "en"
    }
    public var productionSecretKey: String{
        if let productionSecretKeyString:String = argsAppCredentials?["production_secrete_key"] {
            return productionSecretKeyString
        }
        return ""
    }
    public var isSaveCardSwitchOnByDefault: Bool{
        if let isUserAllowedToSaveCard:Bool = argsSessionParameters?["isUserAllowedToSaveCard"] as? Bool {
            return isUserAllowedToSaveCard
        }
        return false
    }
    public var items: [PaymentItem]? {
        if var paymentItemsArray:[[String: Any]] = argsSessionParameters?["paymentitems"] as? [[String: Any]] {
            
            for (index, var item) in paymentItemsArray.enumerated() {
                guard var quantityDict:[String:Any] = item["quantity"] as? [String:Any] else {
                    return nil
                }
                quantityDict["measurement_group"] = "mass"
                quantityDict["measurement_unit"] = "kilograms"
                item["quantity"] = quantityDict
                paymentItemsArray[index] = item
            }
            
            let pitems:[PaymentItem] = paymentItemsArray.map{ try! PaymentItem.init(dictionary: $0) }
            return pitems
        }
        return nil
    }
    public var amount: Decimal {
        if let amountString:String = argsSessionParameters?["amount"] as? String,
           let amountDecimal: Decimal = Decimal(string:amountString) {
            return amountDecimal
        }
        return 0
    }
    public var mode: TransactionMode{
        if let modeString:String = argsSessionParameters?["trxMode"] as? String {
            let modeComponents: [String] = modeString.components(separatedBy: ".")
            if modeComponents.count == 2 {
                do {
                    let data = try JSONEncoder().encode(modeComponents[1])
                    let decoder = JSONDecoder()
                    let transactionMode:TransactionMode = try decoder.decode(TransactionMode.self, from: data)
                    return transactionMode
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return TransactionMode.invalidTransactionMode
    }
    public var applePayMerchantID: String
    {
        if let applePayMerchantIDString:String = argsSessionParameters?["applePayMerchantID"] as? String {
            return applePayMerchantIDString
        }
        return ""
    }
    public var sdkMode: SDKMode {
        if let sdkModeString:String = argsSessionParameters?["SDKMode"] as? String {
            let modeComponents: [String] = sdkModeString.components(separatedBy: ".")
            if modeComponents.count == 2 {
                return (modeComponents[1].lowercased() == "sandbox") ? .sandbox : .production
            }
        }
        return .sandbox
    }
    public var postURL: URL? {
        if let postUrlString:String = argsSessionParameters?["postURL"] as? String,
           let postURL:URL = URL(string: postUrlString) {
            return postURL
        }
        return nil
    }
    public var require3DSecure: Bool {
        if let require3DS:Bool = argsSessionParameters?["isRequires3DSecure"] as? Bool {
            return require3DS
        }
        return false
    }
    public var paymentDescription: String? {
        if let paymentDescriptionString:String = argsSessionParameters?["paymentDescription"] as? String {
            return paymentDescriptionString
        }
        return nil
    }
    public var taxes: [Tax]? {
        if let taxesString:[[String: Any]] = argsSessionParameters?["taxes"] as? [[String: Any]] {
            let taxesItems:[Tax] = taxesString.map{ try! Tax.init(dictionary: $0) }
            return taxesItems
        }
        return nil
    }
    public var paymentReference: Reference? {
        if let paymentReferenceString:[String: Any] = argsSessionParameters?["paymentReference"] as? [String: Any] {
            let paymentReferenceItems:Reference = try! Reference.init(dictionary: paymentReferenceString)
            return paymentReferenceItems
        }
        return nil
    }
    public var receiptSettings: Receipt? {
        if let receiptSettingsString:String = argsSessionParameters?["receiptSettings"] as? String {
            if let data = receiptSettingsString.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let receiptSettingsObject:Receipt = try decoder.decode(Receipt.self, from: data)
                    return receiptSettingsObject
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return Receipt(email: false, sms: false)
    }
    public var authorizeAction: AuthorizeAction {
        if let authorizeActionDictionary:[String: Any] = argsSessionParameters?["authorizeAction"] as? [String: Any] {
            do {
                let authorizeActionObject:AuthorizeAction = try AuthorizeAction(dictionary: authorizeActionDictionary)
                return authorizeActionObject
            } catch {
                print(error.localizedDescription)
            }
        }
        return .void(after: 0)
    }
    public var destinations: DestinationGroup? {
        if let destinationsGroupString: [String : Any] = argsSessionParameters?["destinations"] as?  [String : Any] {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: destinationsGroupString, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let destinationsItems: DestinationGroup = try decoder.decode(DestinationGroup.self, from: jsonData)
                return destinationsItems
            } catch  {
                return nil
                print(error.localizedDescription)
            }
        }
        return nil
    }
    public var shipping: [Shipping]? {
        if let shippingString: [[String: Any]] = argsSessionParameters?["shipping"] as? [[String: Any]] {
            print("shippingString: \(shippingString)")
            
            let items:[Shipping] = shippingString.map{ try! Shipping.init(dictionary: $0) }
            return items
        }
        return nil
    }
    
    public var supportedPaymentMethods: [String] {
        if let paymentTypeString:[String] = argsSessionParameters?["supportedPaymentMethods"] as? [String] {
            return paymentTypeString
        }else {
            return []
        }
    }
    
    public var paymentType: PaymentType {
        if let paymentTypeString:String = argsSessionParameters?["paymentType"] as? String {
            let paymentTypeComponents: [String] = paymentTypeString.components(separatedBy: ".")
            if paymentTypeComponents.count == 2 {
                do {
                    let data = try JSONEncoder().encode(paymentTypeComponents[1].lowercased())
                    let decoder = JSONDecoder()
                    let paymentTypeMode:PaymentType = try decoder.decode(PaymentType.self, from: data)
                    return paymentTypeMode
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return PaymentType.all
    }
    
    public var allowedCadTypes: [CardType]? {
        if let cardTypeString:String = argsSessionParameters?["allowedCadTypes"] as? String {
            let cardTypeComponents: [String] = cardTypeString.components(separatedBy: ".")
            if cardTypeComponents.count == 2 {
                var cardType:cardTypes = .All
                cardTypes.allCases.forEach{
                    if $0.description.lowercased() == cardTypeComponents[1].lowercased() {
                        cardType = $0
                    }
                }
                if cardType == .All {
                    return [CardType(cardType: .All)]
                }else
                {
                    return [CardType(cardType: cardType)]
                }
            }
        }
        return [CardType(cardType: .All)]
    }
    
    public var uiModeDisplay: UIModeDisplayEnum {
        if let modeDisplayString = argsSessionParameters?["uiDisplayMode"] as? String {
            var finalMode: UIModeDisplayEnum = .followDevice
            switch modeDisplayString.uppercased() {
            case "LIGHT": finalMode = .light
            case "DARK": finalMode = .dark
            case "FOLLOW_DEVICE": finalMode = .followDevice
            default:
                finalMode = .followDevice
            }
            return finalMode
        }
        return .followDevice
    }
}

extension Bridge: SessionDelegate {
    
    public func applePaymentTokenizationFailed(_ error: String, on session: SessionProtocol) {
        var resultMap:[String:Any] = [:]
        resultMap["sdk_result"] = "SDK_ERROR"
        resultMap["trx_mode"] = "TOKENIZE"
        resultMap["sdk_error_code"] = ""//error.type
        resultMap["sdk_error_message"] = error
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        if let reactResult = reactResult {
            reactResult([NSNull(), resultMap])
        }
    }
    
    public func applePaymentTokenizationSucceeded(_ token: Token, on session: SessionProtocol) {
        var resultMap:[String:Any] = [:]
        resultMap["token"] = token.identifier
        if let tokenDataSource = session.dataSource,
           let tokenCurrency:Currency = tokenDataSource.currency as? Currency {
            resultMap["token_currency"] = tokenCurrency.isoCode
        }
        resultMap["card_first_six"] = token.card.binNumber
        resultMap["card_last_four"] = token.card.lastFourDigits
        resultMap["card_object"] = token.card.object
        resultMap["card_exp_month"] = token.card.expirationMonth
        resultMap["card_exp_year"] = token.card.expirationYear
        resultMap["sdk_result"] = "SUCCESS"
        resultMap["trx_mode"] = "TOKENIZE"
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        if token.card.issuer != nil {
            resultMap["issuer"] =  token.card.issuer?.dictionary
        }
        
        //          result.success(resultMap)
        if let reactResult = reactResult {
            reactResult([NSNull(), resultMap])
        }
    }
    
    public func paymentInitiated(with charge: Charge?, on session: SessionProtocol) {
        guard let paymentInit, let charge = charge else {
            return
        }
        var resultMap = [String: Any]()
        resultMap["status"] = charge.status.textValue
        resultMap["charge_id"] = charge.identifier
        resultMap["description"] = charge.descriptionText
        resultMap["message"] = charge.response?.message
        
        if let card = charge.card {
            resultMap["card_first_six"] = card.firstSixDigits
            resultMap["card_last_four"] = card.lastFourDigits
            resultMap["card_object"] = card.object
            //            let cardBrand = CardBrand(rawValue: card.brand.rawValue)
            resultMap["card_brand"] = card.brand.textValue
            resultMap["card_exp_month"] = card.expirationMonth
            resultMap["card_exp_year"] = card.expirationYear
        }
        
        resultMap["customer_id"] = charge.customer.identifier ?? ""
        resultMap["customer_first_name"] = charge.customer.firstName ?? ""
        resultMap["customer_middle_name"] = charge.customer.middleName ?? ""
        resultMap["customer_last_name"] = charge.customer.lastName ?? ""
        
        if let emailAddress = charge.customer.emailAddress {
            resultMap["customer_email"] = emailAddress.value
        }
        
        if let acquirer = charge.acquirer {
            if let response = acquirer.response {
                resultMap["acquirer_id"] = ""
                resultMap["acquirer_response_code"] = response.code
                resultMap["acquirer_response_message"] = response.message
            }
            
        }
        
        resultMap["source_id"] = charge.source.identifier
        resultMap["source_channel"] = charge.source.channel.textValue
        resultMap["source_object"] = charge.source.object.textValue
        resultMap["source_payment_type"] = charge.source.paymentType.textValue
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        resultMap["sdk_result"] = "SUCCESS"
        resultMap["trx_mode"] = "CHARGE"
        print("------&&&&-----------")
        print(resultMap)
        print("------&&&&-----------")
        paymentInit(resultMap)
    }
    
    public func paymentSucceed(_ charge: Charge, on session: SessionProtocol) {
        print(charge)
        
        var resultMap = [String: Any]()
        resultMap["status"] = charge.status.textValue
        resultMap["charge_id"] = charge.identifier
        resultMap["description"] = charge.descriptionText
        resultMap["message"] = charge.response?.message
        if let receiptSettings = charge.receiptSettings {
            var receiptSettingsMap = [String: Any]()
            receiptSettingsMap["id"] = charge.receiptSettings?.identifier ?? ""
            receiptSettingsMap["email"] = charge.receiptSettings?.email ?? ""
            receiptSettingsMap["sms"] = charge.receiptSettings?.sms ?? ""
            resultMap["receipt_settings"] = receiptSettingsMap
        }
        if let card = charge.card {
            resultMap["card_first_six"] = card.firstSixDigits
            resultMap["card_last_four"] = card.lastFourDigits
            resultMap["card_object"] = card.object
            //            let cardBrand = CardBrand(rawValue: card.brand.rawValue)
            resultMap["card_brand"] = card.brand.textValue
            resultMap["card_exp_month"] = card.expirationMonth
            resultMap["card_exp_year"] = card.expirationYear
        }
        
        resultMap["customer_id"] = charge.customer.identifier ?? ""
        resultMap["customer_first_name"] = charge.customer.firstName ?? ""
        resultMap["customer_middle_name"] = charge.customer.middleName ?? ""
        resultMap["customer_last_name"] = charge.customer.lastName ?? ""
        
        if let emailAddress = charge.customer.emailAddress {
            resultMap["customer_email"] = emailAddress.value
        }
        
        if let acquirer = charge.acquirer {
            if let response = acquirer.response {
                resultMap["acquirer_id"] = ""
                resultMap["acquirer_response_code"] = response.code
                resultMap["acquirer_response_message"] = response.message
            }
            
        }
        
        resultMap["source_id"] = charge.source.identifier
        resultMap["source_channel"] = charge.source.channel.textValue
        resultMap["source_object"] = charge.source.object.textValue
        resultMap["source_payment_type"] = charge.source.paymentType.textValue
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        resultMap["sdk_result"] = "SUCCESS"
        resultMap["trx_mode"] = "CHARGE"
        
        //pendingResult.success(resultMap);
        if let reactResult = reactResult {
            reactResult([NSNull(), resultMap])
        }
    }
    
    public func paymentFailed(with charge: Charge?, error: TapSDKError?, on session: SessionProtocol) {
        
        var resultMap = [String: Any]()
        if let charge = charge {
            resultMap["status"] = charge.status.textValue
            resultMap["charge_id"] = charge.identifier
            resultMap["description"] = charge.descriptionText
            resultMap["message"] = charge.response?.message
            
            if let card = charge.card {
                resultMap["card_first_six"] = card.firstSixDigits
                resultMap["card_last_four"] = card.lastFourDigits
                resultMap["card_object"] = card.object
                resultMap["card_brand"] = card.brand.textValue
                resultMap["card_exp_month"] = card.expirationMonth
                resultMap["card_exp_year"] = card.expirationYear
            }
            
            if let acquirer = charge.acquirer {
                if let response = acquirer.response {
                    resultMap["acquirer_id"] = ""
                    resultMap["acquirer_response_code"] = response.code
                    resultMap["acquirer_response_message"] = response.message
                }
                
            }
            
            resultMap["source_id"] = charge.source.identifier
            resultMap["source_channel"] = charge.source.channel.textValue
            resultMap["source_object"] = charge.source.object.textValue
            resultMap["source_payment_type"] = charge.source.paymentType.textValue
            
        }
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        resultMap["sdk_result"] = "FAILED"
        resultMap["trx_mode"] = "CHARGE"
        
        if let reactResult = reactResult {
            reactResult([NSNull(), resultMap])
        }
    }
    
    // MARK: Authorize
    public func authorizationSucceed(_ authorize: Authorize, on session: SessionProtocol) {
        print(authorize)
        
        var resultMap = [String: Any]()
        resultMap["status"] = authorize.status.textValue
        resultMap["charge_id"] = authorize.identifier
        resultMap["description"] = authorize.descriptionText
        resultMap["message"] = authorize.response?.message
        
        if let card = authorize.card {
            resultMap["card_first_six"] = card.firstSixDigits
            resultMap["card_last_four"] = card.lastFourDigits
            resultMap["card_object"] = card.object
            //            let cardBrand = CardBrand(rawValue: card.brand.rawValue)
            resultMap["card_brand"] = card.brand.textValue
            resultMap["card_exp_month"] = card.expirationMonth
            resultMap["card_exp_year"] = card.expirationYear
        }
        
        if let acquirer = authorize.acquirer {
            if let response = acquirer.response {
                resultMap["acquirer_id"] = ""
                resultMap["acquirer_response_code"] = response.code
                resultMap["acquirer_response_message"] = response.message
            }
            
        }
        
        resultMap["source_id"] = authorize.source.identifier
        resultMap["source_channel"] = authorize.source.channel.textValue
        resultMap["source_object"] = authorize.source.object.textValue
        resultMap["source_payment_type"] = authorize.source.paymentType.textValue
        
        resultMap["sdk_result"] = "SUCCESS"
        resultMap["trx_mode"] = "AUTHORIZE_CAPTURE"
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        //pendingResult.success(resultMap);
        if let reactResult = reactResult {
            reactResult([NSNull(), resultMap])
        }
    }
    
    public func authorizationFailed(with authorize: Authorize?, error: TapSDKError?, on session: SessionProtocol) {
        
        var resultMap = [String: Any]()
        if let authorize = authorize {
            resultMap["status"] = authorize.status.textValue
            resultMap["charge_id"] = authorize.identifier
            resultMap["description"] = authorize.descriptionText
            resultMap["message"] = authorize.response?.message
            
            if let card = authorize.card {
                resultMap["card_first_six"] = card.firstSixDigits
                resultMap["card_last_four"] = card.lastFourDigits
                resultMap["card_object"] = card.object
                resultMap["card_brand"] = card.brand.textValue
                resultMap["card_exp_month"] = card.expirationMonth
                resultMap["card_exp_year"] = card.expirationYear
            }
            
            if let acquirer = authorize.acquirer {
                if let response = acquirer.response {
                    resultMap["acquirer_id"] = ""
                    resultMap["acquirer_response_code"] = response.code
                    resultMap["acquirer_response_message"] = response.message
                }
                
            }
            
            resultMap["source_id"] = authorize.source.identifier
            resultMap["source_channel"] = authorize.source.channel.textValue
            resultMap["source_object"] = authorize.source.object.textValue
            resultMap["source_payment_type"] = authorize.source.paymentType.textValue
        }
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        resultMap["sdk_result"] = "FAILED"
        resultMap["trx_mode"] = "AUTHORIZE_CAPTURE"
        
        if let reactResult = reactResult {
            reactResult([NSNull(), resultMap])
        }
    }
    
    public func sessionCancelled(_ session: SessionProtocol) {
        var resultMap:[String:Any] = [:]
        resultMap["sdk_result"] = "CANCELLED"
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        if let reactResult = reactResult {
            reactResult([NSNull(), resultMap])
        }
    }
    
    
    
    
    public func cardTokenized(_ token: Token, on session: SessionProtocol, customerRequestedToSaveTheCard saveCard: Bool) {
        var resultMap:[String:Any] = [:]
        resultMap["token"] = token.identifier
        if let tokenDataSource = session.dataSource,
           let tokenCurrency:Currency = tokenDataSource.currency as? Currency {
            resultMap["token_currency"] = tokenCurrency.isoCode
        }
        resultMap["card_first_six"] = token.card.binNumber
        resultMap["card_last_four"] = token.card.lastFourDigits
        resultMap["card_object"] = token.card.object
        resultMap["card_exp_month"] = token.card.expirationMonth
        resultMap["card_exp_year"] = token.card.expirationYear
        resultMap["save_card"] = saveCard
        resultMap["sdk_result"] = "SUCCESS"
        resultMap["trx_mode"] = "TOKENIZE"
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        if token.card.issuer != nil {
            resultMap["issuer"] =  token.card.issuer?.dictionary
        }
        
        //          result.success(resultMap)
        if let reactResult = reactResult {
            reactResult([NSNull(), resultMap])
        }
        
    }
    public func cardTokenizationFailed(with error: TapSDKError, on session: SessionProtocol) {
        var resultMap:[String:Any] = [:]
        resultMap["sdk_result"] = "SDK_ERROR"
        resultMap["sdk_error_code"] = ""//error.type
        resultMap["sdk_error_message"] = error.description
        resultMap["sdk_error_description"] = error.description
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        //      result.success(resultMap)
        if let reactResult = reactResult {
            reactResult([NSNull(), resultMap])
        }
    }
    
    public func cardSaved(_ cardVerification: CardVerification, on session: SessionProtocol) {
        var resultMap:[String:Any] = [:]
        resultMap["id"] = cardVerification.identifier
        resultMap["source_id"] = cardVerification.source.identifier
        resultMap["source_object"] = cardVerification.object
        resultMap["source_payment_type"] = cardVerification.source.paymentType.textValue
        resultMap["source_channel"] = cardVerification.source.channel.textValue
        
        resultMap["customer_id"] = cardVerification.customer.identifier
        if let tokenDataSource = session.dataSource,
           let tokenCurrency:Currency = tokenDataSource.currency as? Currency {
            resultMap["token_currency"] = tokenCurrency.isoCode
        }
        resultMap["card_first_six"] = cardVerification.card.firstSixDigits
        resultMap["card_last_four"] = cardVerification.card.lastFourDigits
        resultMap["card_object"] = cardVerification.card.object
        resultMap["card_exp_month"] = cardVerification.card.expirationMonth
        resultMap["card_exp_year"] = cardVerification.card.expirationYear
        
        resultMap["sdk_result"] = "SUCCESS"
        resultMap["trx_mode"] = "SAVE_CARD"
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        if let reactResult = reactResult {
            reactResult([NSNull(), resultMap])
        }
    }
    
    public func cardSavingFailed(with cardVerification: CardVerification?, error: TapSDKError?, on session: SessionProtocol) {
        var resultMap:[String:Any] = [:]
        resultMap["sdk_result"] = "SDK_ERROR"
        resultMap["sdk_error_code"] = ""//error.type
        if let errorResult = error {
            resultMap["sdk_error_message"] = errorResult.description
            resultMap["sdk_error_description"] = errorResult.description
        }
        if let paymentReference = session.dataSource?.paymentReference {
            resultMap["transaction_number"] = paymentReference?.transactionNumber
            resultMap["order_number"] = paymentReference?.orderNumber
        }
        if let reactResult = reactResult {
            reactResult([NSNull(), resultMap])
        }
    }
}

extension Bridge: SessionAppearance {
    public func sessionShouldShowStatusPopup(_ session: SessionProtocol) -> Bool {
        return false
    }
    public func appearanceMode(for session: SessionProtocol) -> SDKAppearanceMode {
        if let appearanceMode: Int = argsSessionParameters?["appearanceMode"] as? Int {
            if (appearanceMode == 0 ){
                return SDKAppearanceMode.windowed
            } else if (appearanceMode == 1) {
                return SDKAppearanceMode.fullscreen
            }
            return SDKAppearanceMode.default
        }else {
            return SDKAppearanceMode.default
        }
    }
}


extension ChargeStatus {
    var textValue: String {
        switch self {
        case .initiated:    return "INITIATED"
        case .inProgress:   return "IN_PROGRESS"
        case .abandoned:    return "ABANDONED"
        case .cancelled:    return "CANCELLED"
        case .failed:       return "FAILED"
        case .declined:     return "DECLINED"
        case .restricted:   return "RESTRICTED"
        case .captured:     return "CAPTURED"
        case .authorized:   return "AUTHORIZED"
        case .unknown:        return "UNKNOWN"
        case .void:         return "VOID"
        }
    }
}

extension SourceChannel {
    var textValue: String {
        switch self {
        case .callCentre:       return "CALL_CENTRE"
        case .internet:         return "INTERNET"
        case .mailOrder:        return "MAIL_ORDER"
        case .moto:             return "MOTO"
        case .telephoneOrder:   return "TELEPHONE_ORDER"
        case .voiceResponse:    return "VOICE_RESPONSE"
        case .null:             return "null"
        }
    }
}

extension SourceObject {
    var textValue: String {
        switch self {
            
        case .token:    return "TOKEN"
        case .source:   return "SOURCE"
            
        }
    }
}

extension SourcePaymentType {
    fileprivate struct RawValues {
        
        fileprivate static let table: [SourcePaymentType: [String]] = [
            
            .debitCard:        RawValues.debitCard,
            .creditCard:    RawValues.creditCard,
            .prepaidCard:    RawValues.prepaidCard,
            .prepaidWallet:    RawValues.prepaidWallet,
            .null:            RawValues.null
        ]
        
        private static let debitCard        = ["DEBIT_CARD",        "DEBIT"]
        private static let creditCard        = ["CREDIT_CARD",        "CREDIT"]
        private static let prepaidCard        = ["PREPAID_CARD",        "PREPAID"]
        private static let prepaidWallet    = ["PREPAID_WALLET",    "WALLET"]
        private static let null                = ["null"]
        
        @available(*, unavailable) private init() {}
    }
    
    var textValue: String {
        return RawValues.table[self]!.first!
    }
}

extension CardBrand {
    var textValue: String {
        return RawValues.table[self]?.first ?? ""
    }
    
    fileprivate struct RawValues {
        
        fileprivate static let table: [CardBrand: [String]] = [
            
            .aiywaLoyalty       : RawValues.aiywaLoyalty,
            .americanExpress    : RawValues.americanExpress,
            .benefit            : RawValues.benefit,
            .cardGuard          : RawValues.cardGuard,
            .cbk                : RawValues.cbk,
            .dankort            : RawValues.dankort,
            .discover           : RawValues.discover,
            .dinersClub         : RawValues.dinersClub,
            .fawry              : RawValues.fawry,
            .instaPayment       : RawValues.instaPayment,
            .interPayment       : RawValues.interPayment,
            .jcb                : RawValues.jcb,
            .knet               : RawValues.knet,
            .mada               : RawValues.mada,
            .maestro            : RawValues.maestro,
            .masterCard         : RawValues.masterCard,
            .naps               : RawValues.naps,
            .nspkMir            : RawValues.nspkMir,
            .omanNet            : RawValues.omanNet,
            .sadad              : RawValues.sadad,
            .tap                : RawValues.tap,
            .uatp               : RawValues.uatp,
            .unionPay           : RawValues.unionPay,
            .verve              : RawValues.verve,
            .visa               : RawValues.visa,
            .visaElectron        : RawValues.visaElectron,
            .viva               : RawValues.viva,
            .wataniya           : RawValues.wataniya,
            .zain               : RawValues.zain
        ]
        
        private static let aiywaLoyalty     = ["Aiywa Loyalty"]
        private static let americanExpress  = ["AMERICAN_EXPRESS", "AMEX"]
        private static let benefit          = ["BENEFIT"]
        private static let cardGuard        = ["CARDGUARD"]
        private static let cbk              = ["CBK"]
        private static let dankort          = ["DANKORT"]
        private static let discover         = ["DISCOVER"]
        private static let dinersClub       = ["DINERS_CLUB", "DINERS"]
        private static let fawry            = ["FAWRY"]
        private static let instaPayment     = ["INSTAPAY"]
        private static let interPayment     = ["INTERPAY"]
        private static let jcb              = ["JCB"]
        private static let knet             = ["KNET"]
        private static let mada             = ["MADA"]
        private static let maestro          = ["MAESTRO"]
        private static let masterCard       = ["MASTERCARD"]
        private static let naps             = ["NAPS"]
        private static let nspkMir          = ["NSPK"]
        private static let omanNet          = ["OMAN_NET"]
        private static let sadad            = ["SADAD_ACCOUNT"]
        private static let tap              = ["TAP"]
        private static let uatp             = ["UATP"]
        private static let unionPay         = ["UNION_PAY", "UNIONPAY"]
        private static let verve            = ["VERVE"]
        private static let visa             = ["VISA"]
        private static let visaElectron        = ["VISA_ELECTRON"]
        private static let viva             = ["Viva PAY"]
        private static let wataniya         = ["Wataniya PAY"]
        private static let zain             = ["Zain PAY"]
        
        @available(*, unavailable) private init() {}
    }
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
