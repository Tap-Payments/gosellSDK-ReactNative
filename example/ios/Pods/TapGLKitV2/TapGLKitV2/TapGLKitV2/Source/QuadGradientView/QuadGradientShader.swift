//
//  QuadGradientShader.swift
//  TapGLKit/QuadGradientView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func		OpenGLES.ES2.gl.glGetUniformLocation
import struct	OpenGLES.ES2.gl.GLfloat
import struct	OpenGLES.ES2.gl.GLint
import class	UIKit.UIColor.UIColor

/// Quad Gradient shader.
internal class QuadGradientShader: BaseShader {

    //MARK: - Internal -
    //MARK: Properties
    
    internal var topLeftColor: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.topLeftColorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.topLeftColorComponents = components
            }
        }
    }
    
    internal var topRightColor: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.topRightColorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.topRightColorComponents = components
            }
        }
    }
    
    internal var bottomLeftColor: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.bottomLeftColorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.bottomLeftColorComponents = components
            }
        }
    }
    
    internal var bottomRightColor: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.bottomRightColorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.bottomRightColorComponents = components
            }
        }
    }
    
    internal override class var source: ShaderSource {
        
        return shaderSource
    }
    
    //MARK: Methods
    
    internal override func obtainAttributesAndUniforms() {
        
        super.obtainAttributesAndUniforms()
        
        self.topLeftColorUniform     = glGetUniformLocation(self.program, Constants.topLeftColorUniformKey)
        self.topRightColorUniform    = glGetUniformLocation(self.program, Constants.topRightColorUniformKey)
        self.bottomLeftColorUniform  = glGetUniformLocation(self.program, Constants.bottomLeftColorUniformKey)
        self.bottomRightColorUniform = glGetUniformLocation(self.program, Constants.bottomRightColorUniformKey)
    }
    
    override func loadInitialValues() {
        
        super.loadInitialValues()
        
        self.setVec4(self.topLeftColorComponents, to: self.topLeftColorUniform)
        self.setVec4(self.topRightColorComponents, to: self.topRightColorUniform)
        self.setVec4(self.bottomLeftColorComponents, to: self.bottomLeftColorUniform)
        self.setVec4(self.bottomRightColorComponents, to: self.bottomRightColorUniform)
    }
    
    //MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let topLeftColorUniformKey     = "topLeftColor"
        fileprivate static let topRightColorUniformKey    = "topRightColor"
        fileprivate static let bottomLeftColorUniformKey  = "bottomLeftColor"
        fileprivate static let bottomRightColorUniformKey = "bottomRightColor"
        
        @available(*, unavailable) private init() {}
    }
    
    //MARK: Properties
    
    private var topLeftColorComponents: [GLfloat] = UIColor.black.tap_glComponents! {
        
        didSet {
            
            guard self.readyToBeUsed && self.topLeftColorComponents != oldValue else { return }
            self.setVec4(self.topLeftColorComponents, to: self.topLeftColorUniform)
        }
    }
    
    private var topRightColorComponents: [GLfloat] = UIColor.black.tap_glComponents! {
        
        didSet {
            
            guard self.readyToBeUsed && self.topRightColorComponents != oldValue else { return }
            self.setVec4(self.topRightColorComponents, to: self.topRightColorUniform)
        }
    }
    
    private var bottomLeftColorComponents: [GLfloat] = UIColor.black.tap_glComponents! {
        
        didSet {
            
            guard self.readyToBeUsed && self.bottomLeftColorComponents != oldValue else { return }
            self.setVec4(self.bottomLeftColorComponents, to: self.bottomLeftColorUniform)
        }
    }
    
    private var bottomRightColorComponents: [GLfloat] = UIColor.black.tap_glComponents! {
        
        didSet {
            
            guard self.readyToBeUsed && self.bottomRightColorComponents != oldValue else { return }
            self.setVec4(self.bottomRightColorComponents, to: self.bottomRightColorUniform)
        }
    }
    
    private var topLeftColorUniform: GLint!
    private var topRightColorUniform: GLint!
    private var bottomLeftColorUniform: GLint!
    private var bottomRightColorUniform: GLint!
}

private let shaderSource: ShaderSource = {
    
    let vertex =
    
"""
//
//  TapGLKit/QuadGradientView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

attribute highp vec2 position;

void main(void) {
    
    gl_Position = vec4(position, 0.0, 1.0);
}

"""
    
    let fragment =
        
"""
//
//  TapGLKit/QuadGradientView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

uniform highp vec2 resolution;
uniform highp vec4 topLeftColor;
uniform highp vec4 topRightColor;
uniform highp vec4 bottomLeftColor;
uniform highp vec4 bottomRightColor;

//MARK: Function Definitions

highp vec4 interpolateColors(highp vec4 color1, highp vec4 color2, highp float progress);
highp float interpolateValue(highp float value1, highp float value2, highp float progress);

//MARK: Main

void main() {
    
    highp vec2 position = gl_FragCoord.xy;
    
    highp vec2 progress = vec2(position.x / resolution.x, position.y / resolution.y);
    
    highp vec4 topBorderColor = interpolateColors(topLeftColor, topRightColor, progress.x);
    highp vec4 bottomBorderColor = interpolateColors(bottomLeftColor, bottomRightColor, progress.x);
    highp vec4 horizontalColor = interpolateColors(bottomBorderColor, topBorderColor, progress.y);
    
    highp vec4 leftBorderColor = interpolateColors(bottomLeftColor, topLeftColor, progress.y);
    highp vec4 rightBorderColor = interpolateColors(bottomRightColor, topRightColor, progress.y);
    highp vec4 verticalColor = interpolateColors(leftBorderColor, rightBorderColor, progress.x);
    
    gl_FragColor = 0.5 * ( horizontalColor + verticalColor );
}

//MARK: Functions

highp vec4 interpolateColors(highp vec4 color1, highp vec4 color2, highp float progress) {
    
    return vec4(interpolateValue(color1.x, color2.x, progress), interpolateValue(color1.y, color2.y, progress), interpolateValue(color1.z, color2.z, progress), interpolateValue(color1.w, color2.w, progress));
}

highp float interpolateValue(highp float value1, highp float value2, highp float progress) {
    
    return value1 + (value2 - value1) * progress;
}

"""

    return ShaderSource(vertex: vertex, fragment: fragment)
}()
