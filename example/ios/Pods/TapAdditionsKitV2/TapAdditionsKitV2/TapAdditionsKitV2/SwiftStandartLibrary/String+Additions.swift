//
//  String+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGGeometry.CGRect
import struct	CoreGraphics.CGGeometry.CGSize
import Foundation
import class	UIKit.NSStringDrawingContext
import struct	UIKit.NSStringDrawingOptions

/// Useful extension to String.
public extension String {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Empty string.
    static let tap_empty = ""
    
    /// Empty JSON dictionary string.
    static let tap_emptyJSONDictionary = "{}"
    
    /// Empty JSON array string.
    static let tap_emptyJSONArray = "[]"
    
    /// Returns length of the receiver.
    var tap_length: Int {
        
        return self.count
    }
    
    /// Returns reversed string.
    var tap_reversed: String {
        
        return String(self.reversed())
    }
    
    /// Returns last path component of the receiver.
    var tap_lastPathComponent: String {

		let reversedString = self.tap_reversed
		
        if let range = reversedString.range(of: Constants.slashCharacter) {

            return String(reversedString[..<range.lowerBound]).tap_reversed
        }

        return .tap_empty
    }
    
    /// Returns path extension of the receiver.
    var tap_pathExtension: String {
        
        return (self as NSString).pathExtension
    }
    
    /// Defines if the receiver contains only digits.
    var tap_containsOnlyDigits: Bool {
        
        return self.tap_isValid(for: Constants.digitsOnlyRegex)
    }
    
    /// Defines if receiver contains only international digits.
    var tap_containsOnlyInternationalDigits: Bool {
        
        return self.tap_isValid(for: Constants.internationalDigitsOnlyRegex)
    }
    
    /// Defines if receiver is a valid number string.
    var tap_isValidNumber: Bool {
        
        return self.tap_isValid(for: Constants.numberRegex)
    }
    
    /// Returns integer value of the receiver.
    var tap_integerValue: Int {
        
        return (self as NSString).integerValue
    }
    
    /// Returns decimal number value of the receiver if it is a valid number, nil otherwise.
    var tap_decimalValue: Decimal? {
        
        guard self.tap_isValidNumber else { return nil }
        
        type(of: self).tap_numberFormatter.generatesDecimalNumbers = true
        return type(of: self).tap_numberFormatter.number(from: self) as? Decimal
    }
    
    /// Returns double value.
    var tap_doubleValue: Double {
        
        return (self as NSString).doubleValue
    }
    
    /// Defines if the receiver is a valid email address.
    var tap_isValidEmailAddress: Bool {
        
        return Constants.validEmailLengthRange.contains(self.tap_length) && self.tap_isValid(for: Constants.validEmailRegex)
    }
    
    /// Defines if the receiver is a valid cardholder name.
    var tap_isValidCardholderName: Bool {
        
        return self.tap_isValid(for: Constants.validCardholderNameRegex)
    }
    
    /// Defines if receiver passes Luhn algorithm.
    var tap_isValidLuhn: Bool {

        guard self.tap_containsOnlyInternationalDigits else { return false }
        
        var sum = 0
        let digits = self.tap_charactersArray.reversed()
        
        for (index, digitString) in digits.enumerated() {
            
            let digit = digitString.tap_integerValue
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
    
    /// Removes path extension from the receiver.
    ///
    /// - Returns: Copy of the receiver without path extension.
    var tap_deletingPathExtension: String {
        
        return (self as NSString).deletingPathExtension
    }
    
    /// Returns URL encoded receiver.
    var tap_urlEncoded: String {
        
        let characters = CharacterSet.urlQueryAllowed
        
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: characters) else {
            
            return self
        }
        
        return encodedString
    }
    
    /// Characters array.
    var tap_charactersArray: [String] {
        
        return self.map { String($0) }
    }
    
    // MARK: Methods
    
    /// Initializes string from the strings contained in lines array, adding a separator between them.
    ///
    /// - Parameters:
    ///   - separator: Separator string.
    ///   - lines: Lines array.
    init(separator: String, lines: String...) {
        
        self = .tap_empty
        
        let linesCount = lines.count
        guard linesCount > 0 else { return }
        
        for (index, line) in lines.enumerated() {
            
            self += line
            
            if index < linesCount - 1 {
                
                self += separator
            }
        }
    }
	
	/// Trims whitespaces and newlines.
	///
	/// - Parameter nullifyIfResultIsEmpty: If resulting string is empty, nil will be returned.
	/// - Returns: Trimmed string or nil.
	func tap_trimWhitespacesAndNewlines(nullifyIfResultIsEmpty: Bool = false) -> String? {
		
		let result = self.trimmingCharacters(in: .whitespacesAndNewlines)
		
		return (nullifyIfResultIsEmpty && result.tap_length == 0) ? nil : result
	}
	
    /// Returns a string by appending path component to the receiver.
    ///
    /// - Parameter path: Path component to append.
    /// - Returns: Receiver copy with appended path component.
    func tap_appendingPathComponent(_ path: String) -> String {
        
        return (self as NSString).appendingPathComponent(path)
    }
    
    /// Returns a string by appending path extension to the receiver.
    ///
    /// - Parameter path: Path extension to append.
    /// - Returns: Receiver copy with appended path extension.
    func tap_appendingPathExtension(_ path: String) -> String? {
        
        return (self as NSString).appendingPathExtension(path)
    }
    
    /// Compares two strings using NSString isEqual: method.
    ///
    /// - Parameter other: Other string.
    /// - Returns: Boolean value which determines whether the strings are equal.
    func tap_isEqual(to other: String?) -> Bool {
        
        guard let nonnullOther = other else { return false }
        
        return (self as NSString).isEqual(to: nonnullOther)
    }
    
    /// Regular expression check on the receiver.
    ///
    /// - Parameter pattern: Regular expression.
    /// - Returns: Boolean value which determines whether the string is valid for the given regular expression.
    func tap_isValid(for pattern: String?) -> Bool {
        
        guard let nonnullPattern = pattern else { return false }
        
        guard let regex = try? NSRegularExpression(pattern: nonnullPattern, options: .caseInsensitive) else {
            
            print("Failed to create regular expression from the pattern '\(nonnullPattern)'.")
            return false
        }
    
        let selfLength = self.tap_length
        
        let textRange = NSRange(location: 0, length: selfLength)
        let matchRange = regex.rangeOfFirstMatch(in: self, options: .reportProgress, range: textRange)
        
        return ( matchRange.location != NSNotFound ) && ( matchRange.location == 0 && matchRange.length == selfLength )
    }
    
    /// Defines if the receiver has matches for the given regular expression.
    ///
    /// - Parameter pattern: Regular expression.
    /// - Returns: Boolean value which determines if there are matches for the given pattern.
    func tap_hasMatches(for pattern: String?) -> Bool {
        
        guard let nonnullPattern = pattern else { return false }
        
        guard let regex = try? NSRegularExpression(pattern: nonnullPattern, options: .caseInsensitive) else {
            
            return false
        }
        
        let textRange = NSRange(location: 0, length: self.tap_length)
        let matchRange = regex.rangeOfFirstMatch(in: self, options: .reportProgress, range: textRange)
        return matchRange.location != NSNotFound
    }
    
    /// Defines if the receiver includes a given substring ignoring case.
    ///
    /// - Parameter searchText: Substring to search.
    /// - Returns: Boolean
    func tap_containsIgnoringCase(_ searchText: String) -> Bool {
        
        return self.range(of: searchText, options: .caseInsensitive) != nil
    }
    
    /// Returns a substring from a given index.
    ///
    /// - Parameter index: Index.
    /// - Returns: Substring.
    func tap_substring(from index: Int) -> String {
        
        return String(self.suffix(from: index.tap_index(in: self)))
    }
    
    /// Returns a substring to a given index.
    ///
    /// - Parameter index: Index.
    /// - Returns: Substring.
    func tap_substring(to index: Int) -> String {
        
        return String(self.prefix(upTo: index.tap_index(in: self)))
    }
    
    /// Returns a substring with a given NSRange.
    ///
    /// - Parameter range: NSRange.
    /// - Returns: Substring.
    func tap_substring(with range: NSRange) -> String? {
        
        guard let swiftRange = self.tap_range(from: range) else { return nil }
        
        let substring = self[swiftRange]
        return String(substring)
    }
    
    /// Returns NSRange of a substring.
    ///
    /// - Parameter string: Substring.
    /// - Returns: NSRange.
    func tap_nsRange(of string: String) -> NSRange? {
        
        guard let swiftRange = self.range(of: string) else { return nil }
        return self.tap_nsRange(from: swiftRange)
    }
    
    /// Replaces given range with a given substring.
    ///
    /// - Parameters:
    ///   - range: NSRange.
    ///   - string: String to replace with.
    /// - Returns: String with replaced range.
    @discardableResult mutating func tap_replace(range: NSRange, withString string: String) -> String {
        
        self = self.tap_replacing(range: range, withString: string)
        
        return self
    }
    
    /// Replaces given range with a given substring.
    ///
    /// - Parameters:
    ///   - range: NSRange.
    ///   - string: String to replace with.
    /// - Returns: String with replaced range.
    func tap_replacing(range: NSRange, withString string: String) -> String {
        
        guard let swiftRange = self.tap_range(from: range) else { return self }
        
        return self.replacingCharacters(in: swiftRange, with: string)
    }
    
    /// Replaces first occurrence tagret string with replace string from initial string
    ///
    /// - Parameters:
    ///   - string: string to be replaced
    ///   - replaceString: string to replace
    /// - Returns: string with replaced value
    func tap_replacingFirstOccurrence(of string: String, with replaceString: String) -> String {
        
        if let range = self.range(of: string) {
            
            return self.replacingCharacters(in: range, with: replaceString)
        }
        
        return String(self)
    }
    
    /// Replaces first occurrence tagret string with replace string from initial string
    ///
    /// - Parameters:
    ///   - string: string to be replaced
    ///   - replaceString: string to replace
    /// - Returns: string with replaced value
    @discardableResult mutating func tap_replaceFirstOccurrence(of string: String, with replaceString: String) -> String {
        
        guard let range = self.tap_nsRange(of: string) else { return self }
        
        self.tap_replace(range: range, withString: replaceString)
        
        return self
    }
    
    /// Appends given string to the receiver.
    ///
    /// - Parameter string: String to append.
    /// - Returns: Receiver + appended string.
    mutating func tap_append(string: String) -> String {
        
        self = self.appending(string)
        
        return self
    }
    
    /// Returns a string without the given prefix or unchanged string if the receiver has not such prefix.
    ///
    /// - Parameter prefix: Prefix to remove.
    /// - Returns: String without the prefix.
    func tap_removingPrefix(_ prefix: String) -> String {
        
        guard self.hasPrefix(prefix) else { return self }
        
        return String(self.dropFirst(prefix.tap_length))
    }
    
    /// Modifies the receiver by removing the given prefix.
    ///
    /// - Parameter prefix: Prefix to remove.
    /// - Returns: Resulting receiver.
    @discardableResult mutating func tap_removePrefix(_ prefix: String) -> String {
        
        self = self.tap_removingPrefix(prefix)
        return self
    }
    
    /// Returns a string without the given suffix or unchanged string if the receiver has not such suffix.
    ///
    /// - Parameter suffix: Prefix to remove.
    /// - Returns: String without the suffix.
    func tap_removingSuffix(_ suffix: String) -> String {
        
        guard self.hasSuffix(suffix) else { return self }
        
        return String(self.dropLast(suffix.tap_length))
    }
    
    /// Modifies the receiver by removing the given suffix.
    ///
    /// - Parameter suffix: Prefix to remove.
    /// - Returns: Resulting receiver.
    @discardableResult mutating func tap_removeSuffix(_ suffix: String) -> String {
        
        self = self.tap_removingSuffix(suffix)
        return self
    }
    
    /// Graphics method. Returns required bounding rect to draw the receiver with the given parameters.
    ///
    /// - Parameters:
    ///   - size: Size limit.
    ///   - options: String drawing options.
    ///   - attributes: Text attributes ( font, size, etc. )
    ///   - context: Context.
    /// - Returns: CGRect
    func tap_boundingRect(with size: CGSize, options: NSStringDrawingOptions, attributes: [NSAttributedString.Key: Any]?, context: NSStringDrawingContext?) -> CGRect {
        
        return (self as NSString).boundingRect(with: size, options: options, attributes: attributes, context: context)
    }
    
    /// Removes all characters of the receiver except those specified in the string.
    ///
    /// - Parameter charactersString: Valid characters string.
    /// - Returns: Copy of the receiver by removing all invalid characters.
    func tap_byRemovingAllCharactersExcept(_ charactersString: String) -> String {
        
        var result: String = .tap_empty
        
        for character in self {
            
            if charactersString.contains(character) {
                
                result.append(character)
            }
        }
        
        return result
    }
    
    /// Helper method to convert Range<String.Index> to NSRange.
    ///
    /// - Parameter range: Swift range.
    /// - Returns: NSRange.
    func tap_nsRange(from range: Range<Index>) -> NSRange {
        
        let utf16View = self.utf16
        
        guard let from = range.lowerBound.samePosition(in: utf16View), let to = range.upperBound.samePosition(in: utf16View) else {
            
            return NSRange(location: NSNotFound, length: 0)
        }
        
        return NSRange(location: utf16View.distance(from: utf16View.startIndex, to: from), length: utf16View.distance(from: from, to: to))
    }
    
    /// Helper method to convert NSRange to Range<String.Index>.
    ///
    /// - Parameter nsRange: NSRange
    /// - Returns: Swift range.
    func tap_range(from nsRange: NSRange) -> Range<String.Index>? {

        let utf16View = self.utf16
        let endIndex = utf16View.endIndex
        
        guard let from16 = utf16View.index(utf16View.startIndex, offsetBy: nsRange.location, limitedBy: endIndex) else { return nil }
        guard let to16 = utf16View.index(from16, offsetBy: nsRange.length, limitedBy: endIndex) else { return nil }
        
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        
        return from ..< to
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let slashCharacter = "/"
        fileprivate static let numberRegex = "^[\\p{N}]*[.,٬·٫]{0,1}[\\p{N}]*$"
        fileprivate static let digitsOnlyRegex = "^[\\p{N}]*$"
        fileprivate static let internationalDigitsOnlyRegex = "^[0-9]*$"
        fileprivate static let validEmailRegex = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        fileprivate static let validCardholderNameRegex = "^[\\x20-\\x5F]{3,26}$"
        
        fileprivate static let validEmailLengthRange = 3...254
        
        //@available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private static let tap_numberFormatter = NumberFormatter(localeIdentifier: Locale.TapLocaleIdentifier.enUS)
}
