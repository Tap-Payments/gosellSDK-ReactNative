//
//  Dictionary+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

/// OptionalType protocol.
public protocol OptionalType {
    
    associatedtype Wrapped
    
    /// Returns optional representation of the receiver.
    var tap_asOptional: Wrapped? { get }
}

// MARK: - OptionalType
extension Optional: OptionalType {
    
    public var tap_asOptional: Wrapped? {
        
        return self
    }
}

/// Useful extension to Dictionary class.
public extension Dictionary {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns array of all keys of the receiver.
    var tap_allKeys: [Key] {
        
        return self.map { $0.key }
    }
    
    /// Returns array of all values of the receiver.
    var tap_allValues: [Value] {
        
        return self.map { $0.value }
    }
    
    // MARK: Methods
    
    /**
     Sets value for a given key. If value is nil, then does nothing.
     
     - parameter value: Value.
     - parameter key:   Key.
     */
    mutating func tap_setValue(_ value: Value?, forKey key: Key) {
        
        if let nonnullValue = value {
            
            self[key] = nonnullValue
        }
        else {
            
            self.removeValue(forKey: key)
        }
    }
	
	/// Updates the receiver by merging with the contents of a given `dictionary`.
	///
	/// - Parameter dictionary: Dictionary to merge with.
	/// - Returns: Modified receiver.
	@discardableResult mutating func merge(with dictionary: [Key: Value]) -> [Key: Value] {
		
		self = self.byMerging(with: dictionary)
		
		return self
	}
	
	/// Returns a new dictionary by merging the receiver with the contents of a given `dictionary`
	///
	/// - Parameter dictionary: Dictionary to merge with.
	/// - Returns: Merged dictionary.
	func byMerging(with dictionary: [Key: Value]) -> [Key: Value] {
		
		var result = self
		
		for (key, value) in dictionary {
			
			result[key] = value
		}
		
		return result
	}
	
    /// + operator for same typed dictionaries.
    ///
    /// - Parameters:
    ///   - lhs: Left operand.
    ///   - rhs: Right operand.
    /// - Returns: lhs + rhs
    static func +<Key, Value>(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        
        var result: [Key: Value] = [:]
        for (key, value) in lhs {
            
            result[key] = value
        }
        
        for (key, value) in rhs {
            
            result[key] = value
        }
        
        return result
    }
    
    /// += operator for same typed dictionaries.
    ///
    /// - Parameters:
    ///   - lhs: Receiver.
    ///   - rhs: Right operand.
    /// - Returns: lhs = lhs + rhs
    @discardableResult static func +=<Key, Value>(lhs: inout [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        
        for (key, value) in rhs {
            
            lhs[key] = value
        }
        
        return lhs
    }
    
    /// Maps the receiver keys.
    ///
    /// - Parameter transform: Key transform.
    /// - Returns: Mapped dictionary.
    /// - Throws: Mapped dictionary.
    func tap_mapKeys<T>(_ transform: (Dictionary.Key) throws -> T) rethrows -> [T: Dictionary.Value] {
        
        var result: [T: Dictionary.Value] = [:]
        
        for (key, value) in self {
            
            do {
                
                let mappedKey = try transform(key)
                result[mappedKey] = value
            }
            catch { }
        }
        
        return result
    }
}

// MARK: - OptionalType
extension Dictionary where Value: OptionalType {
    
    /// Returns non-optional representation of the receiver.
    public var tap_nonOptionalRepresentation: [Key: Value.Wrapped] {
        
        var result: [Key: Value.Wrapped] = [:]
        
        for (key, value) in self {
            
            if let unwrappedValue = value.tap_asOptional {
                
                result[key] = unwrappedValue
            }
        }
        
        return result
    }
}
