//
//  CustomStringConvertible+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

public extension CustomStringConvertible {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Modified object's description by adding extra spaces in the
    ///
    /// - Parameter extraSpaces: Number of extra spaces to add.
    /// - Returns: Object's description.
    func tap_description(with extraSpaces: Int) -> String {
        
        let spaces = String(repeating: CustomStringConvertibleConstants.spaceString, count: extraSpaces)
        let separator = CustomStringConvertibleConstants.newlineString.appending(spaces)
        let originalDescription = self.description
        
        let newLineTabulation = CustomStringConvertibleConstants.newlineString.appending(CustomStringConvertibleConstants.tabulationString)
        
        if originalDescription.hasPrefix(CustomStringConvertibleConstants.newlineString) {
            
            let suffix = originalDescription.dropFirst(CustomStringConvertibleConstants.newlineString.tap_length)
            let suffixString = String(suffix)
            
            let desc = newLineTabulation.appending(suffixString)
            return desc.replacingOccurrences(of: newLineTabulation, with: separator)
        }
        else {
            
            return originalDescription.replacingOccurrences(of: newLineTabulation, with: separator)
        }
    }
}

private struct CustomStringConvertibleConstants {
    
    fileprivate static let spaceString      = " "
    
    fileprivate static let newlineString    = "\n"
    fileprivate static let newline          = Character(CustomStringConvertibleConstants.newlineString)
    
    fileprivate static let tabulationString = "\t"
    
    //@available(*, unavailable) private init() {}
}
