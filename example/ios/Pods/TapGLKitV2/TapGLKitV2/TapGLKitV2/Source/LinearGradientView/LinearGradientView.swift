//
//  LinearGradientView.swift
//  TapGLKit/LinearGradientView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class OpenGLES.EAGL.EAGLContext
import class UIKit.UIColor.UIColor

/// Linear Gradient View
@IBDesignable public class LinearGradientView: BaseGLView {
    
    //MARK: - Public -
    //MARK: Properties
    
    /// First gradient color.
    @IBInspectable public var firstColor: UIColor = UIColor.black {
        
        didSet {
            
            self.linearShader?.firstColor = self.firstColor
            self.display()
        }
    }
    
    /// Second gradient color.
    @IBInspectable public var secondColor: UIColor = UIColor.black {
        
        didSet {
            
            self.linearShader?.secondColor = self.secondColor
            self.display()
        }
    }
    
    /// Direction of gradient.
    public var gradientDirection: GradientDirection = .topToBottom {
        
        didSet {
            
            self.linearShader?.gradientDirection = self.gradientDirection
            self.display()
        }
    }
    
    /// Specially for Interface Builder.
    @IBInspectable @available(*, unavailable, message : "This is only for Interface Builder") public var topToBottom: Bool {
        
        get {
            
            return self.gradientDirection == .topToBottom
        }
        set {
            
            self.gradientDirection = newValue ? .topToBottom : .leftToRight
        }
    }
    
    //MARK: Methods
    
    public func gradientColor(at point: CGPoint) -> UIColor? {
        
        guard self.bounds.contains(point) else { return nil }
        
        guard let firstColorComponents = self.firstColor.tap_rgbaComponents else { return nil }
        guard let secondColorComponents = self.secondColor.tap_rgbaComponents else { return nil }
        
        let progress = self.gradientDirection == .leftToRight ? point.x / self.bounds.width : point.y / self.bounds.height
        
        var resultComponents: [CGFloat] = []
        for index in 0..<firstColorComponents.count {
            
            resultComponents.append(firstColorComponents[index] + (secondColorComponents[index] - firstColorComponents[index]) * progress)
        }
        
        return UIColor(tap_rgba: resultComponents)
    }
    
    //MARK: - Internal -
    //MARK: Properties
    
    internal override var drawsDynamically: Bool {
        
        return false
    }
    
    //MARK: Methods
    
    internal override func createShader(with ctx: EAGLContext) {
        
        self.shader = LinearGradientShader(context: ctx)
        super.createShader(with: ctx)
    }
    
    //MARK: - Private -
    //MARK: Properties
    
    private var linearShader: LinearGradientShader? {
        
        return self.shader as? LinearGradientShader
    }
}
