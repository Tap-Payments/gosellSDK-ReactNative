//
//  UIView+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import func		Darwin.sqrt
import class	Foundation.NSBundle.Bundle
import struct	Foundation.NSDate.TimeInterval
import class	QuartzCore.CAShapeLayer.CAShapeLayer
import class	UIKit.NSLayoutConstraint
import class	UIKit.UIBezierPath.UIBezierPath
import struct	UIKit.UIBezierPath.UIRectCorner
import class	UIKit.UIColor
import func		UIKit.UIGraphicsBeginImageContextWithOptions
import func		UIKit.UIGraphicsEndImageContext
import func		UIKit.UIGraphicsGetCurrentContext
import func		UIKit.UIGraphicsGetImageFromCurrentImageContext
import class	UIKit.UIImage
import class	UIKit.UIResponder
import class	UIKit.UIScreen
import class	UIKit.UIScrollView
import enum		UIKit.UISemanticContentAttribute
import class	UIKit.UIView

/// Useful extension to UIView.
@IBDesignable extension UIView {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Corner radius of the view.
    @IBInspectable public var tap_cornerRadius: CGFloat {
        
        get {
            
            return self.layer.cornerRadius
        }
        set {
            
            self.layer.cornerRadius = newValue
        }
    }
    
    /// Border width of the view.
    @IBInspectable public var tap_borderWidth: CGFloat {
        
        get {
            
            return self.layer.borderWidth
        }
        set {
            
            self.layer.borderWidth = newValue
        }
    }
    
    /// Border color of the view.
    @IBInspectable public var tap_borderColor: UIColor? {
        
        get {
            guard let cgBorderColor = self.layer.borderColor else {
                
                return nil
            }
            
            return UIColor(cgColor: cgBorderColor)
        }
        set {
            
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    /// Horizontal scale of the view.
    @IBInspectable public var tap_horizontalScale: CGFloat {
        
        get {
            
            let transform = self.layer.affineTransform()
            return sqrt(pow(transform.a, 2.0) + pow(transform.c, 2.0))
        }
        set {
            
            self.layer.setAffineTransform(CGAffineTransform(scaleX: newValue, y: self.tap_verticalScale))
        }
    }
    
    /// Vertical scale of the view.
    @IBInspectable public var tap_verticalScale: CGFloat {
        
        get {
            
            let transform = self.layer.affineTransform()
            return sqrt(pow(transform.b, 2.0) + pow(transform.d, 2.0))
        }
        set {
            
            self.layer.setAffineTransform(CGAffineTransform(scaleX: self.tap_horizontalScale, y: newValue))
        }
    }
    
    /// Inspectable translatesAutoresizingMaskIntoConstraints
    @IBInspectable public var tap_convertsAutoresizingMaskIntoConstraints: Bool {
        
        get {
            
            return self.translatesAutoresizingMaskIntoConstraints
        }
        set {
            
            self.translatesAutoresizingMaskIntoConstraints = newValue
        }
    }
    
    /// Returns screenshot of the view.
    public var tap_screenshot: UIImage? {
        
        return self.tap_screenshot(with: 1.0)
    }
    
    /// Returns current first responder in a view hieararchy with receiver as a parent or nil if there is no first responder set.
    public var tap_firstResponder: UIResponder? {
        
        if self.isFirstResponder {
            
            return self
        }
        
        for subview in self.subviews {
            
            if let fResponder = subview.tap_firstResponder {
                
                return fResponder
            }
        }
        
        return nil
    }
    
    /// Defines if the receiver contains subview that is scrolling.
    public var tap_containsScrollingScrollView: Bool {
        
        if let scrollView = self as? UIScrollView {
            
            if scrollView.isDecelerating || scrollView.isDragging || scrollView.isTracking {
                
                return true
            }
        }
        
        return self.subviews.filter { $0.tap_containsScrollingScrollView }.count > 0
    }
    
    /// Returns existing width constraint if presented or creates new one, attaches it to the view and returns.
    public var tap_widthConstraint: NSLayoutConstraint {
        
        if let wConstraint = self.tap_widthConstraintIfPresent {
            
            return wConstraint
        }
        
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.bounds.width)
        self.addConstraint(constraint)
        
        return constraint
    }
    
    /// Returns width layout constraint if it is presented.
    public var tap_widthConstraintIfPresent: NSLayoutConstraint? {
        
        return self.constraints.filter { $0.firstAttribute == .width }.first
    }
    
    /// Returns existing height constraint if presented or creates new one, attaches it to the view and returns.
    public var tap_heightConstraint: NSLayoutConstraint {
        
        if let hConstraint = self.tap_heightConstraintIfPresent {
            
            return hConstraint
        }
        
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.bounds.height)
        self.addConstraint(constraint)
        
        return constraint
    }
    
    /// Returns height layout constraint if it is presented.
    public var tap_heightConstraintIfPresent: NSLayoutConstraint? {
        
        return self.constraints.filter { $0.firstAttribute == .height }.first
    }
    
    // MARK: Methods
    
    /**
     Loads view from a given nib file.
     
     - parameter nibName: Nib name.
     
     - returns: Top view in the hieararchy of the given nib file or nil if error occured during view creation.
     */
    public func tap_load<T>(from nibName: String?) -> T? {
        
        guard let nonnullNibName = nibName, !nonnullNibName.isEmpty else { return nil }
        
        guard let views = Bundle.main.loadNibNamed(nonnullNibName, owner: nil, options: nil) else { return nil }
        
        let selfViews = views.compactMap { return $0 as? T }
        return selfViews.first
    }
    
    /**
     Returns color of a given point.
     
     - parameter point: Point.
     
     - returns: Color of a given point or nil if point is outside the view.
     */
    open func tap_color(at point: CGPoint) -> UIColor? {
        
        if !self.bounds.contains(point) {
            
            return nil
        }
        
        let pixelSize = UIScreen.main.tap_numberOfPointsInOnePixel
        
        let screenshot = self.tap_screenshot(area: CGRect(origin: point, size: CGSize(width: pixelSize, height: pixelSize)))
        return screenshot?.tap_color(at: CGPoint.zero)
    }
    
    /**
     Removes all animations on a given view and all subviews.
     */
    public func tap_removeAllAnimations() {
        
        self.tap_removeAllAnimations(includeSubviews: true)
    }
    
    public func tap_removeAllAnimations(includeSubviews: Bool) {
        
        self.layer.tap_removeAnimations()
        
        if includeSubviews {
            
            for subview in self.subviews {
                
                subview.tap_removeAllAnimations()
            }
        }
    }
    
    /**
     Enables/disables exclusive touch on all subviews.
     
     - parameter touch: Boolean parameter to determine whether exclusive touch should be enabled.
     */
    public func tap_setExclusiveTouchOnAllSubviews(_ touch: Bool) {
        
        self.isExclusiveTouch = touch
        for subview in subviews {
            
            subview.tap_setExclusiveTouchOnAllSubviews(touch)
        }
    }
    
    /**
     Sets up scale.
     
     - parameter scale: Scale to set.
     */
    public func tap_setScale(_ scale: CGFloat) {
        
        self.layer.setAffineTransform(CGAffineTransform(scaleX: scale, y: scale))
    }
    
    /// Sets translates autoresizing masks into constraints on all subviews.
    ///
    /// - Parameters:
    ///   - value: Boolean value to apply.
    ///   - includeSubviews: Defines if the value should be applied for the subviews ( and their subviews ).
    public func tap_setTranslatesAutoresizingMasksIntoConstrants(_ value: Bool, includeSubviews: Bool = true) {
        
        self.translatesAutoresizingMaskIntoConstraints = value
        
        if includeSubviews {
            
            for subview in self.subviews {
                
                subview.tap_setTranslatesAutoresizingMasksIntoConstrants(value, includeSubviews: true)
            }
        }
    }
    
    /**
     Returns first subview of specific class.
     
     - parameter subviewClass: Class of the subview.
     
     - returns: First subview of specific class if nil if subview could not be found.
     */
    public func tap_subview<T>(ofClass subviewClass: T.Type) -> T? where T: AnyObject {
        
        for subview in self.subviews {
            
            if subview.isKind(of: subviewClass) {
                
                return subview as? T
            }
            
            if let requiredSubview = subview.tap_subview(ofClass: subviewClass) {
                
                return requiredSubview
            }
        }
        
        return nil
    }
    
    /// Applies semantic content attribute for the receiver and all subviews.
    ///
    /// - Parameter attribute: Attribute to apply.
    @available(iOS 9.0, *) open func tap_applySemanticContentAttribute(_ attribute: UISemanticContentAttribute) {
        
        self.semanticContentAttribute = attribute
        
        for subview in self.subviews {
            
            subview.tap_applySemanticContentAttribute(self.semanticContentAttribute)
        }
    }
    
    /**
     Adds subview with constraints.
     
     - parameter subview:  Subview to add.
     */
    public func tap_addSubviewWithConstraints(_ subview: UIView, respectLanguageDirection: Bool = true) {
        
        subview.frame = self.bounds
        
        self.addSubview(subview)
        self.tap_addConstraints(to: subview, respectLanguageDirection: respectLanguageDirection)
    }
    
    /**
     Adds constraints to a specific subview.
     
     - parameter subview: Subview to add constraints to.
     */
    public func tap_addConstraints(to subview: UIView, respectLanguageDirection: Bool) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["subview": subview]
        
        let layoutFormatOptions: NSLayoutConstraint.FormatOptions = respectLanguageDirection ? .directionLeadingToTrailing : .directionLeftToRight
        
        var newConstraints: [NSLayoutConstraint] = []
        newConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: layoutFormatOptions, metrics: nil, views: views))
        newConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: layoutFormatOptions, metrics: nil, views: views))
        
        newConstraints.forEach { $0.isActive = true }
    }
    
    /**
     Removes from superview with fade out animation.
     */
    public func tap_removeFromSuperviewAnimated() {
        
        self.tap_removeFromSuperviewAnimated(with: Constants.defaultRemoveFromSuperviewAnimationDuration)
    }
    
    /// Removes from superview with fade out animation.
    ///
    /// - Parameter duration: Animation duration.
    public func tap_removeFromSuperviewAnimated(with duration: TimeInterval) {
        
        let animations = {
            
            self.alpha = 0.0
        }
        
        let completion: TypeAlias.BooleanClosure = { _ in
            
            self.removeFromSuperview()
        }
        
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }
	
	/// Performs fade in and fade out animation.
	///
	/// - Parameters:
	///   - view: View to animate.
	///   - duration: Animation duration.
	///   - delay: Animation delay.
	///   - update: Closure that will be called when view is not visible (faded in).
	///   - completion: Closure that will be called when animation finishes.
	public static func tap_fadeOutUpdateAndFadeIn<T>(view: T, with duration: TimeInterval, delay: TimeInterval = 0.0, update: @escaping (T) -> Void, completion: ((Bool) -> Void)? = nil) where T: UIView {
		
		let fadeDuration = 0.5 * duration
		
		let fadeInCompletion: TypeAlias.BooleanClosure = { _ in
			
			update(view)
			UIView.animate(withDuration:	fadeDuration,
						   delay:			0.0,
						   options:			[.beginFromCurrentState, .curveEaseOut],
						   animations:		{ view.alpha = 1.0 },
						   completion:		completion)
		}
		
		UIView.animate(withDuration:	fadeDuration,
					   delay:			delay,
					   options:			[.beginFromCurrentState, .curveEaseIn],
					   animations:		{ view.alpha = 0.0 },
					   completion:		fadeInCompletion)
	}
    
    /// Returns a screenshot with a specific resulting image scale.
    ///
    /// - Parameter scale: Resulting image scale.
    /// - Returns: Screenshot image.
    public func tap_screenshot(with scale: CGFloat) -> UIImage? {
        
        return self.tap_screenshot(area: self.bounds, with: scale)
    }
    
    /// Returns a screenshot of specific area with specific resulting image scale.
    ///
    /// - Parameters:
    ///   - area: Area to screenshot measured in points.
    ///   - scale: Resulting image scale.
    /// - Returns: Screenshot image.
    public func tap_screenshot(area: CGRect, with scale: CGFloat = 1.0) -> UIImage? {
        
        let imageScale = scale / UIScreen.main.tap_numberOfPointsInOnePixel
        
        UIGraphicsBeginImageContextWithOptions(area.size, false, imageScale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.translateBy(x: -area.origin.x, y: -area.origin.y)
        
        context.clear(bounds)
        context.setFillColor(UIColor.clear.cgColor)
        
        self.drawHierarchy(in: bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// Force layout.
    public func tap_layout() {
        
        self.setNeedsLayout()
		
		if self.superview != nil && self.window != nil {
			
			self.layoutIfNeeded()
		}
    }
    
    /// Changes receiver's frame to fit its superview.
    public func tap_stickToSuperview() {
        
        if let nonnullSuperview = self.superview {
            
            var viewFrame = self.frame
            viewFrame.origin.y = 0.0
            viewFrame.size = nonnullSuperview.bounds.size
            
            if self.frame != viewFrame {
                
                self.frame = viewFrame
            }
        }
    }
    
    /// 'Rounds' specific corners of the receiver with the specified corner radius.
    ///  Important: Calling this method will replace existing masks on the layer (if presented).
    ///
    /// - Parameters:
    ///   - corners: Corners to round.
    ///   - radius: Corner radius.
    public func tap_roundCorners(_ corners: UIRectCorner, with radius: CGFloat) {
        
        let radii = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: radii)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        self.layer.mask = shapeLayer
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let defaultRemoveFromSuperviewAnimationDuration: TimeInterval = 0.35
        
        //@available(*, unavailable) private init() {}
    }
}
