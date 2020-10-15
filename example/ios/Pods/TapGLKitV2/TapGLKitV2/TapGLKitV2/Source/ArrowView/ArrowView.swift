//
//  ArrowView.swift
//  TapGLKit/ArrowView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class OpenGLES.EAGL.EAGLContext
import class UIKit.UIColor.UIColor

/// Arrow view.
@IBDesignable public class ArrowView: AnimatedView {

    //MARK: - Public -
    //MARK: Properties
    
    @IBInspectable public var color: UIColor = UIColor.white {
        
        didSet {
            
            self.arrowShader?.color = self.color
        }
    }
    
    @IBInspectable @available(*, unavailable, message : "This is only for Interface Builder") internal var directionIB: Int {
        
        get {
            
            return self.direction.rawValue
        }
        set {
            
            if let aDirection = ArrowDirection(rawValue: newValue) {
                
                self.direction = aDirection
            }
        }
    }
    
    /// Arrow direction.
    public var direction: ArrowDirection = .leftToRight {
        
        didSet {
            
            self.arrowShader?.direction = self.direction
        }
    }
    
    /// Arrow thickness.
    @IBInspectable public var thickness: CGFloat = 2.0 {
        
        didSet {
            
            self.arrowShader?.thickness = self.thickness
        }
    }
    
    //MARK: - Internal -
    //MARK: Properties
    
    internal override var isEndless: Bool {
        
        return false
    }
    
    //MARK: Methods
    
    internal override func createShader(with ctx: EAGLContext) {
        
        self.shader = ArrowShader(context: ctx)
        super.createShader(with: ctx)
    }
    
    //MARK: - Private -
    //MARK: Properties
    
    private var arrowShader: ArrowShader? {
        
        return self.shader as? ArrowShader
    }
}
