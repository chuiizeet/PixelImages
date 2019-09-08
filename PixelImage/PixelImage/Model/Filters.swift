//
//  Filters.swift
//  PixelImage
//
//  Created by imac on 9/7/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

let allFilters: [Filter] = [
    ScaleOntensityFilter(scale: 0.5),
    MixFilter(),
    GrayScale(),
    InvertFilter(),
    colors8Filter(),
    Dither8Filter()
]

let palette8: [RGBAPixel] = [
    RGBAPixel(r: 0, g: 0, b: 0),
    RGBAPixel(r: 0xFF, g: 0xFF, b: 0xFF),
    RGBAPixel(r: 0xFF, g: 0x0, b: 0x0),
    RGBAPixel(r: 0x0, g: 0xFF, b: 0x0),
    RGBAPixel(r: 0x0, g: 0x0, b: 0xFF),
    RGBAPixel(r: 0xFF, g: 0xFF, b: 0x0),
    RGBAPixel(r: 0xFF, g: 0x0, b: 0xFF),
    RGBAPixel(r: 0x0, g: 0xFF, b: 0xFF),
    
]

class colors8Filter: Filter {
    var name: String = "8 colors"
    func apply(input: Image) -> Image {
        return input.transfromPixels(transformFunc: { (p:RGBAPixel) -> RGBAPixel in
            return p.findClosestMatch(palette: palette8)
        })
    }
}

class Dither8Filter: Filter {
    var name: String = "Dither 8 colors"
    func apply(input: Image) -> Image {
        var delta = PixelDelta(rDelta: 0, gDelta: 0, bDelta: 0)
        return input.transfromPixels(transformFunc: { (requestedPixel:RGBAPixel) -> RGBAPixel in
            delta = delta.add(p: requestedPixel)
            let newPixel = delta.asPixel().findClosestMatch(palette: palette8)
            
            delta = delta.subtract(p: newPixel)
            
            return newPixel
        })
    }
}

class ScaleOntensityFilter: Filter {
    var name: String = "Scale intensity"
    let scale: Double
    
    init(scale: Double) {
        self.scale = scale
    }
    
    func apply(input: Image) -> Image {
        return input.transfromPixels(transformFunc: { (p1:RGBAPixel) -> RGBAPixel in
            var p = p1
            p.red = UInt8(Double(p.red) * self.scale)
            p.green = UInt8(Double(p.green) * self.scale)
            p.blue = UInt8(Double(p.blue) * self.scale)
            return p
        })
    }
}

class MixFilter: Filter {
    var name: String = "Mix filter"
    func apply(input: Image) -> Image {
        return input.transfromPixels(transformFunc: { (p1:RGBAPixel) -> RGBAPixel in
            var p = p1
            let r = p.red
            p.red = p.blue
            p.blue = p.green
            p.green = r
            return p
        })
    }
}

class GrayScale: Filter {
    var name: String = "Gray scale filter"
    func apply(input: Image) -> Image {
        return input.transfromPixels(transformFunc: { (p:RGBAPixel) -> RGBAPixel in
            let i = p.averageIntensity
            return RGBAPixel(r: i, g: i, b: i)
        })
    }
}

class InvertFilter: Filter {
    var name: String = "Invert filter"
    func apply(input: Image) -> Image {
        return input.transfromPixels(transformFunc: { (p:RGBAPixel) -> RGBAPixel in
            return RGBAPixel(r: (0xFF-p.red), g: (0xFF-p.green), b: (0xFF-p.blue))
        })
    }
}
