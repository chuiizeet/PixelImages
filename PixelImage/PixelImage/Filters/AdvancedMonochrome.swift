//
//  AdvancedMonochrome.swift
//  PixelImage
//
//  Created by imac on 11/11/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import CoreImage

class AdvancedMonochrome: CIFilter
{
    @objc var inputImage : CIImage?
    
    @objc var inputRedBalance: CGFloat = 1
    @objc var inputGreenBalance: CGFloat = 1
    @objc var inputBlueBalance: CGFloat = 1
    @objc var inputClamp: CGFloat = 0
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Advanced Monochrome" as AnyObject,
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            "inputRedBalance": [kCIAttributeIdentity: 0,
                                kCIAttributeClass: "NSNumber",
                                kCIAttributeDefault: 1,
                                kCIAttributeDisplayName: "Red Balance",
                                kCIAttributeMin: 0,
                                kCIAttributeSliderMin: 0,
                                kCIAttributeSliderMax: 1,
                                kCIAttributeType: kCIAttributeTypeScalar],
            "inputGreenBalance": [kCIAttributeIdentity: 0,
                                  kCIAttributeClass: "NSNumber",
                                  kCIAttributeDefault: 1,
                                  kCIAttributeDisplayName: "Green Balance",
                                  kCIAttributeMin: 0,
                                  kCIAttributeSliderMin: 0,
                                  kCIAttributeSliderMax: 1,
                                  kCIAttributeType: kCIAttributeTypeScalar],
            "inputBlueBalance": [kCIAttributeIdentity: 0,
                                 kCIAttributeClass: "NSNumber",
                                 kCIAttributeDefault: 1,
                                 kCIAttributeDisplayName: "Blue Balance",
                                 kCIAttributeMin: 0,
                                 kCIAttributeSliderMin: 0,
                                 kCIAttributeSliderMax: 1,
                                 kCIAttributeType: kCIAttributeTypeScalar],
            "inputClamp": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "NSNumber",
                           kCIAttributeDefault: 0,
                           kCIAttributeDisplayName: "Clamp",
                           kCIAttributeMin: 0,
                           kCIAttributeSliderMin: 0,
                           kCIAttributeSliderMax: 1,
                           kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    let kernel = CIColorKernel(source:
        "kernel vec4 advancedMonochrome(__sample pixel, float redBalance, float greenBalance, float blueBalance, float clamp)" +
            "{" +
            "   float scale = 1.0 / (redBalance + greenBalance + blueBalance);" +
            
            "   float red = pixel.r * redBalance * scale;" +
            "   float green = pixel.g * greenBalance * scale;" +
            "   float blue = pixel.b * blueBalance * scale;" +
            
            "   vec3 grey = vec3(red + green + blue);" +
            
            "   grey = mix(grey, smoothstep(0.0, 1.0, grey), clamp); " +
            
            "   return vec4(grey, pixel.a);" +
        "}")
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage,
            let kernel = kernel else
        {
            return nil
        }
        
        let extent = inputImage.extent
        let arguments = [inputImage, inputRedBalance, inputGreenBalance, inputBlueBalance, inputClamp] as [Any]
        
        return kernel.apply(extent: extent, arguments: arguments)
    }
}

