//
//  PixelDelta.swift
//  PixelImage
//
//  Created by imac on 9/8/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

public struct PixelDelta {
    init (rDelta: Int, gDelta: Int, bDelta: Int) {
        self.rDelta = rDelta
        self.gDelta = gDelta
        self.bDelta = bDelta
    }
    
    func add(p: RGBAPixel) -> PixelDelta {
        return PixelDelta(rDelta: self.rDelta + Int(p.red), gDelta: self.gDelta + Int(p.green), bDelta: self.bDelta + Int(p.blue))
    }
    
    func subtract(p: RGBAPixel) -> PixelDelta {
        return PixelDelta(rDelta: self.rDelta - Int(p.red), gDelta: self.gDelta - Int(p.green), bDelta: self.bDelta - Int(p.blue))
    }
    
    func asPixel() -> RGBAPixel {
        return RGBAPixel(r: limitToLegalColorChannelRange(delta: rDelta), g: limitToLegalColorChannelRange(delta: gDelta), b: limitToLegalColorChannelRange(delta: bDelta))
    }
    
    func limitToLegalColorChannelRange(delta: Int) -> UInt8 {
        if (delta < 0) {
            return 0
        } else if (delta > 0xFF ){
            return 0xFF
        } else {
            return UInt8(delta)
        }
    }
    
    let rDelta: Int
    let gDelta: Int
    let bDelta: Int
}
