//
//  UIImageView+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import struct	Foundation.NSDate.TimeInterval
import class	UIKit.UIImage.UIImage
import class	UIKit.UIImageView.UIImageView
import class	UIKit.UIView.UIView

/// Useful extension to UIImageView class.
public extension UIImageView {
    
    // MARK: - Public -
    // MARK: Methods
    
    /// Stretches the image.
    func tap_stretchImage() {
        
        self.image = self.image?.tap_stretchableImage
        self.highlightedImage = self.highlightedImage?.tap_stretchableImage
    }
    
    /// Sets image with animation.
    ///
    /// - Parameters:
    ///   - image: Image to set.
    ///   - duration: Animation duration.
    func tap_setImageAnimated(_ image: UIImage?, duration: TimeInterval) {
        
        let fadingImageView = UIImageView(frame: bounds)
        fadingImageView.contentMode = contentMode
        fadingImageView.image = image
        fadingImageView.alpha = 0.0
        
        self.tap_addSubviewWithConstraints(fadingImageView)
        
        let options: UIView.AnimationOptions = [.curveEaseInOut, .beginFromCurrentState, .overrideInheritedDuration, .allowAnimatedContent]
        let animation = {
            
            fadingImageView.alpha = 1.0
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: options, animations: animation) { [weak self] (_) in
            
            self?.image = image
            fadingImageView.image = nil
            fadingImageView.removeFromSuperview()
        }
    }
}
