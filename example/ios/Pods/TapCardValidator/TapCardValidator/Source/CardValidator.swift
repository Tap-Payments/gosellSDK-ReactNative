//
//  CardValidator.swift
//  TapCardValidator
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Card validator.
public final class CardValidator {

    // MARK: - Public -
    // MARK: Methods

    /// Validates card number.
    ///
    /// - Parameter cardNumber: Card number.
    /// - Returns: Card brand with its validation state.
    public static func validate(cardNumber: String?) -> DefinedCardBrand {

        return self.validate(cardNumber: cardNumber, preferredBrands: nil)
    }

    /// Validates card number with preferred brands.
    ///
    /// - Parameters:
    ///   - cardNumber: Card number.
    ///   - preferredBrands: Preferred brands.
    /// - Returns: Card brand with its validation state.
    public static func validate(cardNumber: String?, preferredBrands: [CardBrand]?) -> DefinedCardBrand {

        guard let number = cardNumber?.trimmingCharacters(in: Constants.whitespacesCharacterSet), number.count > 0 else {

            return DefinedCardBrand(.incomplete, nil)
        }

        guard self.containsOnlyInternationalDigits(number) else {

            return DefinedCardBrand(.invalid, nil)
        }

        var binRange = CardBINRange.mostSpecific(for: number, preferredBrands: preferredBrands)
        var cardBrand = binRange.cardBrand

        if (preferredBrands?.count ?? 0) > 0 && cardBrand == .unknown {

            binRange = CardBINRange.mostSpecific(for: number)
            cardBrand = binRange.cardBrand
        }

        guard cardBrand != .unknown else { return DefinedCardBrand(.invalid, nil) }

        if binRange.cardNumberLengths.contains(number.count) {

            if self.passesLuhn(number) {

                return DefinedCardBrand(.valid, cardBrand)
            }
            else {

                return DefinedCardBrand(.invalid, cardBrand)
            }
        }
        else if number.count > binRange.cardNumberLengths.max()! {

            return DefinedCardBrand(.invalid, cardBrand)
        }
        else {

            return DefinedCardBrand(.incomplete, cardBrand)
        }
    }

    /// Returns correct visual spacings for a given card brand.
    ///
    /// - Parameter card: Card brand.
    /// - Returns: Visual spacings for a given brand.
    public static func spacings(for card: CardBrand?) -> [Int] {

        if card == .americanExpress {

            return [3, 9]
        }
        else {

            return [3, 7, 11, 15]
        }
    }

    /// Returns maximal card number length for a specific `brand` or maximal possible card number length if `brand` is `nil`.
    ///
    /// - Parameter brand: Card brand or nil.
    /// - Returns: Maximal card number length.
    public static func maximalCardNumberLength(for brand: CardBrand?) -> Int {

        let ranges = CardBINRange.ranges(for: brand)
        let lengths = ranges.flatMap { $0.cardNumberLengths }
        return lengths.max() ?? 0
    }

    /// Returns required cvv length for a given card brand.
    ///
    /// - Parameter card: Card brand.
    /// - Returns: required cvv field length.
    public static func cvvLength(for card: CardBrand?) -> Int {

        guard let cardBrand = card else {

            return 4
        }

        if cardBrand == .unknown || cardBrand == .americanExpress {

            return 4
        }
        else {

            return 3
        }
    }

    /// Returns possible card brand to pay through for a given card number among allowed brands.
    ///
    /// - Parameters:
    ///   - cardNumber: Card number.
    ///   - brands: Available card brands.
    /// - Returns: Card brand or nil.
    public static func paymentCardBrand(for cardNumber: String, among brands: [CardBrand]) -> CardBrand? {

        let number = cardNumber.trimmingCharacters(in: Constants.whitespacesCharacterSet)
        guard number.count > 0 && self.containsOnlyInternationalDigits(number) else { return nil }

        let possibleBrands = CardBINRange.possibleBrands(for: number)
        let intersection = possibleBrands.intersection(brands)
        return intersection.first
    }

    // MARK: - Private -

    private struct Constants {

        fileprivate static let whitespacesCharacterSet = CharacterSet.whitespaces
        fileprivate static let internationalDigitsSet = CharacterSet(charactersIn: "0123456789")

        @available(*, unavailable) private init() {}
    }

    // MARK: Methods

    @available(*, unavailable) private init() {}

    private static func containsOnlyInternationalDigits(_ string: String) -> Bool {

        return string.trimmingCharacters(in: Constants.internationalDigitsSet.inverted).count == string.count
    }

    private static func passesLuhn(_ number: String) -> Bool {

        var sum = 0
        let digits = number.reversed()

        for (index, digitString) in digits.enumerated() {

            guard let digit = Int(String(digitString)) else { return false }

            let odd = index % 2 == 1

            switch (odd, digit) {

            case (true, 9):

                sum += 9

            case (true, 0...8):

                sum += ( digit * 2 ) % 9

            default:

                sum += digit
            }
        }

        return sum % 10 == 0
    }
}
