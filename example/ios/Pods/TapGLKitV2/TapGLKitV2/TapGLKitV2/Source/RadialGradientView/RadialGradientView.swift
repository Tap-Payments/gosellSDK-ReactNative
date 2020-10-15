//
//  RadialGradientView.swift
//  TapGLKit/RadialGradientView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class OpenGLES.EAGL.EAGLContext
import class UIKit.UIColor.UIColor

/// Radial Gradient View.
@IBDesignable public class RadialGradientView: BaseGLView {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Center color.
    @IBInspectable public var centerColor: UIColor = .white {
        
        didSet {
            
            self.radialShader?.centerColor = self.centerColor
            self.display()
        }
    }
    
    /// Corner color.
    @IBInspectable public var cornerColor: UIColor = .black {
        
        didSet {
            
            self.radialShader?.cornerColor = self.cornerColor
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
        
        self.shader = RadialGradientShader(context: ctx)
        super.createShader(with: ctx)
    }
    
    //MARK: - Private -
    //MARK: Properties
    
    private var radialShader: RadialGradientShader? {
        
        return self.shader as? RadialGradientShader
    }
}
