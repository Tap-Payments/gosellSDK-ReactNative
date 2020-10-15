//
//  TapURLModel.swift
//  TapNetworkManager/Core
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// URL model
///
/// - array: Array URL model.
/// - dictionary: Dictionary URL model.
public enum TapURLModel {

    case array(parameters: [CustomStringConvertible])
    case dictionary(parameters: [String: Any])
}

// MARK: - Equatable
extension TapURLModel: Equatable {

    public static func == (lhs: TapURLModel, rhs: TapURLModel) -> Bool {

        switch (lhs, rhs) {

        case (.array(let lhsParameters), .array(let rhsParameters)):

            return lhsParameters.description == rhsParameters.description

        case (.dictionary(let lhsParameters), .dictionary(let rhsParameters)):

            let nsLhs = NSDictionary(dictionary: lhsParameters)
            return nsLhs.isEqual(to: rhsParameters)

        default:

            return false

        }
    }
}
