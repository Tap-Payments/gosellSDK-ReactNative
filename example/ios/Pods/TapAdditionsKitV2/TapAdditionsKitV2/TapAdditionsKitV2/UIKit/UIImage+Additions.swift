//
//  UIImage+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import var		Accelerate.vImage.kvImageEdgeExtend
import var		Accelerate.vImage.kvImageNoFlags
import struct	Accelerate.vImage.vImage_Buffer
import func		Accelerate.vImage.vImageBoxConvolve_ARGB8888
import func		Accelerate.vImage.vImageMatrixMultiply_ARGB8888
import struct	Accelerate.vImage.vImagePixelCount
import struct	Accelerate.vImage.vImage_Flags

import class	CoreFoundation.CFData.CFData
import func		CoreFoundation.CFData.CFDataGetBytePtr

import CoreGraphics

import class	CoreImage.CIContext.CIContext
import class	CoreImage.CIFilter.CIFilter
import class	CoreImage.CIImage.CIImage
import var		CoreImage.kCIInputImageKey
import var		CoreImage.kCIOutputImageKey

import func		Darwin.C.math.lrint
import struct	Darwin.C.stddef.size_t
import func		Darwin.fabs
import func		Darwin.floor
import func		Darwin.round
import func		Darwin.sqrt

import Foundation

import class	ImageIO.CGImageSource
import func		ImageIO.CGImageSource.CGImageSourceCopyPropertiesAtIndex
import func		ImageIO.CGImageSource.CGImageSourceCreateImageAtIndex
import func		ImageIO.CGImageSource.CGImageSourceCreateWithData
import func		ImageIO.CGImageSource.CGImageSourceGetCount
import var		ImageIO.CGImageSource.kCGImagePropertyGIFDelayTime
import var		ImageIO.CGImageSource.kCGImagePropertyGIFDictionary

import class	UIKit.UIBezierPath.UIBezierPath
import class	UIKit.UIColor.UIColor
import struct	UIKit.UIEdgeInsets
import func		UIKit.UIGraphics.UIRectFill
import func		UIKit.UIGraphicsBeginImageContext
import func		UIKit.UIGraphicsBeginImageContextWithOptions
import func		UIKit.UIGraphicsEndImageContext
import func		UIKit.UIGraphicsGetCurrentContext
import func		UIKit.UIGraphicsGetImageFromCurrentImageContext
import class	UIKit.UIImage.UIImage
import class	UIKit.UIScreen.UIScreen
import class	UIKit.UIView.UIView

#if !swift(>=4.2)
import func		UIKit.UIImage.UIImagePNGRepresentation
#endif

/// Useful extension of UIImage class.
public extension UIImage {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Returns mirrored image.
    var tap_mirrored: UIImage {
        
        return UIImage(cgImage: self.tap_nonnullCGImage, scale: self.scale, orientation: .upMirrored)
    }
    
    /// Returns stretchable copy of the receiver.
    var tap_stretchableImage: UIImage {
        
        let topInset = 0.5 * size.height
        let leftInset = 0.5 * size.width
        let capInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: topInset + 1.0, right: leftInset + 1.0)
        
        return resizableImage(withCapInsets: capInsets)
    }
    
    /// Returns tileable copy of the receiver.
    var tap_tileableImage: UIImage {
        
        return resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .tile)
    }
    
    /// Returns size in pixels.
    var tap_sizeInPixels: CGSize {
        
        return self.scale * self.size
    }
    
    /// Predefines if image is large enough for Instagram.
    var tap_isLargeEnoughForInstagram: Bool {
        
        return self.tap_sizeInPixels.tap_fits(into: .tap_minimalInstagramImageSizeInPixels)
    }
    
    /// Defines if image has square form.
    var tap_isSquare: Bool {
        
        return self.size.tap_isSquare
    }
	
	/// Returns png data representation of the receiver.
	var tap_pngData: Data? {
		
		#if swift(>=4.2)
		
		return self.pngData()
		
		#else
		
		return UIImagePNGRepresentation(self)
		
		#endif
	}
	
    /// Returns transparent copy of the receiver.
    var tap_transparentImage: UIImage? {
        
        guard let imageData = self.tap_pngData else { return nil }
        return UIImage(data: imageData)
    }
    
    /// Returns negative copy of the receiver.
    var tap_negativeImage: UIImage? {
        
        let ciImage = self.tap_nonnullCIImage
        guard let negativeFilter = CIFilter(name: "CIColorInvert") else { return nil }
        
        negativeFilter.setValue(ciImage, forKey: kCIInputImageKey)
        
        if let resultCIImage = negativeFilter.value(forKey: kCIOutputImageKey) as? CIImage {
            
            return UIImage(ciImage: resultCIImage, scale: scale, orientation: imageOrientation)
        }
        else {
            
            return nil
        }
    }
    
    /// Returns black-and-white image with inverted mask.
    var tap_invertedMaskImage: UIImage? {
        
        let cgImage                     = self.tap_nonnullCGImage
        
        guard let dataProvider          = cgImage.dataProvider else { return nil }
        
        let decode: [CGFloat]           = [1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0, 1.0]
        let colorSpace: CGColorSpace    = cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
        
        let resultCGImage = CGImage(width: cgImage.width,
                                    height: cgImage.height,
                                    bitsPerComponent: cgImage.bitsPerComponent,
                                    bitsPerPixel: cgImage.bitsPerPixel,
                                    bytesPerRow: cgImage.bytesPerRow,
                                    space: colorSpace,
                                    bitmapInfo: cgImage.bitmapInfo,
                                    provider: dataProvider,
                                    decode: decode,
                                    shouldInterpolate: cgImage.shouldInterpolate,
                                    intent: cgImage.renderingIntent)
    
        guard let resultingCGImage = resultCGImage else { return nil }
        
        let resultUIImage = UIImage(cgImage: resultingCGImage, scale: self.scale, orientation: self.imageOrientation)
        
        return resultUIImage
    }
    
    /// Returns nonnull backing CGImage.
    var tap_nonnullCGImage: CGImage {
        
        if let coreImage = self.ciImage {
            
            return CIContext().createCGImage(coreImage, from: coreImage.extent)!
        }
        else {
            
            return self.cgImage!
        }
    }
    
    /// Returns nonnull backing CIImage.
    var tap_nonnullCIImage: CIImage {
        
        if let coreGraphicsImage = self.cgImage {
            
            return CIImage(cgImage: coreGraphicsImage)
        }
        else {
            
            return self.ciImage!
        }
    }
    
    // MARK: Methods
    
    /**
     Initializes image with GIF data.
     
     - parameter data: GIF image data.
     
     - returns: New instance of UIImage or nil if data is wrong.
     */
    static func tap_imageWithAnimatedGIFData(_ data: Data) -> UIImage? {
        
        let imageSource = CGImageSourceCreateWithData(data as CFData, nil)
        return self.tap_animatedImageWithAnimatedGIF(imageSource: imageSource)
    }
    
    /**
     Initializes an image by combining all the images from array into one putting one after another with the same left bound.
     
     - parameter imagesArray: Images to combine.
     
     - returns: A new instance of UIImage.
     */
    convenience init?(tap_byCombiningImages imagesArray: [UIImage]) {
        
        var offset = CGPoint.zero
        var maximalWidth: CGFloat = 0.0
        
        var pointImages: [NSValue: UIImage] = [:]
        for image in imagesArray {
            
            pointImages[NSValue(cgPoint: offset)] = image
            offset.y += image.size.height
            
            let imageWidth = image.size.width
            if imageWidth > maximalWidth {
                
                maximalWidth = imageWidth
            }
        }
		
        self.init(tap_byCombiningImages: pointImages, withResultingSize: CGSize(width: maximalWidth, height: offset.y), backgroundColor: UIColor.clear, clearImageLocations: false)
    }
	
	/// Initializes an image by combining all the the images as layers, one above another.
	///
	/// - Parameter images: Source images.
	convenience init?(tap_byCombining images: [UIImage]) {
		
		let sizes = images.map { $0.size }
		
		let maxWidth	= sizes.max { $0.width < $1.width }!.width
		let maxHeight	= sizes.max { $0.height < $1.height }!.height
		
		var imagesDictionary: [NSValue: UIImage] = [:]
		for image in images {
			
			let size = image.size
			let location = CGPoint(x: 0.5 * (maxWidth - size.width), y: 0.5 * (maxHeight - size.height))
			imagesDictionary[NSValue(cgPoint: location)] = image
		}
		
		let resultingSize = CGSize(width: maxWidth, height: maxHeight)
		
		self.init(tap_byCombiningImages: imagesDictionary, withResultingSize: resultingSize, backgroundColor: .clear, clearImageLocations: false)
	}
	
    /**
     Initializes an image by combining all the images from array into one with given image locations, resulting size and background color.
     
     - parameter imagesDictionary:    Images dictionary in format [NSValue(CGPoint) : UIImage]. [ image location : image ]
     - parameter size:                Resulting image size.
     - parameter backgroundColor:     Image background fill color.
     - parameter clearImageLocations: Defines if clearRect() should be called before drawing another image.
     
     - returns: A new instance of UIImage or nil if error occured.
     */
    convenience init?(tap_byCombiningImages imagesDictionary: [NSValue: UIImage], withResultingSize size: CGSize, backgroundColor: UIColor, clearImageLocations: Bool) {
        
        var maximalScale: CGFloat = 1.0
        
        for (_, image) in imagesDictionary {
            
            let imageScale = image.scale
            if imageScale > maximalScale {
                
                maximalScale = imageScale
            }
        }
        
        maximalScale.round(.toNearestOrEven)
        
        UIGraphicsBeginImageContextWithOptions(size, false, maximalScale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            
            UIGraphicsEndImageContext()
            return nil
        }
        
        context.saveGState()
        
        context.clear(CGRect(origin: CGPoint.zero, size: size))
        context.setFillColor(backgroundColor.cgColor)
        context.fill(CGRect(origin: CGPoint.zero, size: size))
        
        for ( pointValue, image ) in imagesDictionary {
            
            let point = pointValue.cgPointValue
            
            if clearImageLocations {
                
                context.clear(CGRect(origin: point, size: image.size))
            }
            
            image.draw(at: point)
        }
        
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
            
            context.restoreGState()
            UIGraphicsEndImageContext()
            return nil
        }
        
        context.restoreGState()
        UIGraphicsEndImageContext()
        
        let cgResult = result.tap_nonnullCGImage
        
        self.init(cgImage: cgResult, scale: result.scale, orientation: result.imageOrientation)
    }
    
    /**
     Initializes an image of a given size with a given color.
     
     - parameter size:  Image size.
     - parameter color: Image fill color.
     
     - returns: New instance of UIImage or nil if it could not be created.
     */
    convenience init?(size: CGSize, fillColor color: UIColor) {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            
            UIGraphicsEndImageContext()
            return nil
        }
        
        context.saveGState()
        context.clear(CGRect(origin: CGPoint.zero, size: size))
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: CGPoint.zero, size: size))
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            
            context.restoreGState()
            UIGraphicsEndImageContext()
            return nil
        }
        
        context.restoreGState()
        UIGraphicsEndImageContext()
        
        self.init(cgImage: image.tap_nonnullCGImage, scale: image.scale, orientation: image.imageOrientation)
    }
    
    /// Looks up and returns an image with a given name in a given bundle.
    ///
    /// - Parameters:
    ///   - name: Image name.
    ///   - bundle: Bundle.
    /// - Returns: Image if found, nil otherwise
    static func tap_named(_ name: String, in bundle: Bundle) -> UIImage? {
        
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    /// Returns content mode which best suites to fit the receiver in a given size.
    ///
    /// - Parameter size: Size.
    /// - Returns: Content mode.
    func tap_bestContentMode(toFit size: CGSize) -> UIView.ContentMode {
        
        let widthFits       = self.size.width <= size.width
        let heightFits      = self.size.height <= size.height
        let proportion      = self.size.width / self.size.height
        let frameProportion = size.width / size.height
        
        switch (widthFits, heightFits) {
            
        case (true, true):
            
            return .center
            
        case (true, false), (false, true):
            
            return .scaleAspectFit
            
        case (false, false):
            
            return proportion == frameProportion ? .scaleToFill : .scaleAspectFit
            
        }
    }
	
	/// Returns the copy of the receiver by applying tint color to any non-clear pixel.
	///
	/// - Parameter color: Tint color to apply.
	/// - Returns: Tinted image.
	func tap_byApplyingTint(color: UIColor) -> UIImage? {
		
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		let context = UIGraphicsGetCurrentContext()
		context?.saveGState()
		
		let bounds = CGRect(origin: .zero, size: self.size)
		
		color.setFill()
		UIRectFill(bounds)
		
		self.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		
		context?.restoreGState()
		UIGraphicsEndImageContext()
		
		return image
	}
	
    /**
     Returns copy of the receiver by applying light blur effect.
     
     - returns: New instance of UIImage or nil if error occured.
     */
    func tap_applyLightEffect() -> UIImage? {
        
        return self.tap_applyBlur(with: 20.0, tintColor: .tap_lightBlurTintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    /**
     Returns copy of the receiver by applying extra light blur effect.
     
     - returns: New instance of UIImage or nil if error occured.
     */
    func tap_applyExtraLightEffect() -> UIImage? {
        
        return self.tap_applyBlur(with: 20.0, tintColor: .tap_extraLightBlurTintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    /**
     Returns copy of the receiver by applying dark blur effect.
     
     - returns: New instance of UIImage or nil if error occured.
     */
    func tap_applyDarkEffect() -> UIImage? {
        
        return self.tap_applyBlur(with: 20.0, tintColor: .tap_darkBlurTintColor, saturationDeltaFactor: 1.8, maskImage: nil)
    }
    
    /**
     Applies tint effect to the image.
     
     - parameter tintColor: Tint color.
     
     - returns: A tinted copy of the receiver or nil if an error occured.
     */
    func tap_applyTintEffect(with tintColor: UIColor) -> UIImage? {
        
        let effectColorAlpha: CGFloat = 0.6
        
        var effectColor = tintColor
        
        if tintColor.cgColor.numberOfComponents == 2 {
            
            var white: CGFloat = 0
            if tintColor.getWhite(&white, alpha: nil) {
                
                effectColor = UIColor(white: white, alpha: effectColorAlpha)
            }
        }
        else {
            
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            
            if tintColor.getRed(&red, green: &green, blue: &blue, alpha: nil) {
                
                effectColor = UIColor(red: red, green: green, blue: blue, alpha: effectColorAlpha)
            }
        }
        
        return self.tap_applyBlur(with: 10.0, tintColor: effectColor, saturationDeltaFactor: -1.0, maskImage: nil)
    }
    
    /**
     Returns copy of the receiver by applying blur effect to it.
     
     - parameter blurRadius:            Blur radius.
     - parameter tintColor:             Tint color.
     - parameter saturationDeltaFactor: Saturation delta factor.
     - parameter maskImage:             Masking image.
     
     - returns: A new instance of UIImage or nil if error occured.
     */
    func tap_applyBlur(with blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage?) -> UIImage? {
        
        guard size.width >= 1.0 && size.height >= 1.0 else {
            
            print("Invalid image size: (\(size.width), \(size.height))")
            return nil
        }
        
        let imageRect = CGRect(origin: CGPoint.zero, size: size)
        var effectImage: UIImage = self
        
        let hasBlur: Bool = blurRadius > CGFloat.ulpOfOne
        let hasSaturationChange: Bool = abs(saturationDeltaFactor - 1.0) > CGFloat.ulpOfOne
        
        if hasBlur || hasSaturationChange {
            
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            
            guard let effectInContext = UIGraphicsGetCurrentContext() else {
                
                UIGraphicsEndImageContext()
                return nil
            }
            
            effectInContext.scaleBy(x: 1.0, y: -1.0)
            effectInContext.translateBy(x: 0, y: -size.height)
            effectInContext.draw(self.tap_nonnullCGImage, in: imageRect)
            
            var effectInBuffer = vImage_Buffer(tap_context: effectInContext)
            
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            
            guard let effectOutContext = UIGraphicsGetCurrentContext() else {
                
                UIGraphicsEndImageContext()
                UIGraphicsEndImageContext()
                return nil
            }
            
            var effectOutBuffer = vImage_Buffer(tap_context: effectOutContext)
            
            if hasBlur {
                
                let inputRadius = blurRadius * UIScreen.main.scale
                
                let sqrt2Pi = sqrt(Double.pi * 2.0)
                let doubleRadius = Double(inputRadius) * 3.0 * sqrt2Pi / 4.0 + 0.5
                
                var radius: UInt32 = UInt32(floor(doubleRadius))
                if radius % 2 != 1 {
                    
                    radius += 1
                }
                
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
            }
            
            var effectImageBuffersAreSwapped = false
            if hasSaturationChange {
                
                let floatingPointSaturationMatrix: [CGFloat] = type(of: self).tap_blurSaturationMatrix(with: saturationDeltaFactor)
                
                let divisor = 256
                let matrixSize = floatingPointSaturationMatrix.count
                
                var saturationMatrix: [Int16] = []
                for index in 0..<matrixSize {
                    
                    saturationMatrix.append(Int16(round(floatingPointSaturationMatrix[index] * CGFloat(divisor))))
                }
                
                if hasBlur {
                    
                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                    effectImageBuffersAreSwapped = true
                }
                else {
                    
                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
                }
            }
            
            if !effectImageBuffersAreSwapped, let currentContextImage = UIGraphicsGetImageFromCurrentImageContext() {
                
                effectImage = currentContextImage
            }
            
            UIGraphicsEndImageContext()
            
            if effectImageBuffersAreSwapped, let currentContextImage = UIGraphicsGetImageFromCurrentImageContext() {
                
                effectImage = currentContextImage
            }
            
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        guard let outputContext = UIGraphicsGetCurrentContext() else {
            
            UIGraphicsEndImageContext()
            return nil
        }
        
        outputContext.scaleBy(x: 1.0, y: -1.0)
        outputContext.translateBy(x: 0, y: -size.height)
        
        outputContext.draw(self.tap_nonnullCGImage, in: imageRect)
        
        if hasBlur {
            
            outputContext.saveGState()
            if let nonnullMaskImage = maskImage {
                
                outputContext.clip(to: imageRect, mask: nonnullMaskImage.tap_nonnullCGImage)
            }
            
            outputContext.draw(effectImage.tap_nonnullCGImage, in: imageRect)
            outputContext.restoreGState()
        }
        
        if let nonnullTintColor = tintColor {
            
            outputContext.saveGState()
            outputContext.setFillColor(nonnullTintColor.cgColor)
            outputContext.fill(imageRect)
            outputContext.restoreGState()
        }
        
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    
    /**
     Returns rotated copy of the receiver.
     
     - parameter degrees: Degrees
     
     - returns: Rotated copy of the receiver.
     */
    func tap_rotate(degrees: CGFloat) -> UIImage? {
        
        let angle = degrees * CGFloat.pi / 180.0
        
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        rotatedViewBox.transform = CGAffineTransform(rotationAngle: angle)
        
        let rotatedSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        guard let bitmap = UIGraphicsGetCurrentContext() else {
            
            UIGraphicsEndImageContext()
            return nil
        }
        
        bitmap.translateBy(x: 0.5 * rotatedSize.width, y: 0.5 * rotatedSize.height)
        bitmap.rotate(by: angle)
        bitmap.scaleBy(x: 1.0, y: -1.0)
        
        bitmap.draw(self.tap_nonnullCGImage, in: CGRect(origin: CGPoint(x: -0.5 * size.width, y: -0.5 * size.height), size: size))
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    /**
     Creates new image from receiver by rounding corners.
     
     - parameter cornerRadius: Corner radius.
     
     - returns: New instance of UIImage.
     */
    func tap_byRoundingCorners(cornerRadius: CGFloat) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let path = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerRadius: cornerRadius)
        path.addClip()
        draw(at: CGPoint.zero)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
    
    /**
     Returns color of a given point.
     
     - parameter point: Point to get the color.
     
     - returns: UIColor or nil if point is outside the image.
     */
    func tap_color(at point: CGPoint) -> UIColor? {
        
        guard CGRect(origin: CGPoint.zero, size: size).contains(point) else { return nil }
        
        guard let pixelData = self.tap_nonnullCGImage.dataProvider?.data, let data = CFDataGetBytePtr(pixelData) else { return nil }
        
        let pixelInfo = Int(4 * ( size.width * point.y + point.x ))
        
        let red = CGFloat(data[pixelInfo + 2]) / 255.0
        let green = CGFloat(data[pixelInfo + 1]) / 255.0
        let blue = CGFloat(data[pixelInfo]) / 255.0
        let alpha = CGFloat(data[pixelInfo + 3]) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// scale image to new image
    ///
    /// - Parameter aSize: size of new image
    /// - Returns: resized image
    func tap_scaleToSize(_ aSize: CGSize) -> UIImage? {
        
        guard !self.size.equalTo(aSize) else { return self }
        
        UIGraphicsBeginImageContextWithOptions(aSize, false, 0.0)
        self.draw(in: CGRect.init(x: 0.0, y: 0.0, width: aSize.width, height: aSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func tap_blurred(withRadius radius: CGFloat, iterations: Int, ratio: CGFloat, blendColor color: UIColor?, blendMode mode: CGBlendMode) -> UIImage? {
        
        let cgImage = self.tap_nonnullCGImage
        
        if cgImage.tap_size.tap_area <= 0 || radius <= 0 { return self }
        
        var boxSize = UInt32(radius * self.scale * ratio)
        if boxSize % 2 == 0 {
            
            boxSize += 1
        }
        
        return cgImage.tap_blurred(with: boxSize, iterations: iterations, blendColor: color, blendMode: mode).map {
            
            UIImage(cgImage: $0, scale: scale, orientation: imageOrientation)
        }
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private static func tap_animatedImageWithAnimatedGIF(imageSource: CGImageSource?) -> UIImage? {
        
        guard let nonnullImageSource = imageSource else { return nil }
        
        let count = CGImageSourceGetCount(nonnullImageSource)
        
        guard let gifImageFrames = self.tap_createImagesAndDelays(source: nonnullImageSource, count: count) else { return nil }
        
        let images = gifImageFrames.map { return $0.image }
        let delays = gifImageFrames.map { return $0.delay }
        
        let totalDurationCentiseconds = delays.tap_sum
        let duration = TimeInterval(totalDurationCentiseconds) / 100.0
		
		guard let frames = self.tap_frameArray(size: count,
											   images: images,
											   delays: delays,
											   totalDurationInCentiseconds: Int(duration)) else { return nil }
		
        return UIImage.animatedImage(with: frames, duration: duration)
    }
    
    private static func tap_createImagesAndDelays(source: CGImageSource, count: size_t) -> [GIFImageFrame]? {
        
        var result: [GIFImageFrame] = []
        
        for index in 0..<count {
            
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                
                result.append(GIFImageFrame(image: image, delay: self.tap_delayCentiseconds(for: source, index: index)))
            }
            else {
                
                return nil
            }
        }
        
        return result
    }
    
    private static func tap_delayCentiseconds(for imageSource: CGImageSource, index: Int) -> Int {
        
        var delayCentiseconds = 1
        
        if let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil) as NSDictionary? {
            
            if let gifProperties = properties[kCGImagePropertyGIFDictionary as String] as? NSDictionary {
                
                if let gifDelayNumber = gifProperties[kCGImagePropertyGIFDelayTime as String] as? NSNumber {
                    
                    delayCentiseconds = lrint(gifDelayNumber.doubleValue * 100.0)
                }
            }
        }
        
        return delayCentiseconds
    }
    
    private static func tap_frameArray(size: Int, images: [CGImage], delays: [Int], totalDurationInCentiseconds: Int) -> [UIImage]? {
        
        let gcd = delays.tap_gcd
        guard gcd > 0 else { return nil }
        
        var frames: [UIImage] = []
        
        for index in 0..<size {
            
            let frame = UIImage(cgImage: images[index])
            for _ in stride(from: delays[index] / gcd, to: 0, by: -1) {
                
                frames.append(frame)
            }
        }
        
        return frames
    }
    
    private static func tap_blurSaturationMatrix(with deltaFactor: CGFloat) -> [CGFloat] {
        
        let z00722: CGFloat = 0.0722
        let z07152: CGFloat = 0.7152
        let z02126: CGFloat = 0.2126
        
        let f00722 = z00722 * deltaFactor
        let f09278 = deltaFactor - f00722
        let f07152 = z07152 * deltaFactor
        let f02848 = deltaFactor - f07152
        let f02126 = z02126 * deltaFactor
        let f07873 = 0.7873 * deltaFactor // why 0.7873 instead of 0.7874 - unknown
        
        let e00 = z00722 + f09278
        let e01 = z00722 - f00722
        let e02 = z00722 - f00722
        
        let e04 = z07152 - f07152
        let e05 = z07152 + f02848
        
        let e08 = z02126 - f02126
        let e10 = z02126 + f07873
        
        let zero: CGFloat = 0.0
        let one: CGFloat = 1.0
        
        let result: [CGFloat] = [
            
            e00, e01, e02, zero,
            e04, e05, e04, zero,
            e08, e08, e10, zero,
            zero, zero, zero, one
        ]
        
        return result
    }
}

fileprivate extension vImage_Buffer {
    
    init(tap_context: CGContext) {
        
        self.init(data:		tap_context.data,
                  height:	vImagePixelCount(tap_context.height),
                  width:	vImagePixelCount(tap_context.width),
                  rowBytes:	tap_context.bytesPerRow)
    }
}

private struct GIFImageFrame {
    
    fileprivate var image: CGImage
    fileprivate var delay: Int
}
