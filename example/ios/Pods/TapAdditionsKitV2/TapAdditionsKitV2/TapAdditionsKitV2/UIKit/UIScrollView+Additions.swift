//
//  UIScrollView+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class	UIKit.UIScrollView

/// Useful extension for UIScrollView.
public extension UIScrollView {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns number of pages.
    var tap_numberOfPages: Int {
        
        guard self.tap_canPagingPropertiesBeCalculated else {
            
            fatalError("In order to use the function paging should be enabled and width of the scroll view should be > 0.")
        }
        
        return Int(self.contentSize.width / self.bounds.width)
    }

    /// Returns current page index.
    var tap_pageIndex: Int {
        
        return Int(self.tap_floatingPageIndex)
    }
    
    /// Returns most visible page index.
    var tap_closestPageIndex: Int {
        
        return Int(self.tap_floatingPageIndex.rounded())
    }
    
    /// Returns floating point page index.
    var tap_floatingPageIndex: CGFloat {
        
        guard self.tap_canPagingPropertiesBeCalculated else {
            
            fatalError("In order to use the function paging should be enabled and width of the scroll view should be > 0.")
        }
        
        return tap_clamp(value: self.contentOffset.x / self.bounds.width, low: 0.0, high: max(CGFloat(self.tap_numberOfPages) - 1.0, 0.0))
    }
    
    /// Returns maximal content offset.
    var tap_maximalContentOffset: CGPoint {
        
        return CGPoint(x: max(self.contentSize.width - self.bounds.width + self.contentInset.right, -self.contentInset.left),
                       y: max(self.contentSize.height - self.bounds.height + self.contentInset.bottom, -self.contentInset.top))
    }
    
    // MARK: Methods
    
    /// Scrolls to top.
    ///
    /// - Parameter animated: Defines if scrolling should happen with animation.
    func tap_scrollToTop(animated: Bool) {
        
        self.setContentOffset(CGPoint(x: contentOffset.x, y: -self.contentInset.top), animated: animated)
    }
    
    /// Scrolls to bottom.
    ///
    /// - Parameter animated: Defines if scrolling should happen with animation.
    func tap_scrollToBottom(animated: Bool) {
        
        self.setContentOffset(CGPoint(x: contentOffset.x, y: self.tap_maximalContentOffset.y), animated: animated)
    }
    
    /// Scrolls to left.
    ///
    /// - Parameter animated: Defines if scrolling should happen with animation.
    func tap_scrollToLeft(animated: Bool) {
        
        self.setContentOffset(CGPoint(x: 0.0, y: contentOffset.y), animated: animated)
    }
    
    /// Scrolls to right.
    ///
    /// - Parameter animated: Defines if scrolling should happen with animation.
    func tap_scrollToRight(animated: Bool) {
        
        self.setContentOffset(CGPoint(x: self.tap_maximalContentOffset.x, y: contentOffset.y), animated: animated)
    }
    
    /// Sets content offset with optional calling delegate.
    ///
    /// - Parameters:
    ///   - offset: Desired content offset.
    ///   - callDelegate: Defines if delegate should be called.
    func tap_setContentOffset(_ offset: CGPoint, callDelegate: Bool) {
        
        if callDelegate {
            
            self.contentOffset = offset
        }
        else {
            
            var bounds = self.bounds
            bounds.origin = offset
            self.bounds = bounds
        }
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private var tap_canPagingPropertiesBeCalculated: Bool {
        
        return self.isPagingEnabled && self.bounds.width > 0.0
    }
}
