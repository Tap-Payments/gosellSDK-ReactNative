//
//  CGImage+Additions.swift
//  TapAdditionsKit
//
//  Copyright © 2019 Tap Payments. All rights reserved.
//

import func		Accelerate.vImage.Convolution.vImageBoxConvolve_ARGB8888
import var		Accelerate.vImage.vImage_Types.kvImageEdgeExtend
import var		Accelerate.vImage.vImage_Types.kvImageGetTempBufferSize
import struct	Accelerate.vImage.vImage_Types.vImage_Buffer
import struct	Accelerate.vImage.vImage_Types.vImage_Flags
import struct	Accelerate.vImage.vImage_Types.vImagePixelCount
import func		CoreFoundation.CFData.CFDataGetBytePtr
import enum		CoreGraphics.CGContext.CGBlendMode
import class	CoreGraphics.CGContext.CGContext
import struct	CoreGraphics.CGGeometry.CGSize
import class	CoreGraphics.CGImage.CGImage
import func		Darwin.C.stdlib.free
import func		Darwin.C.stdlib.malloc
import func		Darwin.C.string.memcpy
import class	UIKit.UIColor.UIColor

/// Useful additions to CGImage.
public extension CGImage {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Bytes count.
    var tap_bytesCount: Int {
        
        return self.bytesPerRow * self.height
    }
    
    /// Image size.
    var tap_size: CGSize {
        
        return CGSize(width: self.width, height: self.height)
    }
    
    // MARK: Methods
    
    func tap_blurred(with boxSize: UInt32, iterations: Int, blendColor: UIColor?, blendMode: CGBlendMode) -> CGImage? {
        
        guard let providerData = self.dataProvider?.data else { return nil }
        guard let inData = malloc(self.tap_bytesCount) else { return nil }
        
        var inBuffer = self.tap_imageBuffer(from: inData)
        
        guard let outData = malloc(self.tap_bytesCount) else { return nil }
        var outBuffer = self.tap_imageBuffer(from: outData)
        
        let tempSize = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, boxSize, boxSize, nil, vImage_Flags(kvImageEdgeExtend + kvImageGetTempBufferSize))
        let tempData = malloc(tempSize)
        
        defer {
            
            free(inData)
            free(outData)
            free(tempData)
        }
        
        let source = CFDataGetBytePtr(providerData)
        memcpy(inBuffer.data, source, self.tap_bytesCount)
        
        for _ in 0..<iterations {
            
            vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, tempData, 0, 0, boxSize, boxSize, nil, vImage_Flags(kvImageEdgeExtend))
            
            let temp = inBuffer.data
            inBuffer.data = outBuffer.data
            outBuffer.data = temp
        }
        
        let context = self.colorSpace.flatMap {
            
            CGContext(data: inBuffer.data, width: self.width, height: self.height, bitsPerComponent: self.bitsPerComponent, bytesPerRow: self.bytesPerRow, space: $0, bitmapInfo: self.bitmapInfo.rawValue)
        }
        
        return context?.tap_makeImage(with: blendColor, blendMode: blendMode, size: self.tap_size)
    }
    
    // MARK: - Private -
    // MARK: Methods
    
    private func tap_imageBuffer(from data: UnsafeMutableRawPointer) -> vImage_Buffer {
        
        return vImage_Buffer(data: data, height: vImagePixelCount(self.height), width: vImagePixelCount(self.width), rowBytes: self.bytesPerRow)
    }
}
