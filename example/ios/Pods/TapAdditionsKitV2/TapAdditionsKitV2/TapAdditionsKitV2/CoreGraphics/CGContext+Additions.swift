//
//  CGContext+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import enum		CoreGraphics.CGContext.CGBlendMode
import class	CoreGraphics.CGContext.CGContext
import struct	CoreGraphics.CGGeometry.CGRect
import struct	CoreGraphics.CGGeometry.CGSize
import class	CoreGraphics.CGImage.CGImage
import class	UIKit.UIColor.UIColor

public extension CGContext {
    
    // MARK: - Public -
    // MARK: Methods
    
    func tap_makeImage(with blendColor: UIColor?, blendMode: CGBlendMode, size: CGSize) -> CGImage? {
        
        if let color = blendColor {
            
            self.setFillColor(color.cgColor)
            self.setBlendMode(blendMode)
            self.fill(CGRect(origin: .zero, size: size))
        }
        
        return self.makeImage()
    }
}
