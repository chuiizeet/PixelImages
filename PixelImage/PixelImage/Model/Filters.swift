//
//  Filters.swift
//  PixelImage
//
//  Created by imac on 9/7/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

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
