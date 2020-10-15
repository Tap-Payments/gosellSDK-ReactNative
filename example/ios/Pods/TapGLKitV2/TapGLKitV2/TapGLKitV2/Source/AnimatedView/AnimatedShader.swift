//
//  AnimatedShader.swift
//  TapGLKit/AnimatedView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func OpenGLES.ES2.gl.glGetUniformLocation
import struct OpenGLES.ES2.gl.GLfloat
import struct OpenGLES.ES2.gl.GLint
import func QuartzCore.CABase.CACurrentMediaTime

/// Animated shader.
internal class AnimatedShader: BaseShader {

    //MARK: - Internal -
    //MARK: Properties
    
    internal var time: TimeInterval = CACurrentMediaTime() {
        
        didSet {
            
            guard self.readyToBeUsed && self.time != oldValue else { return }
            self.setFloat(GLfloat(self.time), to: self.timeUniform)
        }
    }
    
    internal var animationDuration: TimeInterval = 1.0 {
        
        didSet {
            
            guard self.readyToBeUsed && self.animationDuration != oldValue else { return }
            self.setFloat(GLfloat(self.animationDuration), to: self.animationDurationUniform)
        }
    }
    
    //MARK: Methods
    
    override func obtainAttributesAndUniforms() {
        
        super.obtainAttributesAndUniforms()
        
        self.animationDurationUniform  = glGetUniformLocation(self.program, Constants.animationDurationUniformKey)
        self.timeUniform               = glGetUniformLocation(self.program, Constants.timeUniformKey)
    }
    
    override func loadInitialValues() {
        
        super.loadInitialValues()
        
        self.setFloat(GLfloat(self.time), to: self.timeUniform)
        self.setFloat(GLfloat(self.animationDuration), to: self.animationDurationUniform)
    }
    
    //MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let animationDurationUniformKey = "animationDuration"
        fileprivate static let timeUniformKey = "time"
        
        @available(*, unavailable) private init() {}
    }
    
    //MARK: Properties
    
    private var animationDurationUniform: GLint!
    private var timeUniform:              GLint!
}
