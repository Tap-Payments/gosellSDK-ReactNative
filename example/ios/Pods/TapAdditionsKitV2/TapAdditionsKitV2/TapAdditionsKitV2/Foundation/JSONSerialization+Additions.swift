//
//  JSONSerialization+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import Foundation
import TapSwiftFixes
/// JSON Serialization protocol.
public protocol JSONSerializable {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Generates JSON string with the given JSON writing options and resulting string encoding.
    ///
    /// - Parameters:
    ///   - options: JSON writing options.
    ///   - encoding: String encoding.
    /// - Returns: JSON string or empty string if the receiver is not a valid json object.
    func tap_serializedToJSONString(with options: JSONSerialization.WritingOptions, encoding: String.Encoding) -> String
}

public extension JSONSerializable {
    
    /// Defines if the receiver is a valid JSON object.
    var tap_isValidJSONObject: Bool {
        
        return JSONSerialization.isValidJSONObject(self)
    }
    
    /// Returns JSON string of the receiver or empty JSON dictionary if the receiver is not a valid json object.
    var tap_jsonString: String {
     
        return self.tap_serializedToJSONString(with: .tap_none, encoding: .utf8)
    }
}

/// JSON Safe Serialization protocol.
public protocol JSONSafeSerializable: JSONSerializable {
    
    /// Generates 'safe' JSON object by removing everything that cannot be serialized to JSON ( e.g. lossy JSON object ).
    var tap_safeJSONObject: Self { get }
}

extension JSONSafeSerializable {
    
    /// Generates 'safe' JSON string by removing everything that cannot be serialized to JSON ( e.g. lossy JSON string ).
    public var tap_safeJSONString: String {
        
        return self.tap_safeJSONObject.tap_jsonString
    }
}

extension Array: JSONSerializable {
    
    public func tap_serializedToJSONString(with options: JSONSerialization.WritingOptions, encoding: String.Encoding) -> String {
        
        return JSONSerialization.tap_string(fromJSONObject: self, options: options, encoding: encoding) ?? .tap_emptyJSONArray
    }
}

extension Dictionary: JSONSerializable {
    
    public func tap_serializedToJSONString(with options: JSONSerialization.WritingOptions, encoding: String.Encoding) -> String {
    
        return JSONSerialization.tap_string(fromJSONObject: self, options: options, encoding: encoding) ?? .tap_emptyJSONDictionary
    }
}

fileprivate extension JSONSerialization {
    
    static func tap_string(fromJSONObject object: JSONSerializable, options: JSONSerialization.WritingOptions, encoding: String.Encoding) -> String? {
        
        guard object.tap_isValidJSONObject else { return nil }
        
        var data: Data?
        
        let closure: TypeAlias.ArgumentlessClosure = {
            
            data = try? JSONSerialization.data(withJSONObject: object, options: options)
        }
        
        catchException(closure, nil)
        
        if let nonnullData = data {
            
            return String(data: nonnullData, encoding: encoding)
        }
        else {
            
            return nil
        }
    }
}

extension Array: JSONSafeSerializable {
    
    public var tap_safeJSONObject: [Element] {
    
        let result = self.compactMap { tap_safelySerializableObject($0) }
        
        if result.tap_isValidJSONObject {
            
            return result
        }
        else {
            
            return []
        }
    }
}

extension Dictionary: JSONSafeSerializable {
    
    public var tap_safeJSONObject: [Key: Value] {
        
        var result: [Key: Value] = [:]
        
        for (key, value) in self {
            
            guard key is String else { continue }
            
            if let safeValue = tap_safelySerializableObject(value) {
                
                result[key] = safeValue
            }
        }
        
        if result.tap_isValidJSONObject {
            
            return result
        }
        else {
         
            return [:]
        }
    }
}

private func tap_safelySerializableObject<T>(_ object: T) -> T? {
    
    if let arrayObject = object as? [Any] {
        
        return arrayObject.tap_safeJSONObject as? T
    }
    else if let dictionaryObject = object as? [AnyHashable: Any] {
        
        return dictionaryObject.tap_safeJSONObject as? T
    }
    else if [object].tap_isValidJSONObject {
        
        return object
    }
    else {
        
        return nil
    }
}
