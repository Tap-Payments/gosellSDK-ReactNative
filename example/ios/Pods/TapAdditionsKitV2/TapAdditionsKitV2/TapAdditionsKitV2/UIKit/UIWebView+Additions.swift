//
//  UIWebView+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	CoreGraphics.CGGeometry.CGSize
import class	UIKit.UIWebView.UIWebView

/// Useful extension for UIWebView
public extension UIWebView {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Defines if web view is empty.
    var tap_isEmpty: Bool {
        
        guard let jsResult = self.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('body')[0].innerHTML") else { return true }
        
        return jsResult.tap_length == 0
    }
    
    /// Returns web page size.
    var tap_contentSize: CGSize {
        
        return self.sizeThatFits(.zero)
    }
}
