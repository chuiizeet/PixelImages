//
//  RGBAPixel.swift
//  PixelImage
//
//  Created by imac on 9/6/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

public struct RGBAPixel {
    public init(rawVal: UInt32) {
        raw = rawVal
    }
    
    public init(r: UInt8, g: UInt8, b: UInt8) {
        raw = 0xFF000000 | UInt32(r) | UInt32(g) << 8 | UInt32(b) << 16
    }
    
    public var raw: UInt32
    public var red: UInt8 {
        get { return UInt8(raw & 0xFF) }
        set { raw = UInt32(newValue) | (raw & 0xFFFFFF00) }
    }
    public var green: UInt8 {
        get { return UInt8((raw & 0xFF00) >> 8) }
        set { raw = (UInt32(newValue) << 8) | (raw & 0xFFFF00FF) }
    }
    public var blue: UInt8 {
        get { return UInt8((raw & 0xFF0000) >> 16) }
        set { raw = (UInt32(newValue) << 16) | (raw & 0xFF00FFFF) }
    }
    public var alpha: UInt8 {
        get { return UInt8((raw & 0xFF000000) >> 24) }
        set { raw = (UInt32(newValue) << 24) | (raw & 0x00FFFFFF) }
    }
    
    public var averageIntensity: UInt8 {
        get { return UInt8((UInt32(red)+UInt32(green)+UInt32(blue))/3) }
    }
}
