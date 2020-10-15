//
//  QuadGradientView.swift
//  TapGLKit/QuadGradientView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class OpenGLES.EAGL.EAGLContext
import class UIKit.UIColor.UIColor

/// Quad corners gradient view.
@IBDesignable public class QuadGradientView: BaseGLView {

    //MARK: - Public -
    //MARK: Properties
    
    /// Top left color.
    @IBInspectable public var topLeftColor: UIColor = UIColor.black {
        
        didSet {
            
            self.quadGradientShader?.topLeftColor = self.topLeftColor
            self.display()
        }
    }
    
    /// Top right color.
    @IBInspectable public var topRightColor: UIColor = UIColor.black {
        
        didSet {
            
            self.quadGradientShader?.topRightColor = self.topRightColor
            self.display()
        }
    }
    
    /// Bottom left color.
    @IBInspectable public var bottomLeftColor: UIColor = UIColor.black {
        
        didSet {
            
            self.quadGradientShader?.bottomLeftColor = self.bottomLeftColor
            self.display()
        }
    }
    
    /// Bottom right color.
    @IBInspectable public var bottomRightColor: UIColor = UIColor.black {
        
        didSet {
            
            self.quadGradientShader?.bottomRightColor = self.bottomRightColor
            self.display()
        }
    }
    
    //MARK: - Internal -
    //MARK: Properties
    
    internal override var drawsDynamically: Bool {
        
        return false
    }
    
    //MARK: Methods
    
    internal override func createShader(with ctx: EAGLContext) {
        
        self.shader = QuadGradientShader(context: ctx)
        super.createShader(with: ctx)
    }
    
    //MARK: - Private -
    //MARK: Properties
    
    private var quadGradientShader: QuadGradientShader? {
        
        return self.shader as? QuadGradientShader
    }
}
