//
//  RadialGradientShader.swift
//  TapGLKit/RadialGradientView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func OpenGLES.ES2.gl.glGetUniformLocation
import struct OpenGLES.ES2.gl.GLfloat
import struct OpenGLES.ES2.gl.GLint
import class UIKit.UIColor.UIColor

/// Radial Gradient shader class
internal class RadialGradientShader: BaseShader {
    
    // MARK: - Internal -
    // MARK: Properties
    
    /// Center color.
    internal var centerColor: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.centerColorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.centerColorComponents = components
            }
        }
    }
    
    /// Corner color.
    internal var cornerColor: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.cornerColorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.cornerColorComponents = components
            }
        }
    }
    
    internal override class var source: ShaderSource {
        
        return shaderSource
    }
    
    // MARK: Methods
    
    internal override func obtainAttributesAndUniforms() {
        
        super.obtainAttributesAndUniforms()
        
        self.centerColorUniform = glGetUniformLocation(self.program, Constants.centerColorUniformKey)
        self.cornerColorUniform = glGetUniformLocation(self.program, Constants.cornerColorUniformKey)
    }
    
    internal override func loadInitialValues() {
        
        super.loadInitialValues()
        
        self.setVec4(self.centerColorComponents, to: self.centerColorUniform)
        self.setVec4(self.cornerColorComponents, to: self.cornerColorUniform)
    }
    
    // MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let centerColorUniformKey = "centerColor"
        fileprivate static let cornerColorUniformKey = "cornerColor"
        
        @available(*, unavailable) private init() {}
    }
    
    // MARK: Properties
    
    private var centerColorComponents: [GLfloat] = UIColor.white.tap_glComponents! {
        
        didSet {
            
            guard self.readyToBeUsed && self.centerColorComponents != oldValue else { return }
            self.setVec4(self.centerColorComponents, to: self.centerColorUniform)
        }
    }
    
    private var cornerColorComponents: [GLfloat] = UIColor.black.tap_glComponents! {
        
        didSet {
            
            guard self.readyToBeUsed && self.cornerColorComponents != oldValue else { return }
            self.setVec4(self.cornerColorComponents, to: self.cornerColorUniform)
        }
    }
    
    private var centerColorUniform: GLint!
    private var cornerColorUniform: GLint!
}

private let shaderSource: ShaderSource = {
    
    let vertex =
        
    """
//
//  TapGLKit/RadialGradientView
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
//  TapGLKit/RadialGradientView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

uniform highp vec2 resolution;
uniform highp vec4 centerColor;
uniform highp vec4 cornerColor;

void main(void) {
    
    highp vec2 position = gl_FragCoord.xy;
    highp vec2 center = vec2(resolution.x / 2.0, resolution.y / 2.0);
    
    highp float maxDistance = distance(vec2(0.0, 0.0), center);
    highp float currentDistance = distance(position, center);
    
    highp float progress = currentDistance / maxDistance;
    
    gl_FragColor = mix(centerColor, cornerColor, progress);
}

"""
    return ShaderSource(vertex: vertex, fragment: fragment)
}()
