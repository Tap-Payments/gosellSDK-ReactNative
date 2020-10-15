//
//  TapActivityIndicatorShader.swift
//  TapGLKit/TapActivityIndicatorView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2

import CoreGraphics
import func OpenGLES.ES2.gl.glGetUniformLocation
import struct OpenGLES.ES2.gl.GLfloat
import struct OpenGLES.ES2.gl.GLint
import class UIKit.UIColor.UIColor

internal enum AnimationState: Int {
    
    case growing = 0
    case staticBig = 1
    case shrinking = 2
    case staticSmall = 3
}

/// Tap Activity Indicator shader class.
internal class TapActivityIndicatorShader: AnimatedShader {
    
    //MARK: - Internal -
    //MARK: Properties
    
    internal override var resolution: CGSize {
        
        didSet {
            
            self.minSize = min(resolution.width, resolution.height)
            self.outterCircleBiggerRadius = self.minSize * 0.5 - Constants.smoothingDistance
            self.outterCircleSmallerRadius = self.outterCircleBiggerRadius - self.minSize / 14.0
            self.innerCircleBiggerRadius = self.minSize * 25.0 / 77.0
            self.innerCircleSmallerRadius = self.innerCircleBiggerRadius - self.minSize / 14.0
        }
    }
    
    internal override var animationDuration: TimeInterval {
        
        didSet {
            
            self.calculateAnimationTimings()
            self.calculateTimeOffset()
            self.calculateAnimationState()
            self.calculateAngleRangeLength()
            self.calculatePossibleAngleRanges()
            self.calculateCirclesColors()
        }
    }
    
    internal override var time: TimeInterval {
        
        didSet {
            
            self.calculateTimeOffset()
            self.calculateAnimationState()
            self.calculateAngleRangeLength()
            self.calculatePossibleAngleRanges()
            self.calculateCirclesColors()
        }
    }
    
    /// Color of the outter circle.
    internal var outterCircleColor: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.outterColorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.outterColorComponents = components
            }
        }
    }
    
    /// Color of the inner circle.
    internal var innerCircleColor: UIColor {
        
        get {
            
            return UIColor(tap_glComponents: self.innerColorComponents)!
        }
        set {
            
            if let components = newValue.tap_glComponents {
                
                self.innerColorComponents = components
            }
        }
    }
    
    /// Defines if custom colors are used.
    internal var usesCustomColors: Bool = false {
        
        didSet {
            
            self.calculateCirclesColors()
        }
    }
    
    internal override class var source: ShaderSource {
        
        return shaderSource
    }
    
    //MARK: Methods
    
    internal override func obtainAttributesAndUniforms() {
        
        super.obtainAttributesAndUniforms()
        
        self.smoothingDistanceUniform         = glGetUniformLocation(self.program, Constants.smoothingDistanceConstantUniformKey)
        self.outterCircleBiggerRadiusUniform  = glGetUniformLocation(self.program, Constants.outterCircleBiggerRadiusUniformKey)
        self.outterCircleSmallerRadiusUniform = glGetUniformLocation(self.program, Constants.outterCircleSmallerRadiusUniformKey)
        self.innerCircleBiggerRadiusUniform   = glGetUniformLocation(self.program, Constants.innerCircleBiggerRadiusUniformKey)
        self.innerCircleSmallerRadiusUniform  = glGetUniformLocation(self.program, Constants.innerCircleSmallerRadiusUniformKey)
        self.possibleAngleRangesUniform       = glGetUniformLocation(self.program, Constants.possibleAngleRangesUniformKey)
        self.outterColorUniform               = glGetUniformLocation(self.program, Constants.outterColorUniformKey)
        self.innerColorUniform                = glGetUniformLocation(self.program, Constants.innerColorUniformKey)
    }
    
    internal override func loadInitialValues() {
        
        super.loadInitialValues()
        
        self.setFloat(GLfloat(Constants.smoothingDistance), to: self.smoothingDistanceUniform)
        self.setFloat(GLfloat(self.outterCircleBiggerRadius), to: self.outterCircleBiggerRadiusUniform)
        self.setFloat(GLfloat(self.outterCircleSmallerRadius), to: self.outterCircleSmallerRadiusUniform)
        self.setFloat(GLfloat(self.innerCircleBiggerRadius), to: self.innerCircleBiggerRadiusUniform)
        self.setFloat(GLfloat(self.innerCircleSmallerRadius), to: self.innerCircleSmallerRadiusUniform)
        self.setVec4(self.possibleAngleRanges, to: self.possibleAngleRangesUniform)
        self.setVec4(self.currentOutterColor, to: self.outterColorUniform)
        self.setVec4(self.currentInnerColor, to: self.innerColorUniform)
    }
    
    //MARK: - Private -
    
    private struct Constants {
        
        fileprivate static let smoothingDistanceConstantUniformKey = "smoothingDistance"
        fileprivate static let outterCircleBiggerRadiusUniformKey = "outterCircleBiggerRadius"
        fileprivate static let outterCircleSmallerRadiusUniformKey = "outterCircleSmallerRadius"
        fileprivate static let innerCircleBiggerRadiusUniformKey = "innerCircleBiggerRadius"
        fileprivate static let innerCircleSmallerRadiusUniformKey = "innerCircleSmallerRadius"
        fileprivate static let possibleAngleRangesUniformKey = "possibleAngleRanges"
        fileprivate static let outterColorUniformKey = "outterColor"
        fileprivate static let innerColorUniformKey = "innerColor"
        
        fileprivate static let smoothingDistance: CGFloat = 2.0
        fileprivate static let sizeChangeAnimationPortion: CGFloat = 0.4
        fileprivate static let staticAnimationPortion: CGFloat = 0.5 - Constants.sizeChangeAnimationPortion
        fileprivate static let minimalArcSizePortion: CGFloat = 0.05
        fileprivate static let maximalArcSizePortion: CGFloat = 1.0
        fileprivate static let rotationsPerAnimation: CGFloat = 3.0
        
        fileprivate static let defaultColors: [[GLfloat]] = {
            
            var result: [[GLfloat]] = []
            result += [ 42.0, 206.0,   0.0, 255.0] * (1.0 / 255.0)
            result += [ 76.0,  72.0,  71.0, 255.0] * (1.0 / 255.0)
            result += [  0.0, 175.0, 240.0, 255.0] * (1.0 / 255.0)
            result += [ 76.0,  72.0,  71.0, 255.0] * (1.0 / 255.0)
            
            return result
        }()
        
        @available(*, unavailable) private init() {}
    }
    
    //MARK: Properties
    
    private var smoothingDistanceUniform: GLint!
    private var outterCircleBiggerRadiusUniform: GLint!
    private var outterCircleSmallerRadiusUniform: GLint!
    private var innerCircleBiggerRadiusUniform: GLint!
    private var innerCircleSmallerRadiusUniform: GLint!
    private var possibleAngleRangesUniform: GLint!
    private var outterColorUniform: GLint!
    private var innerColorUniform: GLint!
    
    private var minSize: CGFloat = 0.0
    
    private var outterCircleBiggerRadius: CGFloat = 0.0 {
        
        didSet {
            
            guard self.readyToBeUsed && self.outterCircleBiggerRadius != oldValue else { return }
            self.setFloat(GLfloat(self.outterCircleBiggerRadius), to: self.outterCircleBiggerRadiusUniform)
        }
    }
    
    private var outterCircleSmallerRadius: CGFloat = 0.0 {
        
        didSet {
            
            guard self.readyToBeUsed && self.outterCircleSmallerRadius != oldValue else { return }
            self.setFloat(GLfloat(self.outterCircleSmallerRadius), to: self.outterCircleSmallerRadiusUniform)
        }
    }
    
    private var innerCircleBiggerRadius: CGFloat = 0.0 {
        
        didSet {
            
            guard self.readyToBeUsed && self.innerCircleBiggerRadius != oldValue else { return }
            self.setFloat(GLfloat(self.innerCircleBiggerRadius), to: self.innerCircleBiggerRadiusUniform)
        }
    }
    
    private var innerCircleSmallerRadius: CGFloat = 0.0 {
        
        didSet {
            
            guard self.readyToBeUsed && self.innerCircleSmallerRadius != oldValue else { return }
            self.setFloat(GLfloat(self.innerCircleSmallerRadius), to: self.innerCircleSmallerRadiusUniform)
        }
    }
    
    private var outterColorComponents: [GLfloat] = [1.0, 1.0, 1.0, 1.0] {
        
        didSet {
            
            self.calculateCirclesColors()
        }
    }
    
    private var innerColorComponents: [GLfloat] = [1.0, 1.0, 1.0, 1.0] {
        
        didSet {
            
            self.calculateCirclesColors()
        }
    }
    
    private var animationTimings: [GLfloat] = [0.0, 0.0, 0.0, 0.0]
    
    private var animationState: AnimationState = .growing
    
    private var timeOffset: GLfloat = 0.0
    
    private var angleRangeLength: GLfloat = 0.0
    
    private var possibleAngleRanges: [GLfloat] = [0.0, 0.0, 0.0, 0.0] {
        
        didSet {
            
            guard self.readyToBeUsed && self.possibleAngleRanges != oldValue else { return }
            self.setVec4(self.possibleAngleRanges, to: self.possibleAngleRangesUniform)
        }
    }
    
    private var currentOutterColor: [GLfloat] = [0.0, 0.0, 0.0, 0.0] {
        
        didSet {
            
            guard self.readyToBeUsed && self.currentOutterColor != oldValue else { return }
            self.setVec4(self.currentOutterColor, to: self.outterColorUniform)
        }
    }
    
    private var currentInnerColor: [GLfloat] = [0.0, 0.0, 0.0, 0.0] {
        
        didSet {
            
            guard self.readyToBeUsed && self.currentInnerColor != oldValue else { return }
            self.setVec4(self.currentInnerColor, to: self.innerColorUniform)
        }
    }
    
    // MARK: Methods
    
    private func calculateAnimationTimings() {
        
        let biggenAnimationCompletion = GLfloat(Constants.sizeChangeAnimationPortion)
        let staticBigAnimationCompletion = biggenAnimationCompletion + GLfloat(Constants.staticAnimationPortion)
        let smallenAnimationCompletion = staticBigAnimationCompletion + GLfloat(Constants.sizeChangeAnimationPortion)
        let staticSmallAnimationCompletion = GLfloat(1.0)
        
        let timings = [biggenAnimationCompletion, staticBigAnimationCompletion, smallenAnimationCompletion, staticSmallAnimationCompletion]
        let scaledTimings = GLfloat(self.animationDuration) * timings
        
        self.animationTimings = scaledTimings
    }
    
    private func calculateAnimationState() {
        
        if self.timeOffset < self.animationTimings[0] {
            
            self.animationState = .growing
        }
        else if self.timeOffset < self.animationTimings[1] {
            
            self.animationState = .staticBig
        }
        else if self.timeOffset < self.animationTimings[2] {
            
            self.animationState = .shrinking
        }
        else {
            
            self.animationState = .staticSmall
        }
    }
    
    private func calculateTimeOffset() {
        
        self.timeOffset = GLfloat(self.time.truncatingRemainder(dividingBy: self.animationDuration))
    }
    
    private func calculateAngleRangeLength() {
        
        var resultInPercents: GLfloat
        
        switch self.animationState {
            
        case .growing:
            
            let arcSizeDifference = GLfloat(Constants.maximalArcSizePortion - Constants.minimalArcSizePortion)
            resultInPercents = GLfloat(Constants.minimalArcSizePortion) + arcSizeDifference * self.timeOffset / self.animationTimings[0]
            
        case .shrinking:
            
            let arcSizeDifference = GLfloat(Constants.maximalArcSizePortion - Constants.minimalArcSizePortion)
            resultInPercents = GLfloat(Constants.maximalArcSizePortion) - arcSizeDifference * (self.timeOffset - self.animationTimings[1]) / (self.animationTimings[2] - self.animationTimings[1])
            
        case .staticBig:
            
            resultInPercents = GLfloat(Constants.maximalArcSizePortion)
            
        case .staticSmall:
            
            resultInPercents = GLfloat(Constants.minimalArcSizePortion)
        }
        
        self.angleRangeLength = 2.0 * GLfloat.pi * resultInPercents
    }
    
    private func calculatePossibleAngleRanges() {
        
        let positiveAngle = 2.0 * GLfloat.pi * GLfloat(Constants.rotationsPerAnimation) * self.timeOffset / GLfloat(self.animationDuration)
        
        let startCounterAngle = self.angleInTwoPiRange(-positiveAngle - self.angleRangeLength)
        let startAngle = self.angleInTwoPiRange(positiveAngle + GLfloat.pi)
        
        let endCounterAngle = startCounterAngle + self.angleRangeLength
        let endAngle = startAngle + self.angleRangeLength
        
        self.possibleAngleRanges = [startCounterAngle, endCounterAngle, startAngle, endAngle]
    }
    
    private func angleInTwoPiRange(_ angle: GLfloat) -> GLfloat {
        
        let twoPi = GLfloat(2.0 * GLfloat.pi)
        
        var positiveStartAngle = angle
        if positiveStartAngle < 0.0 {
            
            positiveStartAngle -= twoPi * (positiveStartAngle / twoPi).rounded(.down)
        }
        
        let result = positiveStartAngle.truncatingRemainder(dividingBy: twoPi)
        return result
    }
    
    private func calculateCirclesColors() {
        
        if self.usesCustomColors {
            
            self.currentOutterColor = self.outterColorComponents
            self.currentInnerColor = self.innerColorComponents
        }
        else {
            
            let defaultColor = self.calculateDefaultColor()
            self.currentOutterColor = defaultColor
            self.currentInnerColor = defaultColor
        }
    }
    
    private func calculateDefaultColor() -> [GLfloat] {
        
        switch self.animationState {
            
        case .growing:
            
            let progress = self.timeOffset / self.animationTimings[0]
            return tap_interpolate(start: Constants.defaultColors[0], finish: Constants.defaultColors[1], progress: progress)
            
        case .staticBig:
            
            let progress = (self.timeOffset - self.animationTimings[0]) / (self.animationTimings[1] - self.animationTimings[0])
            return tap_interpolate(start: Constants.defaultColors[1], finish: Constants.defaultColors[2], progress: progress)
            
        case .shrinking:
            
            let progress = (self.timeOffset - self.animationTimings[1]) / (self.animationTimings[2] - self.animationTimings[1])
            return tap_interpolate(start: Constants.defaultColors[2], finish: Constants.defaultColors[3], progress: progress)
            
        case .staticSmall:
            
            let progress = (self.timeOffset - self.animationTimings[2]) / (self.animationTimings[3] - self.animationTimings[2])
            return tap_interpolate(start: Constants.defaultColors[3], finish: Constants.defaultColors[0], progress: progress)
        }
    }
}

private let shaderSource: ShaderSource = {
    
    let vertex =

"""
//
//  TapGLKit/TapActivityIndicatorView
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
//  TapGLKit/TapActivityIndicatorView
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

#define M_PI 3.1415926535897932384626433832795

uniform highp vec2  center;
uniform highp float smoothingDistance;
uniform lowp  vec4  outterColor;
uniform lowp  vec4  innerColor;
uniform highp float outterCircleBiggerRadius;
uniform highp float outterCircleSmallerRadius;
uniform highp float innerCircleBiggerRadius;
uniform highp float innerCircleSmallerRadius;
uniform highp vec4  possibleAngleRanges;

//MARK: Function Definitions

bool isPointInsideCircle(highp vec2 point, highp float biggerRadius, highp float smallerRadius, bool clockwise, out highp float alpha);
highp float pointAngle(highp vec2 point, highp vec2 center);
highp float bringValueTo2PiRange(highp float value);
bool isAngleInAllowedRange(highp float angle, highp vec2 allowedRange);
bool isBetween(highp float angle, highp vec2 range);
highp vec2 pointCoordinates(highp vec2 center, highp float radius, highp float angle);
highp vec4 capCircles(highp vec2 center, highp float biggerRadius, highp float smallerRadius, highp float startAngle, highp float endAngle);

//MARK: Main

void main() {
    
    highp vec2 position = gl_FragCoord.xy;
    highp float alpha = 1.0;
    
    if ( isPointInsideCircle(position, outterCircleBiggerRadius, outterCircleSmallerRadius, false, alpha) ) {
        
        gl_FragColor = outterColor * alpha;
    }
    else if ( isPointInsideCircle(position, innerCircleBiggerRadius, innerCircleSmallerRadius, true, alpha) ) {
        
        gl_FragColor = innerColor * alpha;
    }
    else {
        
        gl_FragColor = vec4(0.0);
    }
}

//MARK: Geometry calculations.

bool isPointInsideCircle(highp vec2 point, highp float biggerRadius, highp float smallerRadius, bool clockwise, out highp float alpha) {
    
    highp float distanceFromCenter = distance(center, point);
    
    if ( distanceFromCenter > biggerRadius + smoothingDistance || distanceFromCenter < smallerRadius - smoothingDistance ) {
        
        return false;
    }
    
    highp vec2 possibleAngles = clockwise ? possibleAngleRanges.zw : possibleAngleRanges.xy;
    highp float pointAngle = pointAngle(point, center);
    
    if ( isAngleInAllowedRange(pointAngle, possibleAngles)) {
        
        if ( biggerRadius < distanceFromCenter ) {
            
            alpha = 1.0 - smoothstep(biggerRadius, biggerRadius + smoothingDistance, distanceFromCenter);
        }
        else if ( smallerRadius > distanceFromCenter ) {
            
            alpha = smoothstep(smallerRadius - smoothingDistance, smallerRadius, distanceFromCenter);
        }
        else {
            
            alpha = 1.0;
        }
        
        return true;
    }
    
    highp vec4 capCircles = capCircles(center, biggerRadius, smallerRadius, possibleAngles.x, possibleAngles.y);
    highp float capCircleRadius = 0.5 * ( biggerRadius - smallerRadius);
    
    highp float distanceFromFirstCapCircleCenter = distance(vec2(capCircles.x, capCircles.y), point);
    highp float distanceFromSecondCapCircleCenter = distance(vec2(capCircles.z, capCircles.w), point);
    
    bool isInsideFirstCapCircleSmoothingRange = distanceFromFirstCapCircleCenter <= capCircleRadius + smoothingDistance;
    bool isInsideSecondCapCircleSmoothingRange = distanceFromSecondCapCircleCenter <= capCircleRadius + smoothingDistance;
    
    if ( distanceFromFirstCapCircleCenter <= capCircleRadius || distanceFromSecondCapCircleCenter <= capCircleRadius ) {
        
        alpha = 1.0;
        return true;
    }
    else if ( isInsideFirstCapCircleSmoothingRange && isInsideSecondCapCircleSmoothingRange ) {
        
        highp float firstCircleSmooth = smoothstep(capCircleRadius, capCircleRadius + smoothingDistance, distanceFromFirstCapCircleCenter);
        highp float secondCircleSmooth = smoothstep(capCircleRadius, capCircleRadius + smoothingDistance, distanceFromSecondCapCircleCenter);
        
        alpha = 1.0 - 0.5 * ( firstCircleSmooth + secondCircleSmooth );
        return true;
    }
    else if ( isInsideFirstCapCircleSmoothingRange ) {
        
        alpha = 1.0 - smoothstep(capCircleRadius, capCircleRadius + smoothingDistance, distanceFromFirstCapCircleCenter);
        return true;
    }
    else if ( isInsideSecondCapCircleSmoothingRange ) {
        
        alpha = 1.0 - smoothstep(capCircleRadius, capCircleRadius + smoothingDistance, distanceFromSecondCapCircleCenter);
        return true;
    }
    
    return false;
}

highp float pointAngle(highp vec2 point, highp vec2 center) {
    
    highp float distanceFromCenter = distance(center, point);
    highp float acosValue = acos((point.x - center.x) / distanceFromCenter);
    
    highp float result;
    
    if ( center.y < point.y ) {
        
        result = -acosValue;
    }
    else {
        
        result = acosValue;
    }
    
    return bringValueTo2PiRange(result);
}

highp float bringValueTo2PiRange(highp float value) {
    
    highp float twoPi = 2.0 * M_PI;
    
    highp float positiveValue = value;
    if ( positiveValue < 0.0 ) {
        
        positiveValue -= twoPi * float(int(positiveValue / twoPi));
    }
    
    highp float rangeLength = twoPi;
    highp float resultValue = mod(positiveValue, rangeLength);
    
    return resultValue;
}

bool isAngleInAllowedRange(highp float angle, highp vec2 allowedRange) {
    
    return isBetween(angle, allowedRange) || isBetween(angle + 2.0 * M_PI, allowedRange);
}

bool isBetween(highp float angle, highp vec2 range) {
    
    return (range.x <= angle) && (angle <= range.y);
}

highp vec4 capCircles(highp vec2 center, highp float biggerRadius, highp float smallerRadius, highp float startAngle, highp float endAngle) {
    
    highp float mediumRadius = 0.5 * (biggerRadius + smallerRadius);
    
    highp vec2 startCenter = pointCoordinates(center, mediumRadius, startAngle);
    highp vec2 endCenter = pointCoordinates(center, mediumRadius, endAngle);
    
    return vec4(startCenter, endCenter);
}

highp vec2 pointCoordinates(highp vec2 center, highp float radius, highp float angle) {
    
    return vec2(center.x + radius * cos(angle), center.y - radius * sin(angle));
}

"""
    
    return ShaderSource(vertex: vertex, fragment: fragment)
}()
