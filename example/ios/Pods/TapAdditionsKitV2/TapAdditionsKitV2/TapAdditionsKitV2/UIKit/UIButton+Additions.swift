//
//  UIButton+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	Foundation.NSAttributedString.NSAttributedString
import class	UIKit.UIButton.UIButton
import class	UIKit.UIColor.UIColor
import class	UIKit.UIControl.UIControl
import class	UIKit.UIImage.UIImage

/// Useful extension for UIButton.
public extension UIButton {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Title.
    var tap_title: String? {
        
        get {
            
            return self.title(for: .normal)
        }
        set {
            
            self.setTitle(newValue, for: .disabled)
            self.setTitle(newValue, for: .normal)
            self.setTitle(newValue, for: .highlighted)
            self.setTitle(newValue, for: .selected)
            self.setTitle(newValue, for: [.selected, .highlighted])
        }
    }
    
    /// Attributed title.
    var tap_attributedTitle: NSAttributedString? {
        
        get {
            
            return self.attributedTitle(for: .normal)
        }
        set {
            
            self.setAttributedTitle(newValue, for: .disabled)
            self.setAttributedTitle(newValue, for: .normal)
            self.setAttributedTitle(newValue, for: .highlighted)
            self.setAttributedTitle(newValue, for: .selected)
            self.setAttributedTitle(newValue, for: [.selected, .highlighted])
        }
    }
    
    /// Title color.
    var tap_titleColor: UIColor? {
        
        get {
            
            return self.titleColor(for: .normal)
        }
        set {
            
            self.setTitleColor(newValue, for: .disabled)
            self.setTitleColor(newValue, for: .normal)
            self.setTitleColor(newValue, for: .highlighted)
            self.setTitleColor(newValue, for: .selected)
            self.setTitleColor(newValue, for: [.selected, .highlighted])
        }
    }
    
    // MARK: Methods
    
    /// Applies background image with optional stretch.
    ///
    /// - Parameters:
    ///   - image: Background image.
    ///   - state: Button state.
    ///   - stretch: Stretch parameter.
    func tap_setBackgroundImage(_ image: UIImage?, for state: UIControl.State, withStretch stretch: Bool) {
        
        let backgroundImage = stretch ? image?.tap_stretchableImage : image
        self.setBackgroundImage(backgroundImage, for: state)
    }
    
    /// Stretche background image for a given state.
    ///
    /// - Parameter state: Button state.
    func tap_stretchBackgroundImage(for state: UIControl.State) {
        
        if let backgroundImage = self.backgroundImage(for: state) {
            
            self.tap_setBackgroundImage(backgroundImage, for: state, withStretch: true)
        }
    }
    
    /// Stretches background image for all states.
    func tap_stretchBackgroundImage() {
        
        self.tap_stretchBackgroundImage(for: .disabled)
        self.tap_stretchBackgroundImage(for: .normal)
        self.tap_stretchBackgroundImage(for: .highlighted)
        self.tap_stretchBackgroundImage(for: .selected)
        self.tap_stretchBackgroundImage(for: [.selected, .highlighted])
    }
}
