//
//  BaseShader.swift
//  TapGLKit/Core
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import class    OpenGLES.EAGL.EAGLContext
import struct   OpenGLES.gltypes.GLenum
import func     OpenGLES.ES2.gl.glAttachShader
import func     OpenGLES.ES2.gl.glBindBuffer
import func     OpenGLES.ES2.gl.glBlendFunc
import func     OpenGLES.ES2.gl.glBufferData
import func     OpenGLES.ES2.gl.glClear
import func     OpenGLES.ES2.gl.glClearColor
import func     OpenGLES.ES2.gl.glCompileShader
import func     OpenGLES.ES2.gl.glCreateProgram
import func     OpenGLES.ES2.gl.glCreateShader
import func     OpenGLES.ES2.gl.glDepthFunc
import func     OpenGLES.ES2.gl.glDepthMask
import func     OpenGLES.ES2.gl.glDisable
import func     OpenGLES.ES2.gl.glDrawArrays
import func     OpenGLES.ES2.gl.glDeleteShader
import func     OpenGLES.ES2.gl.glEnable
import func     OpenGLES.ES2.gl.glEnableVertexAttribArray
import func     OpenGLES.ES2.gl.glGenBuffers
import func     OpenGLES.ES2.gl.glGetAttribLocation
import func     OpenGLES.ES2.gl.glGetProgramInfoLog
import func     OpenGLES.ES2.gl.glGetProgramiv
import func     OpenGLES.ES2.gl.glGetUniformLocation
import func     OpenGLES.ES2.gl.glLinkProgram
import func     OpenGLES.ES2.gl.glGetShaderInfoLog
import func     OpenGLES.ES2.gl.glGetShaderiv
import func     OpenGLES.ES2.gl.glShaderSource
import func     OpenGLES.ES2.gl.glUseProgram
import func     OpenGLES.ES2.gl.glVertexAttribPointer
import var      OpenGLES.ES2.gl.GL_ARRAY_BUFFER
import var      OpenGLES.ES2.gl.GL_BLEND
import var      OpenGLES.ES2.gl.GL_COLOR_BUFFER_BIT
import var      OpenGLES.ES2.gl.GL_COMPILE_STATUS
import var      OpenGLES.ES2.gl.GL_DEPTH_TEST
import var      OpenGLES.ES2.gl.GL_ELEMENT_ARRAY_BUFFER
import var      OpenGLES.ES2.gl.GL_FALSE
import var      OpenGLES.ES2.gl.GL_FLOAT
import var      OpenGLES.ES2.gl.GL_FRAGMENT_SHADER
import var      OpenGLES.ES2.gl.GL_INFO_LOG_LENGTH
import var      OpenGLES.ES2.gl.GL_LEQUAL
import var      OpenGLES.ES2.gl.GL_LINK_STATUS
import var      OpenGLES.ES2.gl.GL_ONE_MINUS_SRC_ALPHA
import var      OpenGLES.ES2.gl.GL_SRC_ALPHA
import var      OpenGLES.ES2.gl.GL_STATIC_DRAW
import var      OpenGLES.ES2.gl.GL_TRIANGLE_STRIP
import var      OpenGLES.ES2.gl.GL_VERTEX_SHADER
import struct   OpenGLES.ES2.gl.GLbitfield
import struct   OpenGLES.ES2.gl.GLboolean
import struct   OpenGLES.gltypes.GLchar
import struct   OpenGLES.gltypes.GLfloat
import struct   OpenGLES.gltypes.GLint
import struct   OpenGLES.gltypes.GLsizei
import struct   OpenGLES.gltypes.GLubyte
import struct   OpenGLES.gltypes.GLuint
import struct	TapAdditionsKitV2.MemoryLayoutAdditions
import class    UIKit.UIColor.UIColor

/// Base shader class.
internal class BaseShader {
    
    //MARK: - Internal -
    //MARK: Properties
    
    internal class var source: ShaderSource {
        
        return ShaderSource(vertex: .tap_empty, fragment: .tap_empty)
    }
    
    internal var context: EAGLContext
    
    internal var program: GLuint!
    
    internal var backgroundColor: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.backgroundColorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.backgroundColorComponents = components
            }
        }
    }
    
    internal var renderingRect: CGRect = .zero {
        
        didSet {
            
            self.updateResolutionAndCenter()
        }
    }
    
    internal var renderingScale: CGFloat = 0.0 {
        
        didSet {
            
            self.updateResolutionAndCenter()
        }
    }
    
    internal var resolution: CGSize = .zero {
        
        didSet {
            
            guard self.readyToBeUsed && self.resolution != oldValue && self.resolution != .zero else { return }
            self.setVec2(self.resolution.tap_asVec2, to: self.resolutionUniform)
        }
    }
    
    internal var center: CGPoint = .zero {
        
        didSet {
            
            guard self.readyToBeUsed && self.center != oldValue && self.center != .zero else { return }
            self.setVec2(self.center.tap_asVec2, to: self.centerUniform)
        }
    }
    
    internal private(set) lazy var readyToBeUsed: Bool = false
    
    internal lazy var hasDrawableChanges: Bool = true
    
    //MARK: Methods
    
    internal required init(context aContext: EAGLContext) {
        
        self.context = aContext
        self.setContextAsCurrent()
        self.program = type(of: self).program(with: type(of: self).source)
        
        self.obtainAttributesAndUniforms()
        self.configureOpenGLES()
        
        self.readyToBeUsed = true
        
        self.loadInitialValues()
    }
    
    internal static func program(with source: ShaderSource) -> GLuint {
        
        let vShader = self.shader(with: source.vertex, type: GLenum(GL_VERTEX_SHADER))
        let fShader = self.shader(with: source.fragment, type: GLenum(GL_FRAGMENT_SHADER))
        
        let programHandle = glCreateProgram()
        glAttachShader(programHandle, vShader)
        glAttachShader(programHandle, fShader)
        
        glLinkProgram(programHandle)
        
        var linkStatus: GLint = 0
        glGetProgramiv(programHandle, GLenum(GL_LINK_STATUS), &linkStatus)
        if linkStatus == GL_FALSE {
            
            var messages = [GLchar](repeating: 0, count: 1024)
            
            let size = 1024 * MemoryLayoutAdditions.tap_sizeof(GLchar.self)
            glGetProgramInfoLog(programHandle, GLsizei(size), nil, &messages)
            
            print("error linking gl program: \(String(cString: messages))")
        }
        
        glDeleteShader(vShader)
        glDeleteShader(fShader)
        
        return programHandle
    }
    
    internal static func shader(with source: String, type: GLenum) -> GLuint {
        
        var sourceUTF8 = (source as NSString).utf8String
        var shaderStringLength = GLint((source as NSString).length)
        
        let shaderHandle = glCreateShader(type)
        glShaderSource(shaderHandle, 1, &sourceUTF8, &shaderStringLength)
        glCompileShader(shaderHandle)
        
        var compileSuccess: GLint = 0
        glGetShaderiv(shaderHandle, GLenum(GL_COMPILE_STATUS), &compileSuccess)
        
        if compileSuccess == GL_FALSE {
            
            var value: GLint = 0
            glGetShaderiv(shaderHandle, GLenum(GL_INFO_LOG_LENGTH), &value)
            var infoLog: [GLchar] = [GLchar](repeating: 0, count: Int(value))
            var infoLogLength: GLsizei = 0
            glGetShaderInfoLog(shaderHandle, value, &infoLogLength, &infoLog)
            let infoLogString = NSString(bytes: infoLog, length: Int(infoLogLength), encoding: String.Encoding.ascii.rawValue)
            
            print("Error compiling shader: \(infoLogString!)")
        }
        
        return shaderHandle
    }
    
    internal func configureOpenGLES() {
        
        glUseProgram(self.program)
        
        var vertexBuffer: GLuint = 0
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        
        let quadSize = MemoryLayoutAdditions.tap_sizeof(Constants.shaderQuad)
        glBufferData(GLenum(GL_ARRAY_BUFFER), quadSize, Constants.shaderQuad, GLenum(GL_STATIC_DRAW))
        
        var indicesBuffer: GLuint = 0
        glGenBuffers(1, &indicesBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indicesBuffer)
        
        let indicesSize = MemoryLayoutAdditions.tap_sizeof(Constants.shaderIndices)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indicesSize, Constants.shaderIndices, GLenum(GL_STATIC_DRAW))
        
        glEnableVertexAttribArray(GLuint(self.positionAttribute))
        
        let doubleQuadSize = 2 * MemoryLayoutAdditions.tap_sizeof(Constants.shaderQuad[0])
        glVertexAttribPointer(GLuint(self.positionAttribute), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), GLsizei(doubleQuadSize), UnsafeRawPointer(bitPattern: 0))
        
        glDisable(GLenum(GL_DEPTH_TEST))
        glDepthMask(GLboolean(GL_FALSE))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        glDepthFunc(GLenum(GL_LEQUAL))
    }
    
    internal func obtainAttributesAndUniforms() {
        
        self.positionAttribute = glGetAttribLocation(self.program, Constants.positionAttributeKey)
        self.resolutionUniform = glGetUniformLocation(self.program, Constants.resolutionUniformKey)
        self.centerUniform = glGetUniformLocation(self.program, Constants.centerUniformKey)
    }
    
    internal func loadInitialValues() {
        
        glClearColor(self.backgroundColorComponents[0], self.backgroundColorComponents[1], self.backgroundColorComponents[2], self.backgroundColorComponents[3])
        
        self.setVec2(self.resolution.tap_asVec2, to: self.resolutionUniform)
        self.setVec2(self.center.tap_asVec2, to: self.centerUniform)
    }
    
    internal func render() {
     
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
        
        self.hasDrawableChanges = false
    }
    
    //MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let shaderQuad: [GLfloat] = [
            
            -1.0, -1.0,
            -1.0,  1.0,
            1.0, -1.0,
            1.0,  1.0
        ]
        
        fileprivate static let shaderIndices: [GLubyte] = [
            
            0, 1, 2,
            2, 3, 0
        ]
        
        fileprivate static let positionAttributeKey = "position"
        fileprivate static let resolutionUniformKey = "resolution"
        fileprivate static let centerUniformKey = "center"
        
        @available(*, unavailable) private init() {}
    }
    
    //MARK: Properties
    
    private var positionAttribute: GLint!
    private var resolutionUniform: GLint!
    private var centerUniform: GLint!
    
    private var backgroundColorComponents: [GLfloat] = UIColor.clear.tap_glComponents! {
        
        didSet {
            
            guard self.readyToBeUsed && self.backgroundColorComponents != oldValue else { return }
            glClearColor(self.backgroundColorComponents[0], self.backgroundColorComponents[1], self.backgroundColorComponents[2], self.backgroundColorComponents[3])
        }
    }
    
    // MARK: Methods
    
    private func updateResolutionAndCenter() {
        
		self.resolution = CGSize(width: self.renderingScale * self.renderingRect.size.width, height: self.renderingScale * self.renderingRect.size.height)
		self.center     = CGPoint(x: 0.5 * self.resolution.width, y: 0.5 * self.resolution.height)
    }
}

// MARK: - GLUniformSetter
extension BaseShader: GLUniformSetter {}
