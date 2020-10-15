//
//  CardBrand.swift
//  TapCardValidator
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Card Brand.
@objc public enum CardBrand: Int {

    case aiywaLoyalty
    case americanExpress
    case benefit
    case cardGuard
    case cbk
    case dankort
    case discover
    case dinersClub
    case fawry
    case instaPayment
    case interPayment
    case jcb
    case knet
    case mada
    case maestro
    case masterCard
    case naps
    case nspkMir
    case omanNet
    case sadad
    case tap
    case uatp
    case unionPay
    case verve
    case visa
	case visaElectron
    case viva
    case wataniya
    case zain

    case unknown

    // MARK: - Private -

    private struct RawValues {

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
			.visaElectron		: RawValues.visaElectron,
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
		private static let visaElectron		= ["VISA_ELECTRON"]
        private static let viva             = ["Viva PAY"]
        private static let wataniya         = ["Wataniya PAY"]
        private static let zain             = ["Zain PAY"]

        @available(*, unavailable) private init() {}
    }
}

// MARK: - Encodable
extension CardBrand: Encodable {

    public func encode(to encoder: Encoder) throws {

        guard let value = RawValues.table[self]?.first else {

            fatalError("Unknown card brand.")
        }

        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

// MARK: - Decodable
extension CardBrand: Decodable {

    public init(from decoder: Decoder) throws {

        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)

        for (brand, rawValues) in RawValues.table {

            guard rawValues.contains(value) else { continue }

            self = brand
            return
        }

        self = .unknown
    }
}
