//
//  TapActivityIndicatorView.swift
//  TapGLKit/TapActivityIndicatorView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class OpenGLES.EAGL.EAGLContext
import class UIKit.UIColor.UIColor

/// Tap Activity Indicator View class.
@IBDesignable public class TapActivityIndicatorView: AnimatedView {
    
    //MARK: - Public -
    //MARK: Properties
    
    /// Defines if custom colors are used.
    @IBInspectable public var usesCustomColors: Bool = false {
        
        didSet {
            
            self.activityIndicatorShader?.usesCustomColors = usesCustomColors
        }
    }
    
    /// Color of the outter circle.
    @IBInspectable public var outterCircleColor: UIColor = UIColor.white {
        
        didSet {
            
            self.activityIndicatorShader?.outterCircleColor = self.outterCircleColor
        }
    }
    
    /// Color of the inner circle.
    @IBInspectable public var innerCircleColor: UIColor = UIColor.white {
        
        didSet {
            
            self.activityIndicatorShader?.innerCircleColor = self.innerCircleColor
        }
    }
    
    /// Progress to start the 'refresh' animation. Possible values are within range [0, 1]. Works only if not animating.
    public var startingProgress: Float = 0.0 {
        
        didSet {
            
            guard !self.isAnimating else { return }
            
            self.animationPreviousTime = self.animationDuration * (Constants.biggenAnimationPortion + Constants.staticBigAnimationPortion) + self.animationDuration * Constants.smallenAnimationPortion * TimeInterval(self.startingProgress)
        }
    }
    
    //MARK: Methods
    
    /// Stops animation when full.
    public func stopAnimatingWhenFull() {
        
        self.requestedToStopWhenFull = true
        self.stopIfRequired()
    }
    
    //MARK: - Internal -
    //MARK: Properties
    
    internal override var shader: BaseShader? {
        
        didSet {
            
            guard let nonnullShader = self.activityIndicatorShader else { return }
            
            nonnullShader.outterCircleColor = self.outterCircleColor
            nonnullShader.innerCircleColor = self.innerCircleColor
            nonnullShader.usesCustomColors = self.usesCustomColors
        }
    }
    
    internal override var animationPreviousTime: TimeInterval {
        
        didSet {
            
            self.stopIfRequired()
        }
    }
    
    //MARK: Methods
    
    internal override func setup(_ context: EAGLContext?) {
        
        super.setup(context)
        
        self.animationDuration = 5.0
    }
    
    internal override func createShader(with ctx: EAGLContext) {
        
        self.shader = TapActivityIndicatorShader(context: ctx)
        super.createShader(with: ctx)
    }
    
    //MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let biggenAnimationPortion: TimeInterval = 0.4
        fileprivate static let staticBigAnimationPortion: TimeInterval = 0.1
        fileprivate static let smallenAnimationPortion: TimeInterval = 0.4
        
        @available(*, unavailable) private init() {}
    }
    
    //MARK: Properties
    
    private var activityIndicatorShader: TapActivityIndicatorShader? {
        
        return self.shader as? TapActivityIndicatorShader
    }
    
    private var requestedToStopWhenFull = false
    
    private var animationState: TapActivityIndicatorAnimationState {
        
        let time = self.animationPreviousTime.truncatingRemainder(dividingBy: self.animationDuration) / self.animationDuration
        
        if time < Constants.biggenAnimationPortion {
            
            return .growing
        }
        else if time < Constants.biggenAnimationPortion + Constants.staticBigAnimationPortion {
            
            return .staticBig
        }
        else if time < Constants.biggenAnimationPortion + Constants.staticBigAnimationPortion + Constants.smallenAnimationPortion {
            
            return .shrinking
        }
        else {
            
            return .staticSmall
        }
    }
    
    //MARK: Methods
    
    private func stopIfRequired() {
        
        guard self.requestedToStopWhenFull else { return }
        
        if self.animationState == .staticBig {
            
            self.stopAnimating()
            self.requestedToStopWhenFull = false
        }
    }
}
