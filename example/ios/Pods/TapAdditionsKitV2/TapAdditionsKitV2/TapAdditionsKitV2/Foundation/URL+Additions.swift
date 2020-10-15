//
//  URL+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

public extension URL {
	
	/// Quick way to obtain query parameter from URL.
	///
	/// - Parameter tap_queryParameter: Query parameter.
	subscript(tap_queryParameter: String) -> String? {
		
		guard let queryParameters = URLComponents(string: self.absoluteString), let queryItems = queryParameters.queryItems else { return nil }
		guard let queryItem = queryItems.first(where: { $0.name == tap_queryParameter }) else { return nil }
		
		return queryItem.value
	}
	
}
