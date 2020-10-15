//
//  LocalizationKey.swift
//  TapBundleLocalization
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// Localization key.
public struct LocalizationKey {
	
	// MARK: - Public -
	// MARK: Properties
	
	/// Raw value.
	public let rawValue: String
	
	// MARK: Methods
	
	/// Initializes localization key with a raw value.
	///
	/// - Parameter rawValue: Raw value.
	public init(_ rawValue: String) {
		
		self.rawValue = rawValue
	}
}

// MARK: - Equatable
extension LocalizationKey: Equatable {
	
	public static func == (lhs: LocalizationKey, rhs: LocalizationKey) -> Bool {
		
		return lhs.rawValue == rhs.rawValue
	}
}
