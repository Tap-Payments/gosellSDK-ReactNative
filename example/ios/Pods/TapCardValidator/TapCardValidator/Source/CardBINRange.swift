//
//  CardBINRange.swift
//  TapCardValidator
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Card BIN range.
internal final class CardBINRange {

    // MARK: - Public -
    // MARK: Properties

    /// Lower card number prefix.
    internal private(set) var lowerRange: String

    /// Higher card number prefix.
    internal private(set) var higherRange: String

    /// Required card number length.
    internal private(set) var cardNumberLengths: [Int]

    /// Card brand.
    internal private(set) var cardBrand: CardBrand

    // MARK: Methods

    internal static func mostSpecific(for number: String) -> CardBINRange {

        return self.mostSpecific(for: number, preferredBrands: nil)
    }

    internal static func mostSpecific(for number: String, preferredBrands: [CardBrand]?) -> CardBINRange {

        let nonnullPreferredBrands = preferredBrands ?? []

        let preferredBrandsAreNotEmpty = nonnullPreferredBrands.count > 0

        let validationClosure: (CardBINRange) -> Bool = { (range) -> Bool in

            if preferredBrandsAreNotEmpty {

                if !nonnullPreferredBrands.contains(range.cardBrand) {

                    return false
                }
            }

            return range.matches(number)
        }

        let possibleRanges = self.allRanges.filter(validationClosure)
        guard possibleRanges.count > 0 else {

            return self.generalRange
        }

        let sortByPreferabilityClosure: (CardBINRange, CardBINRange) -> Bool = { (range1, range2) -> Bool in

            return (nonnullPreferredBrands.firstIndex(of: range1.cardBrand) ?? 0) <= (nonnullPreferredBrands.firstIndex(of: range2.cardBrand) ?? 0)
        }

        let numberLength = number.count
        let possibleRangesWithMostCloseRangeLengthFromLeft = possibleRanges.filter { $0.lowerRange.count <= numberLength }
        if possibleRangesWithMostCloseRangeLengthFromLeft.count > 0 {

            let sortedByLengthPossibleRanges = possibleRangesWithMostCloseRangeLengthFromLeft.sorted { $0.lowerRange.count > $1.lowerRange.count }
            let maxLength = sortedByLengthPossibleRanges[0].lowerRange.count

            let allMaxLengthRanges = sortedByLengthPossibleRanges.filter { $0.lowerRange.count == maxLength }
            let sortedMaxLengthRanges = allMaxLengthRanges.sorted(by: sortByPreferabilityClosure)

            return sortedMaxLengthRanges[0]
        }

        let possibleRangesWithMostCloseRangeLengthFromRight = possibleRanges.filter { $0.lowerRange.count > numberLength }
        if possibleRangesWithMostCloseRangeLengthFromRight.count > 0 {

            let sortedByLengthPossibleRanges = possibleRangesWithMostCloseRangeLengthFromRight.sorted { $0.lowerRange.count < $1.lowerRange.count }
            let minLength = sortedByLengthPossibleRanges[0].lowerRange.count

            let allMinLengthRanges = sortedByLengthPossibleRanges.filter { $0.lowerRange.count == minLength }
            let sortedMinLengthRanges = allMinLengthRanges.sorted(by: sortByPreferabilityClosure)

            return sortedMinLengthRanges[0]
        }

        return self.generalRange
    }

    internal static func brand(for number: String) -> CardBrand {

        let brands = self.possibleBrands(for: number)
        if brands.count == 1 {

            return brands.first!
        }
        else {

            return .unknown
        }
    }

    internal static func possibleBrands(for number: String) -> Set<CardBrand> {

        let binRanges = self.binRanges(for: number)
        var possibleBrands: Set<CardBrand> = Set<CardBrand>(binRanges.map { $0.cardBrand })

        possibleBrands.remove(.unknown)
        return possibleBrands
    }

    internal static func ranges(for brand: CardBrand? = nil) -> [CardBINRange] {

        guard let nonnullBrand = brand else { return self.allRanges }

        return self.allRanges.filter { $0.cardBrand == nonnullBrand }
    }

    // MARK: - Private -

    private struct Constants {

        fileprivate static let defaultPad = "0"
        fileprivate static let emptyString = ""

        @available(*, unavailable) private init() {}
    }

    // MARK: Properties

    private static let allRanges = [

        CardBINRange(lowRange: "34"    , highRange: "34"    , lengths: [15]                            , brand: .americanExpress),
        CardBINRange(lowRange: "37"    , highRange: "37"    , lengths: [15]                            , brand: .americanExpress),

        CardBINRange(lowRange: "62"    , highRange: "62"    , lengths: [16, 17, 18, 19]                , brand: .unionPay),

        CardBINRange(lowRange: "2014"  , highRange: "2014"  , lengths: [15]                            , brand: .dinersClub),
        CardBINRange(lowRange: "2149"  , highRange: "2149"  , lengths: [15]                            , brand: .dinersClub),
        CardBINRange(lowRange: "300"   , highRange: "305"   , lengths: [14]                            , brand: .dinersClub),
        CardBINRange(lowRange: "3095"  , highRange: "3095"  , lengths: [14]                            , brand: .dinersClub),
        CardBINRange(lowRange: "36"    , highRange: "36"    , lengths: [14]                            , brand: .dinersClub),
        CardBINRange(lowRange: "38"    , highRange: "39"    , lengths: [14]                            , brand: .dinersClub),
        CardBINRange(lowRange: "54"    , highRange: "55"    , lengths: [16]                            , brand: .dinersClub),

        CardBINRange(lowRange: "60110" , highRange: "60110" , lengths: [16]                            , brand: .discover),
        CardBINRange(lowRange: "60112" , highRange: "60114" , lengths: [16]                            , brand: .discover),
        CardBINRange(lowRange: "601174", highRange: "601174", lengths: [16]                            , brand: .discover),
        CardBINRange(lowRange: "601177", highRange: "601179", lengths: [16]                            , brand: .discover),
        CardBINRange(lowRange: "601186", highRange: "601199", lengths: [16]                            , brand: .discover),
        CardBINRange(lowRange: "622126", highRange: "622925", lengths: [16, 19]                        , brand: .discover),
        CardBINRange(lowRange: "644"   , highRange: "659"   , lengths: [16]                            , brand: .discover),

        CardBINRange(lowRange: "636"   , highRange: "636"   , lengths: [16, 17, 18, 19]                , brand: .interPayment),

        CardBINRange(lowRange: "637"   , highRange: "639"   , lengths: [16]                            , brand: .instaPayment),

        CardBINRange(lowRange: "1800"  , highRange: "1800"  , lengths: [16, 17, 18, 19]                , brand: .jcb),
        CardBINRange(lowRange: "2131"  , highRange: "2131"  , lengths: [16, 17, 18, 19]                , brand: .jcb),
        CardBINRange(lowRange: "3528"  , highRange: "3589"  , lengths: [16, 17, 18, 19]                , brand: .jcb),

        CardBINRange(lowRange: "50"    , highRange: "50"    , lengths: [12, 13, 14, 15, 16, 17, 18, 19], brand: .maestro),
        CardBINRange(lowRange: "56"    , highRange: "64"    , lengths: [12, 13, 14, 15, 16, 17, 18, 19], brand: .maestro),
        CardBINRange(lowRange: "66"    , highRange: "69"    , lengths: [12, 13, 14, 15, 16, 17, 18, 19], brand: .maestro),

        CardBINRange(lowRange: "5019"  , highRange: "5019"  , lengths: [16]                            , brand: .dankort),
        CardBINRange(lowRange: "4175"  , highRange: "4175"  , lengths: [16]                            , brand: .dankort),
        CardBINRange(lowRange: "4571"  , highRange: "4571"  , lengths: [16]                            , brand: .dankort),

        CardBINRange(lowRange: "2200"  , highRange: "2204"  , lengths: [16]                            , brand: .nspkMir),

        CardBINRange(lowRange: "51"    , highRange: "55"    , lengths: [16]                            , brand: .masterCard),
        CardBINRange(lowRange: "2221"  , highRange: "2720"  , lengths: [16]                            , brand: .masterCard),

        CardBINRange(lowRange: "4"     , highRange: "4"     , lengths: [16]                            , brand: .visa),
        CardBINRange(lowRange: "413600", highRange: "413600", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "444509", highRange: "444509", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "444550", highRange: "444550", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "450603", highRange: "450603", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "450617", highRange: "450617", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "450628", highRange: "450629", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "450636", highRange: "450636", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "450640", highRange: "450641", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "450662", highRange: "450662", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "463100", highRange: "463100", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "476142", highRange: "476143", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "492901", highRange: "492902", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "492920", highRange: "492920", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "492923", highRange: "492923", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "492928", highRange: "492930", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "492937", highRange: "492937", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "492939", highRange: "492939", lengths: [13]                            , brand: .visa),
        CardBINRange(lowRange: "492960", highRange: "492960", lengths: [13]                            , brand: .visa),

        CardBINRange(lowRange: "1"     , highRange: "1"     , lengths: [15]                            , brand: .uatp),

        CardBINRange(lowRange: "506099", highRange: "506198", lengths: [16, 19]                        , brand: .verve),
        CardBINRange(lowRange: "650002", highRange: "650027", lengths: [16, 19]                        , brand: .verve),

        CardBINRange(lowRange: "5392"  , highRange: "5392"  , lengths: [16]                            , brand: .cardGuard)
    ]

    private static let generalRange = CardBINRange(lowRange: Constants.emptyString, highRange: Constants.emptyString, lengths: [16], brand: .unknown)

    // MARK: Methods

    private init(lowRange: String, highRange: String, lengths: [Int], brand: CardBrand) {

        self.lowerRange = lowRange
        self.higherRange = highRange
        self.cardNumberLengths = lengths
        self.cardBrand = brand
    }

    private func matches(_ number: String) -> Bool {

        let lowLength = min(number.count, self.lowerRange.count)
        let highLength = min(number.count, self.higherRange.count)

        guard let numberLow = Int(number.padding(toLength: lowLength, withPad: Constants.defaultPad, startingAt: 0)) else { return false }
        guard let numberHigh = Int(number.padding(toLength: highLength, withPad: Constants.defaultPad, startingAt: 0)) else { return false }

        guard let selfLow = Int(self.lowerRange.padding(toLength: lowLength, withPad: Constants.defaultPad, startingAt: 0)) else { return false }
        guard let selfHigh = Int(self.higherRange.padding(toLength: highLength, withPad: Constants.defaultPad, startingAt: 0)) else { return false }

        return selfLow <= numberLow && selfHigh >= numberHigh
    }

    private func matchesMostSpecific(_ number: String) -> Bool {

        guard let low = Int(number.padding(toLength: self.lowerRange.count, withPad: Constants.defaultPad, startingAt: 0)) else { return false }
        guard let high = Int(number.padding(toLength: self.higherRange.count, withPad: Constants.defaultPad, startingAt: 0)) else { return false }

        guard let selfLow = Int(self.lowerRange), let selfHigh = Int(self.higherRange) else { return false }

        return selfLow <= low && selfHigh >= high
    }

    private static func binRanges(for number: String) -> [CardBINRange] {

        return self.allRanges.filter { $0.matches(number) }
    }
}

// MARK: - Equatable
extension CardBINRange: Equatable {

    internal static func == (lhs: CardBINRange, rhs: CardBINRange) -> Bool {

        return lhs.lowerRange == rhs.lowerRange && lhs.higherRange == rhs.higherRange && lhs.cardNumberLengths == rhs.cardNumberLengths && lhs.cardBrand == rhs.cardBrand
    }
}
