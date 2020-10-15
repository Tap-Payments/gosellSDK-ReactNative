//
//  LinearGradientShader.swift
//  TapGLKit/LinearGradientView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func OpenGLES.ES2.gl.glGetUniformLocation
import struct OpenGLES.ES2.gl.GLfloat
import struct OpenGLES.ES2.gl.GLint
import class UIKit.UIColor.UIColor

/// Linear Gradient Shader
internal class LinearGradientShader: BaseShader {
    
    //MARK: - Internal -
    //MARK: Properties
    
    internal var firstColor: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.firstColorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.firstColorComponents = components
            }
        }
    }
    
    internal var secondColor: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.secondColorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.secondColorComponents = components
            }
        }
    }
    
    internal var gradientDirection: GradientDirection = .topToBottom {
        
        didSet {
            
            guard self.readyToBeUsed && self.gradientDirection != oldValue else { return }
            self.setInt(self.gradientDirection == .topToBottom ? 1 : 0, to: self.gradientDirectionUniform)
        }
    }
    
    internal override class var source: ShaderSource {
        
        return shaderSource
    }
    
    //MARK: Methods
    
    internal override func obtainAttributesAndUniforms() {
        
        super.obtainAttributesAndUniforms()
        
        self.firstColorUniform        = glGetUniformLocation(self.program, Constants.firstColorUniformKey)
        self.secondColorUniform       = glGetUniformLocation(self.program, Constants.secondColorUniformKey)
        self.gradientDirectionUniform = glGetUniformLocation(self.program, Constants.gradientDirectionUniformKey)
    }
    
    override func loadInitialValues() {
        
        super.loadInitialValues()
        
        self.setVec4(self.firstColorComponents, to: self.firstColorUniform)
        self.setVec4(self.secondColorComponents, to: self.secondColorUniform)
        self.setInt(self.gradientDirection == .topToBottom ? 1 : 0, to: self.gradientDirectionUniform)
    }
    
    //MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let firstColorUniformKey        = "firstColor"
        fileprivate static let secondColorUniformKey       = "secondColor"
        fileprivate static let gradientDirectionUniformKey = "gradientDirection"
        
        @available(*, unavailable) private init() {}
    }
    
    //MARK: Properties
    
    private var firstColorComponents:  [GLfloat] = UIColor.black.tap_glComponents! {
        
        didSet {
            
            guard self.readyToBeUsed && self.firstColorComponents != oldValue else { return }
            self.setVec4(self.firstColorComponents, to: self.firstColorUniform)
        }
    }
    
    private var secondColorComponents: [GLfloat] = UIColor.black.tap_glComponents! {
        
        didSet {
            
            guard self.readyToBeUsed && self.secondColorComponents != oldValue else { return }
            self.setVec4(self.secondColorComponents, to: self.secondColorUniform)
        }
    }
    
    private var firstColorUniform:        GLint!
    private var secondColorUniform:       GLint!
    private var gradientDirectionUniform: GLint!
}

private let shaderSource: ShaderSource = {
    
    let vertex =

"""
//
//  TapGLKit/LinearGradientView
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
//  TapGLKit/LinearGradientView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

uniform highp vec2 resolution;
uniform highp vec4 firstColor;
uniform highp vec4 secondColor;
uniform       int  gradientDirection;

const         int topToBottom = 1;

//MARK: Main

void main() {
    
    highp float progress = gradientDirection == topToBottom ? 1.0 - gl_FragCoord.y / resolution.y : gl_FragCoord.x / resolution.x;
    gl_FragColor = mix(firstColor, secondColor, progress);
}

"""
    
    return ShaderSource(vertex: vertex, fragment: fragment)
}()
