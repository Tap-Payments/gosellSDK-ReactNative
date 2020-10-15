//
//  Data+Additions.swift
//  TapKeychain
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

extension Data: KeychainRepresentable {

    public func tap_toKeychainData() -> Data? {

        return self
    }

    public init?(tap_keychainData: Data) {

        self = tap_keychainData
    }
}

internal extension Data {

	func tap_decodePrimitive<T>() -> T? {

		#if swift(>=5.0)

		return self.withUnsafeBytes { (pointer) in

			let memory = pointer.bindMemory(to: T.self)
			guard memory.count == 1 else { return nil }

			return memory.first
		}

		#else

		return self.withUnsafeBytes({ $0.pointee })

		#endif
	}
}
