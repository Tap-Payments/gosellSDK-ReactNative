//
//  GLUniformSetter.swift
//  TapGLKit/Core
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import class	OpenGLES.EAGL.EAGLContext
import func		OpenGLES.ES2.gl.glUniform1f
import func		OpenGLES.ES2.gl.glUniform2f
import func		OpenGLES.ES2.gl.glUniform2fv
import func		OpenGLES.ES2.gl.glUniform4f
import func		OpenGLES.ES2.gl.glUniform1i
import struct	OpenGLES.ES2.gl.GLfloat
import struct	OpenGLES.ES2.gl.GLint
import struct	OpenGLES.ES2.gl.GLsizei

/// Protocol to set up uniforms.
internal protocol GLUniformSetter: class {
    
    //MARK: - Internal -
    //MARK: Properties
    
    /// Defines if there are drawable changes ( to defines whether need to draw )
    var hasDrawableChanges: Bool { get set }
    
    /// Context.
    var context: EAGLContext { get }
}

internal extension GLUniformSetter {

    //MARK: - Internal -
    //MARK: Methods
    
    func setInt(_ value: GLint, to uniform: GLint) {
    
        self.setContextAsCurrent()
        glUniform1i(uniform, value)
        
        self.hasDrawableChanges = true
    }
    
    func setFloat(_ value: GLfloat, to uniform: GLint) {
        
        self.setContextAsCurrent()
        glUniform1f(uniform, value)
        
        self.hasDrawableChanges = true
    }
    
    func setVec2(_ value: [GLfloat], to uniform: GLint) {
        
        self.setContextAsCurrent()
        glUniform2f(uniform, value[0], value[1])
        
        self.hasDrawableChanges = true
    }
    
    func setVec4(_ value: [GLfloat], to uniform: GLint) {
        
        self.setContextAsCurrent()
        glUniform4f(uniform, value[0], value[1], value[2], value[3])
        
        self.hasDrawableChanges = true
    }
    
    func setVec2Array(_ value: [GLfloat], to uniform: GLint) {
        
        self.setContextAsCurrent()
        
        let count = GLsizei(value.count / 2)
        
        glUniform2fv(uniform, count, value)
        
        self.hasDrawableChanges = true
    }
    
    func setContextAsCurrent() {
        
        if EAGLContext.current() != self.context {
            
            EAGLContext.setCurrent(self.context)
        }
    }
}
