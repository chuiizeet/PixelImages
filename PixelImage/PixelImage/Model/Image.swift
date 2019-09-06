//
//  Image.swift
//  PixelImage
//
//  Created by imac on 9/6/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

class Image {
    let pixels: UnsafeMutableBufferPointer<RGBAPixel>
    let height: Int
    let width: Int
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitMapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedLast.rawValue
    let bitsPerComponent = Int(8)
    let bytesPerRow: Int
    
    public init (image: UIImage) {
        height = Int(image.size.height)
        width = Int(image.size.width)
        bytesPerRow = 4 * width
        
        let rawData = UnsafeMutablePointer<RGBAPixel>.allocate(capacity: (width * height))
        let pointZero = CGPoint(x: 0, y: 0)
        let rect = CGRect(origin: pointZero, size: image.size)
        
        let imageContext = CGContext(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo)
        
        imageContext?.draw(image.cgImage!, in: rect)
        
        pixels = UnsafeMutableBufferPointer<RGBAPixel>(start: rawData, count: width * height)
    }
    
    public func toUIImage() -> UIImage {
        let outContext = CGContext(data: pixels.baseAddress, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitMapInfo, releaseCallback: nil, releaseInfo: nil)
        
        
        return UIImage(cgImage: (outContext?.makeImage())!)
    }
}
