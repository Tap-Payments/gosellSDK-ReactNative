//
//  DefinedCardBrand.swift
//  TapCardValidator
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Struct of recognized card brand and validation state.
public struct DefinedCardBrand {

    /// Validation state.
    public internal(set) var validationState: CardValidationState

    /// Card brand.
    public internal(set) var cardBrand: CardBrand?

    /// Initializes the structure with card brand and its validation state.
    ///
    /// - Parameters:
    ///   - validationState: Validation state.
    ///   - cardBrand: Card brand.
    public init(_ validationState: CardValidationState, _ cardBrand: CardBrand?) {

        self.validationState = validationState
        self.cardBrand = cardBrand
    }
}

// MARK: - Equatable -
extension DefinedCardBrand: Equatable {

    public static func == (lhs: DefinedCardBrand, rhs: DefinedCardBrand) -> Bool {

        let lBrandNotNil = lhs.cardBrand != nil
        let rBrandNotNil = rhs.cardBrand != nil
        guard lBrandNotNil == rBrandNotNil else { return false }

        if lBrandNotNil == false {

            return lhs.validationState == rhs.validationState
        }

        return lhs.validationState == rhs.validationState && lhs.cardBrand! == rhs.cardBrand!
    }
}
