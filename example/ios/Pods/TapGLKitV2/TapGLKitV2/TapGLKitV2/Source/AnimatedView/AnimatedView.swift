//
//  AnimatedView.swift
//  TapGLKit/AnimatedView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class	GLKit.GLKView
import func		QuartzCore.CABase.CACurrentMediaTime
import 	TapAdditionsKitV2

/// Base class for animated GL views.
public class AnimatedView: BaseGLView {

    //MARK: - Public -
    //MARK: Properties
    
    /// Defines if arrow is animating.
    @IBInspectable public var isAnimating: Bool = false {
        
        didSet {
            
            if self.hidesWhenStopped {
                
                self.isHidden = !self.isAnimating
            }
        }
    }
    
    /// Defines if activity indicator hides when stopped.
    @IBInspectable public var hidesWhenStopped: Bool = false {
        
        didSet {
            
            if self.hidesWhenStopped {
                
                self.isHidden = !self.isAnimating
            }
        }
    }
    
    /// Defines animation duration. Default is 1.0
    public var animationDuration: TimeInterval = 1.0 {
        
        didSet {
            
            self.animatedShader?.animationDuration = self.animationDuration
        }
    }
    
    //MARK: Methods
    
    /// Starts arrow animation.
    public func startAnimating() {
        
        self.isAnimating = true
    }
    
    /// Stops arrow animation.
    public func stopAnimating() {
        
        self.isAnimating = false
    }
    
    public override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        
        self.shader?.render()
    }
    
    //MARK: - Internal -
    //MARK: Properties
    
    @IBInspectable @available(*, unavailable, message : "This is only for Interface Builder") internal var animationDurationIB: CGFloat {
        
        get {
            
            return CGFloat(self.animationDuration)
        }
        set {
            
            self.animationDuration = TimeInterval(newValue)
        }
    }
    
    internal var animationPreviousTime: TimeInterval = 0.0
    
    internal override var drawsDynamically: Bool {
        
        return true
    }
    
    internal private(set) lazy var isEndless = true
    
    //MARK: Methods
    
    @objc internal override func render(_ sender: Any?) {
        
        self.updateDrawingTime()
        super.render(sender)
    }
    
    //MARK: - Private -
    //MARK: Properties
    
    private var animatedShader: AnimatedShader? {
        
        return self.shader as? AnimatedShader
    }
    
    private lazy var wasAnimatingOnPreviousDrawCall = false
    private lazy var animationStartTime: TimeInterval = 0.0
    
    //MARK: Methods
    
    private func updateDrawingTime() {
        
        var startedAnimation = false
        var stoppedAnimation = false
        
        if self.wasAnimatingOnPreviousDrawCall != self.isAnimating {
            
            self.wasAnimatingOnPreviousDrawCall = self.isAnimating
            
            startedAnimation = self.isAnimating
            stoppedAnimation = !self.isAnimating
        }
        
        var drawingTime: TimeInterval
        if startedAnimation {
            
            self.animationStartTime = CACurrentMediaTime() - self.animationPreviousTime
            drawingTime = self.animationPreviousTime
        }
        else if stoppedAnimation || !self.isAnimating {
            
            drawingTime = self.animationPreviousTime
        }
        else {
            
            drawingTime = CACurrentMediaTime() - self.animationStartTime
        }
        
        if !self.isEndless {
            
            drawingTime = tap_clamp(value: drawingTime, low: 0.0, high: self.animationDuration)
        }
        
        self.animatedShader?.time = drawingTime
        
        self.animationPreviousTime = drawingTime
    }
}
