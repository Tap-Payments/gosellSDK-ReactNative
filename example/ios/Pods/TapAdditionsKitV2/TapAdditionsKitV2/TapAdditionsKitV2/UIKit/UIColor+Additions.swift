//
//  UIColor+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import struct	Foundation.NSRange.NSRange
import class	Foundation.NSScanner.Scanner
import struct	OpenGLES.gltypes.GLfloat
import class	UIKit.UIColor.UIColor

/// UIColor extension.
public extension UIColor {
    
    // MARK: - Public -
    // MARK: Properties
    
    /*!
     Creates and returns extra light native blur tint color.
     
     - returns: Extra light native blur tint color.
     */
    static let tap_extraLightBlurTintColor = UIColor(white: 0.97, alpha: 0.82)
    
    /*!
     Creates and returns light native blur tint color.
     
     - returns: Light native blur tint color.
     */
    static let tap_lightBlurTintColor: UIColor = UIColor(white: 1.0, alpha: 0.3)
    
    /*!
     Creates and returns dark native blur tint color.
     
     - returns: Dark native blur tint color.
     */
    static let tap_darkBlurTintColor = UIColor(white: 0.11, alpha: 0.73)
    
    /// Returns gl components of the color.
    var tap_glComponents: [GLfloat]? {
		
		return self.tap_rgbaComponents?.map { GLfloat($0) }
    }
    
    /// Returns RGBA color components.
    var tap_rgbaComponents: [CGFloat]? {
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            
            return [red, green, blue, alpha]
        }
        else if self.getWhite(&red, alpha: &alpha) {
            
            return [red, red, red, alpha]
        }
        else {
            
            return nil
        }
    }
    
    // MARK: Methods
    
    /// Initializes color with RGBA components.
    ///
    /// - Parameter rgba: RGBA components.
    convenience init?(tap_rgba: [CGFloat]) {
        
        let componentsCount = tap_rgba.count
        
        switch componentsCount {
            
        case 2:
            
            self.init(white: tap_rgba[0], alpha: tap_rgba[1])
            
        case 3:
            
            self.init(red: tap_rgba[0], green: tap_rgba[1], blue: tap_rgba[2], alpha: 1.0)
            
        case 4:
            
            self.init(red: tap_rgba[0], green: tap_rgba[1], blue: tap_rgba[2], alpha: tap_rgba[3])
            
        default:
            
            print("Number of components should be 2, 3 or 4.")
            return nil
        }
    }
    
    /*!
     Fabric that initializes and returns UIColor from its hex representation
     
     - parameter hexString: HEX representation of a color.
     
     - returns: UIColor or nil if HEX string is incorrect.
     */
    static func tap_withHex(_ hexString: String) -> UIColor? {
        
        return UIColor(tap_hex: hexString)
    }
    
    /*!
     Fabric that initializes and returns UIColor from its hex representation
     
     - parameter value: HEX representation of a color.
     
     - returns: UIColor or nil if HEX string is incorrect.
     */
    static func tap_hex(_ value: String) -> UIColor {
        
        guard let color = UIColor(tap_hex: value) else {
            
            fatalError("\(value) is invalid color hex string.")
        }
        
        return color
    }
    
    /*!
     Initializes UIColor from its hex representation
     
     - parameter hexString: HEX representation of a color.
     
     - returns: UIColor or nil if HEX string is incorrect.
     */
    convenience init?(tap_hex hexString: String) {
        
        let stringToScan = (hexString.hasPrefix(Constants.hexPrefix) ? String(hexString.suffix(from: Constants.hexPrefix.tap_length.tap_index(in: hexString))) : hexString).uppercased()
        let scanLength = stringToScan.tap_length
        
        switch scanLength {
            
        case 3, 4, 6, 8:
            
            let removedSymbolsString = stringToScan.tap_byRemovingAllCharactersExcept(Constants.allowedHexSymbols)
            guard removedSymbolsString.tap_isEqual(to: stringToScan) else { return nil }
            
        default:
            return nil
        }
        
        var components: [CGFloat] = [0.0, 0.0, 0.0, 0.0]
        
        let componentLength: Int = ( scanLength == 6 || scanLength == 8 ) ? 2 : 1
        let hasAlpha = scanLength == 4 || scanLength == 8
        
        var scanLocation: Int = 0
        var componentIndex: Int = 0
        
        while scanLocation < scanLength {
            
            guard var componentScanString = stringToScan.tap_substring(with: NSRange(location: scanLocation, length: componentLength)) else { return nil }
            
            if componentLength == 1 {
                
                componentScanString += componentScanString
            }
            
            var component: UInt64 = 0
            
            let scanner = Scanner(string: componentScanString)
            scanner.scanHexInt64(&component)
            
            components[componentIndex] = CGFloat(component) / 255.0
            
            scanLocation += componentLength
            componentIndex += 1
        }
        
        let r = components[0]
        let g = components[1]
        let b = components[2]
        let a = hasAlpha ? components[3] : 1.0
        
        self.init(tap_rgba: [r, g, b, a])
    }
    
    /// Initializes color with GLfloat RGBA components.
    ///
    /// - Parameter glComponents: GLfloat RGBA components.
    convenience init?(tap_glComponents: [GLfloat]) {
		
		let cgFloatComponents = tap_glComponents.map { CGFloat($0) }
        self.init(tap_rgba: cgFloatComponents)
    }
    
    /// Interpolates the color between start and finish.
    ///
    /// - Parameters:
    ///   - start: Start color.
    ///   - finish: Finish color.
    ///   - progress: Progress in range [0, 1]
    /// - Returns: Interpolated color.
    static func tap_interpolate(start: UIColor, finish: UIColor, progress: CGFloat) -> UIColor {
        
        guard let startRGBA = start.tap_rgbaComponents, let finishRGBA = finish.tap_rgbaComponents else {
            
            fatalError("Failed to get RGBA components.")
        }
        
        let resultingRGBA = type(of: startRGBA).tap_interpolate(start: startRGBA, finish: finishRGBA, progress: progress)
        
        guard let result = UIColor(tap_rgba: resultingRGBA) else {
            
            fatalError("Error in interpolating colors. Please report this problem.")
        }
        
        return result
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let allowedHexSymbols = "0123456789ABCDEF"
        fileprivate static let hexPrefix = "#"
    }
}
