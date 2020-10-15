//
//  ArrowShader.swift
//  TapGLKit/ArrowView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import CoreGraphics
import func OpenGLES.ES2.gl.glGetUniformLocation
import struct OpenGLES.ES2.gl.GLfloat
import struct OpenGLES.ES2.gl.GLint
import class UIKit.UIColor.UIColor

/// Arrow Shader class.
internal class ArrowShader: AnimatedShader {
    
    //MARK: - Internal -
    //MARK: Properties
    
    internal var color: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.colorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.colorComponents = components
            }
        }
    }
    
    internal var direction: ArrowDirection = .leftToRight {
        
        didSet {
            
            self.straight = self.direction.isStraight
            self.startPoint01 = self.direction.startPoint
            self.maxAllowedDrawingDistance01 = self.direction.maximalAllowedDrawingDistance
            self.endArrowDirection = self.direction.endDirection
            
            self.updateRoundedArrowDrawingSegment()
            self.updateMaximalAllowedDrawingDistance()
            self.updateStartDrawingPoint()
            
            self.updateNormalizedEndArrowDirection()
            self.updateArrowEndPoint()
            self.updateArrowHeadTriangleCoordinates()
            self.updateRoundedArrowRadius()
            self.updateRoundedArrowCircleCenter()
            self.updateStraightArrowStartPoint()
            self.updateRoundedArrowStraightSegmentCoordinates()
        }
    }
    
    internal override var resolution: CGSize {
        
        didSet {
            
            self.updateMaximalAllowedDrawingDistance()
            self.updateStartDrawingPoint()
            self.updateNormalizedEndArrowDirection()
            self.updateArrowEndPoint()
            self.updateArrowHeadTriangleCoordinates()
            self.updateRoundedArrowRadius()
            self.updateRoundedArrowCircleCenter()
            self.updateStraightArrowStartPoint()
            self.updateRoundedArrowStraightSegmentCoordinates()
        }
    }
    
    internal var thickness: CGFloat = 2.0 {
        
        didSet {
            
            self.renderingThickness = self.thickness * self.renderingScale
            
            self.updateArrowHeadLengthAndWidth()
            self.updateArrowEndPoint()
            self.updateArrowHeadTriangleCoordinates()
            self.updateRoundedArrowRadius()
            self.updateRoundedArrowCircleCenter()
            self.updateStraightArrowStartPoint()
            self.updateRoundedArrowStraightSegmentCoordinates()
        }
    }
    
    internal override var renderingScale: CGFloat {
        
        didSet {
            
            self.renderingThickness = self.thickness * self.renderingScale
            
            self.updateArrowHeadLengthAndWidth()
            self.updateArrowEndPoint()
            self.updateArrowHeadTriangleCoordinates()
            self.updateRoundedArrowRadius()
            self.updateRoundedArrowCircleCenter()
            self.updateStraightArrowStartPoint()
            self.updateRoundedArrowStraightSegmentCoordinates()
        }
    }
    
    internal override var time: TimeInterval {
        
        didSet {
            
            self.updateMaximalAllowedDrawingDistance()
        }
    }
    
    internal override var animationDuration: TimeInterval {
        
        didSet {
            
            self.updateMaximalAllowedDrawingDistance()
        }
    }
    
    internal override class var source: ShaderSource {
        
        return shaderSource
    }
    
    //MARK: Methods
    
    internal override func obtainAttributesAndUniforms() {
        
        super.obtainAttributesAndUniforms()
        
        self.colorUniform                                  = glGetUniformLocation(self.program, Constants.colorUniformKey)
        self.thicknessUniform                              = glGetUniformLocation(self.program, Constants.thicknessUniformKey)
        self.straightUniform                               = glGetUniformLocation(self.program, Constants.straightUniformKey)
        self.maximalAllowedDrawingDistanceSquaredUniform   = glGetUniformLocation(self.program, Constants.maximalAllowedDrawingDistanceSquaredUniformKey)
        self.startDrawingPointUniform                      = glGetUniformLocation(self.program, Constants.startDrawingPointUniformKey)
        self.arrowHeadTriangleCoordinatesUniform           = glGetUniformLocation(self.program, Constants.arrowHeadTriangleCoordinatesUniformKey)
        self.straightArrowStartPointUniform                = glGetUniformLocation(self.program, Constants.straightArrowStartPointUniformKey)
        self.arrowEndPointUniform                          = glGetUniformLocation(self.program, Constants.arrowEndPointUniformKey)
        self.roundedArrowRadiusUniform                     = glGetUniformLocation(self.program, Constants.roundedArrowRadiusUniformKey)
        self.roundedArrowCircleCenterUniform               = glGetUniformLocation(self.program, Constants.roundedArrowCircleCenterUniformKey)
        self.roundedArrowDrawingSegmentUniform             = glGetUniformLocation(self.program, Constants.roundedArrowDrawingSegmentUniformKey)
        self.roundedArrowStraightSegmentCoordinatesUniform = glGetUniformLocation(self.program, Constants.roundedArrowStraightSegmentCoordinatesUniformKey)
    }
    
    internal override func loadInitialValues() {
        
        super.loadInitialValues()
        
        self.setVec4(self.colorComponents, to: self.colorUniform)
        self.setFloat(GLfloat(self.renderingThickness), to: self.thicknessUniform)
        self.setInt(self.straight ? 1 : 0, to: self.straightUniform)
        self.setFloat(GLfloat(self.maximalAllowedDrawingDistanceSquared), to: self.maximalAllowedDrawingDistanceSquaredUniform)
        self.setVec2(self.startDrawingPoint.tap_asVec2, to: self.startDrawingPointUniform)
        self.setVec2Array(self.arrowHeadTriangleCoordinates, to: self.arrowHeadTriangleCoordinatesUniform)
        self.setVec2(self.straightArrowStartPoint.tap_asVec2, to: self.straightArrowStartPointUniform)
        self.setVec2(self.arrowEndPoint.tap_asVec2, to: self.arrowEndPointUniform)
        self.setFloat(GLfloat(self.roundedArrowRadius), to: self.roundedArrowCircleCenterUniform)
        self.setVec2(self.roundedArrowCircleCenter.tap_asVec2, to: self.roundedArrowCircleCenterUniform)
        self.setVec2(self.roundedArrowDrawingSegment.tap_asVec2, to: self.roundedArrowDrawingSegmentUniform)
        self.setVec2Array(self.roundedArrowStraightSegmentCoordinates, to: self.roundedArrowStraightSegmentCoordinatesUniform)
    }
    
    //MARK: - Private -

    private struct Constants {
        
        fileprivate static let colorUniformKey                                  = "color"
        fileprivate static let endArrowDirectionUniformKey                      = "endArrowDirection"
        fileprivate static let straightUniformKey                               = "straight"
        fileprivate static let thicknessUniformKey                              = "thickness"
        fileprivate static let maximalAllowedDrawingDistanceSquaredUniformKey   = "maximalAllowedDrawingDistanceSquared"
        fileprivate static let startDrawingPointUniformKey                      = "startDrawingPoint"
        fileprivate static let arrowHeadTriangleCoordinatesUniformKey           = "arrowHeadTriangleCoordinates"
        fileprivate static let normalizedEndArrowDirectionUniformKey            = "normalizedEndArrowDirection"
        fileprivate static let straightArrowStartPointUniformKey                = "straightArrowStartPoint"
        fileprivate static let arrowEndPointUniformKey                          = "arrowEndPoint"
        fileprivate static let roundedArrowRadiusUniformKey                     = "roundedArrowRadius"
        fileprivate static let roundedArrowCircleCenterUniformKey               = "roundedArrowCircleCenter"
        fileprivate static let arrowHeadLengthUniformKey                        = "arrowHeadLength"
        fileprivate static let arrowHeadWidthUniformKey                         = "arrowHeadWidth"
        fileprivate static let roundedArrowDrawingSegmentUniformKey             = "roundedArrowDrawingSegment"
        fileprivate static let roundedArrowStraightSegmentCoordinatesUniformKey = "roundedArrowStraightSegmentCoordinates"
        
        fileprivate static let arrowAngle = 0.2 * CGFloat.pi
        fileprivate static let smoothingDistance: CGFloat = 2.0
        fileprivate static let epsilon: CGFloat = 0.5
        
        @available(*, unavailable) private init() {}
    }
    
    //MARK: Properties
    
    private var renderingThickness: CGFloat = 0.0 {
        
        didSet {
            
            guard self.readyToBeUsed && self.renderingThickness != oldValue else { return }
            self.setFloat(GLfloat(self.renderingThickness), to: self.thicknessUniform)
        }
    }
    
    private var colorComponents: [GLfloat] = UIColor.white.tap_glComponents! {
        
        didSet {
            
            guard self.readyToBeUsed && self.colorComponents != oldValue else { return }
            self.setVec4(self.colorComponents, to: self.colorUniform)
        }
    }
    
    private var straight: Bool = false {
        
        didSet {
            
            guard self.readyToBeUsed && self.straight != oldValue else { return }
            self.setInt(self.straight ? 1 : 0, to: self.straightUniform)
        }
    }
    
    private var startPoint01: CGPoint = .zero
    private var maxAllowedDrawingDistance01: CGPoint = .zero
    
    private var endArrowDirection: CGPoint = ArrowDirection.leftToRight.endDirection
    
    private var maximalAllowedDrawingDistanceSquared: CGFloat = 0.0 {
        
        didSet {
            
            guard self.readyToBeUsed && self.maximalAllowedDrawingDistanceSquared != oldValue else { return }
            self.setFloat(GLfloat(self.maximalAllowedDrawingDistanceSquared), to: self.maximalAllowedDrawingDistanceSquaredUniform)
        }
    }
    
    private var startDrawingPoint: CGPoint = .zero {
        
        didSet {
            
            guard self.readyToBeUsed && self.startDrawingPoint != oldValue else { return }
            self.setVec2(self.startDrawingPoint.tap_asVec2, to: self.startDrawingPointUniform)
        }
    }
    
    private var arrowHeadTriangleCoordinates: [GLfloat] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0] {
        
        didSet {
            
            guard self.readyToBeUsed && self.arrowHeadTriangleCoordinates != oldValue else { return }
            self.setVec2Array(self.arrowHeadTriangleCoordinates, to: self.arrowHeadTriangleCoordinatesUniform)
        }
    }
    
    private var normalizedEndArrowDirection: CGPoint = CGPoint(x: 1.0, y: 0.0)
    
    private var straightArrowStartPoint: CGPoint = .zero {
        
        didSet {
            
            guard self.readyToBeUsed && self.straightArrowStartPoint != oldValue else { return }
            self.setVec2(self.straightArrowStartPoint.tap_asVec2, to: self.straightArrowStartPointUniform)
        }
    }
    
    private var arrowEndPoint: CGPoint = .zero {
        
        didSet {
            
            guard self.readyToBeUsed && self.arrowEndPoint != oldValue else { return }
            self.setVec2(self.arrowEndPoint.tap_asVec2, to: self.arrowEndPointUniform)
        }
    }
    
    private var roundedArrowRadius: CGFloat = 0.0 {
        
        didSet {
            
            guard self.readyToBeUsed && self.roundedArrowRadius != oldValue else { return }
            self.setFloat(GLfloat(self.roundedArrowRadius), to: self.roundedArrowRadiusUniform)
        }
    }
    
    private var roundedArrowCircleCenter: CGPoint = .zero {
        
        didSet {
            
            guard self.readyToBeUsed && self.roundedArrowCircleCenter != oldValue else { return }
            self.setVec2(self.roundedArrowCircleCenter.tap_asVec2, to: self.roundedArrowCircleCenterUniform)
        }
    }
    
    private var arrowHeadLength: CGFloat = 0.0
    private var arrowHeadWidth: CGFloat = 0.0
    
    private var roundedArrowDrawingSegment: CGPoint = CGPoint(x: 0.0, y: 0.0) {
        
        didSet {
            
            guard self.readyToBeUsed && self.roundedArrowDrawingSegment != oldValue else { return }
            self.setVec2(self.roundedArrowDrawingSegment.tap_asVec2, to: self.roundedArrowDrawingSegmentUniform)
        }
    }
    
    private var roundedArrowStraightSegmentCoordinates: [GLfloat] = [0.0, 0.0, 0.0, 0.0] {
        
        didSet {
            
            guard self.readyToBeUsed && self.roundedArrowStraightSegmentCoordinates != oldValue else { return }
            self.setVec2Array(self.roundedArrowStraightSegmentCoordinates, to: self.roundedArrowStraightSegmentCoordinatesUniform)
        }
    }
    
    private var colorUniform:                                  GLint!
    private var thicknessUniform:                              GLint!
    private var straightUniform:                               GLint!
    private var maximalAllowedDrawingDistanceSquaredUniform:   GLint!
    private var startDrawingPointUniform:                      GLint!
    private var arrowHeadTriangleCoordinatesUniform:           GLint!
    private var straightArrowStartPointUniform:                GLint!
    private var arrowEndPointUniform:                          GLint!
    private var roundedArrowRadiusUniform:                     GLint!
    private var roundedArrowCircleCenterUniform:               GLint!
    private var roundedArrowDrawingSegmentUniform:             GLint!
    private var roundedArrowStraightSegmentCoordinatesUniform: GLint!
    
    // MARK: Methods
    
    private func updateMaximalAllowedDrawingDistance() {
        
        let x = self.maxAllowedDrawingDistance01.x * self.resolution.width
        let y = self.maxAllowedDrawingDistance01.y * self.resolution.height
        
        self.maximalAllowedDrawingDistanceSquared = (x * x + y * y) * CGFloat(self.time / self.animationDuration)
    }
    
    private func updateStartDrawingPoint() {
        
        let x = self.resolution.width * self.startPoint01.x
        let y = self.resolution.height * (1.0 - self.startPoint01.y)
        
        self.startDrawingPoint = CGPoint(x: x, y: y)
    }
    
    private func updateArrowHeadTriangleCoordinates() {
        
        let arrowTopOffset = 0.5 * self.renderingThickness / CGFloat(tan(0.5 * Double(Constants.arrowAngle)))
        
        let topPointOffset = CGPoint(x: arrowTopOffset, y: 0.0)
        let backPoint1Offset = CGPoint(x: -3.0 * arrowTopOffset, y: -2.0 * self.renderingThickness)
        let backPoint2Offset = CGPoint(x: -3.0 * arrowTopOffset, y: 2.0 * self.renderingThickness)
        
        let angle = self.normalizedEndArrowDirection.tap_angle
        
        let headCoordinate = self.arrowEndPoint.tap_add(topPointOffset.tap_rotated(on: angle))
        let backCoordinate1 = self.arrowEndPoint.tap_add(backPoint1Offset.tap_rotated(on: angle))
        let backCoordinate2 = self.arrowEndPoint.tap_add(backPoint2Offset.tap_rotated(on: angle))
        
        let cgArray = [
        
            headCoordinate.x, headCoordinate.y,
            backCoordinate1.x, backCoordinate1.y,
            backCoordinate2.x, backCoordinate2.y
        ]
        
        self.arrowHeadTriangleCoordinates = cgArray.map { GLfloat($0) }
    }
    
    private func updateNormalizedEndArrowDirection() {
        
        let direction = CGPoint(x: self.endArrowDirection.x * self.resolution.width, y: -self.endArrowDirection.y * self.resolution.height)
        var length = sqrt(direction.x * direction.x + direction.y * direction.y)
        
        if length == 0.0 {
            
            length = 1.0
        }
        
        self.normalizedEndArrowDirection = CGPoint(x: direction.x / length, y: direction.y / length)
    }
    
    private func updateStraightArrowStartPoint() {
        
        var x: CGFloat
        var y: CGFloat
        
        switch self.direction {
            
        case .bottomToTop:
            
            x = 0.5 * self.resolution.width
            y = Constants.smoothingDistance
            
        case .topToBottom:
            
            x = 0.5 * self.resolution.width
            y = self.resolution.height - Constants.smoothingDistance
            
        case .leftToRight:
            
            x = Constants.smoothingDistance
            y = 0.5 * self.resolution.height
            
        case .rightToLeft:
            
            x = self.resolution.width - Constants.smoothingDistance
            y = 0.5 * self.resolution.height
            
        case .topLeftToBottomRightStraight, .topRightToBottomLeftStraight, .bottomLeftToTopRightStraight, .bottomRightToTopLeftStraight:
            
            let diagonalLength = sqrt(self.resolution.width * self.resolution.width + self.resolution.height * self.resolution.height)
            let cosPhi = self.resolution.width / diagonalLength
            let sinPhi = self.resolution.height / diagonalLength
            let tanPhi = sinPhi / cosPhi
            
            var startDistanceFromCornerLength: CGFloat
            if self.resolution.width > self.resolution.height {
                
                startDistanceFromCornerLength = Constants.smoothingDistance / sinPhi + 0.5 * self.renderingThickness / tanPhi
            }
            else {
                
                startDistanceFromCornerLength = Constants.smoothingDistance / cosPhi + 0.5 * self.renderingThickness * tanPhi
            }
            
            let startDistanceFromCorner = CGPoint(x: cosPhi * startDistanceFromCornerLength, y: sinPhi * startDistanceFromCornerLength)
            
            if self.direction == .topLeftToBottomRightStraight {
                
                x = startDistanceFromCorner.x
                y = self.resolution.height - startDistanceFromCorner.y
            }
            else if self.direction == .topRightToBottomLeftStraight {
                
                x = self.resolution.width - startDistanceFromCorner.x
                y = self.resolution.height - startDistanceFromCorner.y
            }
            else if self.direction == .bottomLeftToTopRightStraight {
                
                x = startDistanceFromCorner.x
                y = startDistanceFromCorner.y
            }
            else if self.direction == .bottomRightToTopLeftStraight {
                
                x = self.resolution.width - startDistanceFromCorner.x
                y = startDistanceFromCorner.y
            }
            else {
                
                x = 0.0
                y = 0.0
            }
            
        default:
            
            x = 0.0
            y = 0.0
        }
        
        self.straightArrowStartPoint = CGPoint(x: x, y: y)
    }
    
    private func updateArrowEndPoint() {
        
        let straightOffsetFromEnd = 0.5 * self.renderingThickness / CGFloat(tan(Double(0.5 * Constants.arrowAngle))) + Constants.smoothingDistance
        let quarterHeadLength = 0.25 * self.arrowHeadLength
        let halfHeadWidth = 0.5 * self.arrowHeadWidth
        
        var x, y: CGFloat
        
        switch self.direction {
            
        case .bottomToTop:
            
            x = 0.5 * self.resolution.width
            y = self.resolution.height - straightOffsetFromEnd
            
        case .topToBottom:
            
            x = 0.5 * self.resolution.width
            y = straightOffsetFromEnd
            
        case .leftToRight:
            
            x = self.resolution.width - straightOffsetFromEnd
            y = 0.5 * self.resolution.height
            
        case .rightToLeft:
            
            x = straightOffsetFromEnd
            y = 0.5 * self.resolution.height
            
        case .topLeftToBottomRightStraight, .topRightToBottomLeftStraight, .bottomLeftToTopRightStraight, .bottomRightToTopLeftStraight:
            
            let diagonalLength = sqrt(self.resolution.width * self.resolution.width + self.resolution.height * self.resolution.height)
            let cosPhi = self.resolution.width / diagonalLength
            let sinPhi = self.resolution.height / diagonalLength
            let tanPhi = sinPhi / cosPhi
            
            var startDistanceFromCornerLength: CGFloat
            if self.resolution.width > self.resolution.height {
                
                startDistanceFromCornerLength = Constants.smoothingDistance / sinPhi + 0.5 * self.renderingThickness / tanPhi
            }
            else {
                
                startDistanceFromCornerLength = Constants.smoothingDistance / cosPhi + 0.5 * self.renderingThickness * tanPhi
            }
            
            let endDistanceFromCornerLength = startDistanceFromCornerLength + 0.5 * self.renderingThickness / CGFloat(tan(Double(0.5 * Constants.arrowAngle)))
            
            let endDistanceFromCorner = CGPoint(x: cosPhi * endDistanceFromCornerLength, y: sinPhi * endDistanceFromCornerLength)
            
            if self.direction == .topLeftToBottomRightStraight {
             
                x = self.resolution.width - endDistanceFromCorner.x
                y = endDistanceFromCorner.y
            }
            else if self.direction == .topRightToBottomLeftStraight {
                
                x = endDistanceFromCorner.x
                y = endDistanceFromCorner.y
            }
            else if self.direction == .bottomLeftToTopRightStraight {
                
                x = self.resolution.width - endDistanceFromCorner.x
                y = self.resolution.height - endDistanceFromCorner.y
            }
            else if self.direction == .bottomRightToTopLeftStraight {
                
                x = endDistanceFromCorner.x
                y = self.resolution.height - endDistanceFromCorner.y
            }
            else {
                
                x = 0.0
                y = 0.0
            }
            
        case .topLeftToBottomRight:
            
            x = self.resolution.width - quarterHeadLength - Constants.smoothingDistance
            y = halfHeadWidth + Constants.smoothingDistance
            
        case .bottomLeftToTopRight:
            
            x = self.resolution.width - quarterHeadLength - Constants.smoothingDistance
            y = self.resolution.height - halfHeadWidth - Constants.smoothingDistance
            
        case .topRightToBottomLeft:
            
            x = quarterHeadLength + Constants.smoothingDistance
            y = halfHeadWidth + Constants.smoothingDistance
            
        case .bottomRightToTopLeft:
            
            x = quarterHeadLength + Constants.smoothingDistance
            y = self.resolution.height - halfHeadWidth - Constants.smoothingDistance
            
        case .bottomRightToLeftTop:
            
            x = halfHeadWidth + Constants.smoothingDistance
            y = self.resolution.height - quarterHeadLength - Constants.smoothingDistance
        
        case .topRightToLeftBottom:
            
            x = halfHeadWidth + Constants.smoothingDistance
            y = quarterHeadLength + Constants.smoothingDistance
            
        case .bottomLeftToRightTop:
            
            x = self.resolution.width - halfHeadWidth - Constants.smoothingDistance
            y = self.resolution.height - quarterHeadLength - Constants.smoothingDistance
            
        case .topLeftToRightBottom:
            
            x = self.resolution.width - halfHeadWidth - Constants.smoothingDistance
            y = quarterHeadLength + Constants.smoothingDistance
        }
        
        self.arrowEndPoint = CGPoint(x: x, y: y)
    }
    
    private func updateArrowHeadLengthAndWidth() {
        
        self.arrowHeadLength = 2.0 * self.renderingThickness / CGFloat(tan(Double(0.5 * Constants.arrowAngle)))
        self.arrowHeadWidth = 4.0 * self.renderingThickness
    }
    
    private func updateRoundedArrowRadius() {
        
        let doubledSmoothingDistance = 2.0 * Constants.smoothingDistance
        let halfThickness = 0.5 * self.renderingThickness
        let halfArrowHeadWidth = 0.5 * self.arrowHeadWidth
        let vertical = self.normalizedEndArrowDirection.x == 0.0
        var radiusX = self.resolution.width - ( vertical ? halfArrowHeadWidth : self.arrowHeadLength + halfThickness )
        var radiusY = self.resolution.height - ( vertical ? self.arrowHeadLength + halfThickness : halfArrowHeadWidth )
        
        radiusX = max(radiusX, doubledSmoothingDistance)
        radiusY = max(radiusY, doubledSmoothingDistance)
        
        let minimalRadius = min(radiusX, radiusY) - doubledSmoothingDistance
        
        self.roundedArrowRadius = minimalRadius
    }
    
    private func updateRoundedArrowCircleCenter() {
        
        let halfArrowHeadWidth = 0.5 * self.arrowHeadWidth
        let halfThickness = 0.5 * self.renderingThickness
        
        var x: CGFloat
        var y: CGFloat
        
        switch self.direction {
            
        case .topLeftToBottomRight:
            
            x = Constants.smoothingDistance + halfThickness + self.roundedArrowRadius
            y = halfArrowHeadWidth + self.roundedArrowRadius + Constants.smoothingDistance
            
        case .bottomRightToLeftTop:
            
            x = halfArrowHeadWidth + self.roundedArrowRadius + Constants.smoothingDistance
            y = self.roundedArrowRadius + halfThickness + Constants.smoothingDistance
            
        case .topLeftToRightBottom:
            
            x = self.resolution.width - self.roundedArrowRadius - halfArrowHeadWidth - Constants.smoothingDistance
            y = self.resolution.height - self.roundedArrowRadius - halfThickness - Constants.smoothingDistance
            
        case .bottomRightToTopLeft:
            
            x = self.resolution.width - self.roundedArrowRadius - halfThickness - Constants.smoothingDistance
            y = self.resolution.height - self.roundedArrowRadius - halfArrowHeadWidth - Constants.smoothingDistance
            
        case .topRightToBottomLeft:
            
            x = self.resolution.width - self.roundedArrowRadius - halfThickness - Constants.smoothingDistance
            y = halfArrowHeadWidth + self.roundedArrowRadius + Constants.smoothingDistance
            
        case .bottomLeftToRightTop:
            
            x = self.resolution.width - halfArrowHeadWidth - self.roundedArrowRadius - Constants.smoothingDistance
            y = self.roundedArrowRadius + halfThickness + Constants.smoothingDistance
            
        case .topRightToLeftBottom:
            
            x = self.roundedArrowRadius + halfArrowHeadWidth + Constants.smoothingDistance
            y = self.resolution.height - self.roundedArrowRadius - halfThickness - Constants.smoothingDistance
            
        case .bottomLeftToTopRight:
            
            x = self.roundedArrowRadius + halfThickness + Constants.smoothingDistance
            y = self.resolution.height - self.roundedArrowRadius - halfArrowHeadWidth - Constants.smoothingDistance
            
        default:
            
            x = 0.0
            y = 0.0
        }
        
        self.roundedArrowCircleCenter = CGPoint(x: x, y: y)
    }
    
    private func updateRoundedArrowDrawingSegment() {
        
        var x: CGFloat
        var y: CGFloat
        
        switch self.direction {
            
        case .topLeftToBottomRight, .bottomRightToLeftTop:
            
            x = -1.0
            y = -1.0
            
        case .topLeftToRightBottom, .bottomRightToTopLeft:
            
            x = 1.0
            y = 1.0
            
        case .topRightToBottomLeft, .bottomLeftToRightTop:
            
            x = 1.0
            y = -1.0
            
        case .topRightToLeftBottom, .bottomLeftToTopRight:
            
            x = -1.0
            y = 1.0
            
        default:
            
            x = 0.0
            y = 0.0
        }
        
        self.roundedArrowDrawingSegment = CGPoint(x: x, y: y)
    }
    
    private func updateRoundedArrowStraightSegmentCoordinates() {
        
        var horizontal: Bool
        var straightLength: CGFloat
		
		let halfLines = 0.5 * self.renderingThickness + 2.0 * Constants.smoothingDistance
		
        if self.normalizedEndArrowDirection.x != 0.0 {
			
            let possibleHorizontalLength = abs(self.resolution.width - self.arrowHeadLength - self.roundedArrowRadius - halfLines)
            horizontal = possibleHorizontalLength >= Constants.epsilon
            
            if horizontal {
                
                straightLength = possibleHorizontalLength
            }
            else {
                
                straightLength = self.resolution.height - self.roundedArrowRadius - 0.5 * self.arrowHeadWidth - 2.0 * Constants.smoothingDistance
            }
        }
        else {
            
            let possibleVerticalLength = self.resolution.height - self.arrowHeadLength - self.roundedArrowRadius - halfLines
            horizontal = possibleVerticalLength < Constants.epsilon
            
            if horizontal {
                
                straightLength = self.resolution.width - 0.5 * self.arrowHeadWidth - self.roundedArrowRadius - 2.0 * Constants.smoothingDistance
            }
            else {
                
                straightLength = possibleVerticalLength
            }
        }
        
        var x1, y1, x2, y2: CGFloat
        
        switch (self.direction, horizontal) {
            
        case (.topLeftToBottomRight, true), (.bottomRightToLeftTop, true):
            
            let y = self.roundedArrowCircleCenter.y - self.roundedArrowRadius
            
            x1 = self.roundedArrowCircleCenter.x
            y1 = y
            x2 = roundedArrowCircleCenter.x + straightLength
            y2 = y
            
        case (.topLeftToBottomRight, false), (.bottomRightToLeftTop, false):
            
            let x = self.roundedArrowCircleCenter.x - self.roundedArrowRadius
            
            x1 = x
            y1 = self.roundedArrowCircleCenter.y + straightLength
            x2 = x
            y2 = self.roundedArrowCircleCenter.y
            
        case (.topLeftToRightBottom, true), (.bottomRightToTopLeft, true):
            
            let y = self.roundedArrowCircleCenter.y + self.roundedArrowRadius
            
            x1 = self.roundedArrowCircleCenter.x - straightLength
            y1 = y
            x2 = self.roundedArrowCircleCenter.x
            y2 = y
            
        case (.topLeftToRightBottom, false), (.bottomRightToTopLeft, false):
            
            let x = self.roundedArrowCircleCenter.x + self.roundedArrowRadius
            
            x1 = x
            y1 = self.roundedArrowCircleCenter.y - straightLength
            x2 = x
            y2 = self.roundedArrowCircleCenter.y
            
        case (.topRightToBottomLeft, true), (.bottomLeftToRightTop, true):
            
            let y = self.roundedArrowCircleCenter.y - self.roundedArrowRadius
            
            x1 = self.roundedArrowCircleCenter.x - straightLength
            y1 = y
            x2 = self.roundedArrowCircleCenter.x
            y2 = y
            
        case (.topRightToBottomLeft, false), (.bottomLeftToRightTop, false):
            
            let x = self.roundedArrowCircleCenter.x + self.roundedArrowRadius
            
            x1 = x
            y1 = self.roundedArrowCircleCenter.y
            x2 = x
            y2 = self.roundedArrowCircleCenter.y + straightLength
            
        case (.topRightToLeftBottom, true), (.bottomLeftToTopRight, true):
            
            let y = self.roundedArrowCircleCenter.y + self.roundedArrowRadius
            
            x1 = self.roundedArrowCircleCenter.x
            y1 = y
            x2 = self.roundedArrowCircleCenter.x + straightLength
            y2 = y
            
        case (.topRightToLeftBottom, false), (.bottomLeftToTopRight, false):
            
            let x = self.roundedArrowCircleCenter.x - self.roundedArrowRadius
            
            x1 = x
            y1 = self.roundedArrowCircleCenter.y - straightLength
            x2 = x
            y2 = self.roundedArrowCircleCenter.y
            
        default:
            
            x1 = 0.0
            x2 = 0.0
            y1 = 0.0
            y2 = 0.0
        }
        
        let cgArray = [x1, y1, x2, y2]
        
        self.roundedArrowStraightSegmentCoordinates = cgArray.map { GLfloat($0) }
    }
}

private let shaderSource: ShaderSource = {
  
    let vertex =

"""
//
//  TapGLKit/ArrowView
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
//  TapGLKit/ArrowView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

#define M_PI 3.1415926535897932384626433832795

uniform highp vec4  color;
uniform       int   straight;
uniform highp float thickness;
uniform highp float maximalAllowedDrawingDistanceSquared;
uniform highp vec2  startDrawingPoint;
uniform highp vec2  straightArrowStartPoint;
uniform highp vec2  arrowEndPoint;
uniform highp vec2  arrowHeadTriangleCoordinates[3];
uniform highp float roundedArrowRadius;
uniform highp vec2  roundedArrowCircleCenter;
uniform highp vec2  roundedArrowDrawingSegment;
uniform highp vec2  roundedArrowStraightSegmentCoordinates[2];

const highp float kSmoothingDistance             = 2.0;

// MARK: Function Definitions

highp float minimalDistanceFromLineToPoint(highp mat2 line, highp vec2 point);
      bool  isPointInsideTriangle(highp vec2 triangle[3], highp vec2 point);
highp float positionRelativeToLine(highp vec2 point, highp vec2 line[2]);
highp float minimalDistanceFromPointToTriangle(highp vec2 triangle[3], highp vec2 point);

// MARK: Main

void main() {

    highp float xDistance = gl_FragCoord.x - startDrawingPoint.x;
    highp float yDistance = gl_FragCoord.y - startDrawingPoint.y;
    highp float squaredDistanceFromCoord = xDistance * xDistance + yDistance * yDistance;
    if ( squaredDistanceFromCoord > maximalAllowedDrawingDistanceSquared ) {
        
        discard;
    }
    
    if ( straight == 1 )  {
        
        highp mat2 arrowCoordinates;
        arrowCoordinates[0] = straightArrowStartPoint;
        arrowCoordinates[1] = arrowEndPoint;
        
        highp float minimalDistanceToLine = minimalDistanceFromLineToPoint(arrowCoordinates, gl_FragCoord.xy);
        highp float minimalDistanceToTriangle = minimalDistanceFromPointToTriangle(arrowHeadTriangleCoordinates, gl_FragCoord.xy);
        
        highp float alpha = 0.0;
        if ( isPointInsideTriangle(arrowHeadTriangleCoordinates, gl_FragCoord.xy) || minimalDistanceToLine <= 0.5 * thickness ) {
            
            alpha = 1.0;
        }
        else if ( (minimalDistanceToLine <= 0.5 * thickness + kSmoothingDistance) && (minimalDistanceToTriangle <= kSmoothingDistance) ) {
            
            alpha = 1.0 - min(smoothstep(0.0, kSmoothingDistance, minimalDistanceToLine - 0.5 * thickness),
                              smoothstep(0.0, kSmoothingDistance, minimalDistanceToTriangle));
        }
        else if ( minimalDistanceToTriangle <= kSmoothingDistance ) {
            
            alpha = 1.0 - smoothstep(0.0, kSmoothingDistance, minimalDistanceToTriangle);
        }
        else if ( minimalDistanceToLine <= 0.5 * thickness + kSmoothingDistance ) {
            
            alpha = 1.0 - smoothstep(0.0, kSmoothingDistance, minimalDistanceToLine - 0.5 * thickness);
        }

        gl_FragColor = color * alpha;
    }
    else {
        
        highp vec2  offsetFromCenter       = gl_FragCoord.xy - roundedArrowCircleCenter;
        highp float offsetFromCenterLength = length(offsetFromCenter);
        
        highp float roundAlpha = 0.0;
        if ( sign(roundedArrowDrawingSegment.x) == sign(offsetFromCenter.x) &&
             sign(roundedArrowDrawingSegment.y) == sign(offsetFromCenter.y) ) {
            
            if ( roundedArrowRadius - 0.5 * thickness <= offsetFromCenterLength &&
                 offsetFromCenterLength <= roundedArrowRadius + 0.5 * thickness ) {
                
                roundAlpha = 1.0;
            }
            else if ( roundedArrowRadius - 0.5 * thickness - kSmoothingDistance <= offsetFromCenterLength &&
                      offsetFromCenterLength <= roundedArrowRadius + 0.5 * thickness + kSmoothingDistance ) {
                
                roundAlpha = 1.0 - smoothstep(0.0, kSmoothingDistance, abs(offsetFromCenterLength - roundedArrowRadius) - 0.5 * thickness);
            }
        }
        
        highp mat2 straightCoordinates;
        straightCoordinates[0] = roundedArrowStraightSegmentCoordinates[0];
        straightCoordinates[1] = roundedArrowStraightSegmentCoordinates[1];
        
        highp float minimalDistanceToLine = minimalDistanceFromLineToPoint(straightCoordinates, gl_FragCoord.xy);
        
        highp float straightAlpha = 0.0;
        if ( minimalDistanceToLine <= 0.5 * thickness ) {
            
            straightAlpha = 1.0;
        }
        else if ( minimalDistanceToLine <= 0.5 * thickness + kSmoothingDistance ) {
            
            straightAlpha = 1.0 - smoothstep(0.0, kSmoothingDistance, minimalDistanceToLine - 0.5 * thickness);
        }
        
        highp float minimalDistanceToTriangle = minimalDistanceFromPointToTriangle(arrowHeadTriangleCoordinates, gl_FragCoord.xy);
        
        highp float triangleAlpha = 0.0;
        
        if ( isPointInsideTriangle(arrowHeadTriangleCoordinates, gl_FragCoord.xy) ) {
            
            triangleAlpha = 1.0;
        }
        else {
            
            triangleAlpha = 1.0 - smoothstep(0.0, kSmoothingDistance, minimalDistanceToTriangle);
        }
        
        gl_FragColor = color * max(triangleAlpha, max(roundAlpha, straightAlpha));
    }
}

highp float minimalDistanceFromLineToPoint(highp mat2 line, highp vec2 point) {
    
    highp vec2 point2 = line[1] - line[0];
    highp float squareModulePoint2 = point2.x * point2.x + point2.y * point2.y;
    highp float u = ((point.x - line[0].x) * point2.x + (point.y - line[0].y) * point2.y) / squareModulePoint2;
    
    if ( u > 1.0 ) {
        
        u = 1.0;
    }
    else if ( u < 0.0 ) {
        
        u = 0.0;
    }
    
    highp float x = line[0].x + u * point2.x;
    highp float y = line[0].y + u * point2.y;
    
    highp float dx = x - point.x;
    highp float dy = y - point.y;
    
    return sqrt(dx * dx + dy * dy);
}

bool isPointInsideTriangle(highp vec2 triangle[3], highp vec2 point) {
    
    highp vec2 triangle01[2]; triangle01[0] = triangle[0]; triangle01[1] = triangle[1];
    highp vec2 triangle12[2]; triangle12[0] = triangle[1]; triangle12[1] = triangle[2];
    highp vec2 triangle20[2]; triangle20[0] = triangle[2]; triangle20[1] = triangle[0];
    
    bool position1 = positionRelativeToLine(point, triangle01) < 0.0;
    bool position2 = positionRelativeToLine(point, triangle12) < 0.0;
    bool position3 = positionRelativeToLine(point, triangle20) < 0.0;
    
    return ( ( position1 == position2 ) && ( position2 == position3 ) );
}

highp float positionRelativeToLine(highp vec2 point, highp vec2 line[2]) {
    
    return (point.x - line[1].x) * (line[0].y - line[1].y) - (line[0].x - line[1].x) * (point.y - line[1].y);
}

highp float minimalDistanceFromPointToTriangle(highp vec2 triangle[3], highp vec2 point) {
    
    if ( isPointInsideTriangle(triangle, point) ) {
        
        return 0.0;
    }
    
    highp mat2 triangle01; triangle01[0] = triangle[0]; triangle01[1] = triangle[1];
    highp mat2 triangle12; triangle12[0] = triangle[1]; triangle12[1] = triangle[2];
    highp mat2 triangle20; triangle20[0] = triangle[2]; triangle20[1] = triangle[0];
    
    highp float distanceAB = minimalDistanceFromLineToPoint(triangle01, point);
    highp float distanceBC = minimalDistanceFromLineToPoint(triangle12, point);
    highp float distanceCA = minimalDistanceFromLineToPoint(triangle20, point);
    
    return min(distanceAB, min(distanceBC, distanceCA));
}

"""
    
    return ShaderSource(vertex: vertex, fragment: fragment)
}()
