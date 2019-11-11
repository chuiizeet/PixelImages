//
//  VintageVignette.swift
//  PixelImage
//
//  Created by imac on 11/11/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import CoreImage

class VintageVignette: CIFilter
{
    @objc var inputImage : CIImage?
    
    @objc var inputVignetteIntensity: CGFloat = 1
    @objc var inputVignetteRadius: CGFloat = 1
    @objc var inputSepiaToneIntensity: CGFloat = 1
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Vintage Vignette" as AnyObject,
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            
            "inputVignetteIntensity": [kCIAttributeIdentity: 0,
                                       kCIAttributeClass: "NSNumber",
                                       kCIAttributeDefault: 1,
                                       kCIAttributeDisplayName: "Vignette Intensity",
                                       kCIAttributeMin: 0,
                                       kCIAttributeSliderMin: 0,
                                       kCIAttributeSliderMax: 2,
                                       kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputVignetteRadius": [kCIAttributeIdentity: 0,
                                    kCIAttributeClass: "NSNumber",
                                    kCIAttributeDefault: 1,
                                    kCIAttributeDisplayName: "Vignette Radius",
                                    kCIAttributeMin: 0,
                                    kCIAttributeSliderMin: 0,
                                    kCIAttributeSliderMax: 2,
                                    kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputSepiaToneIntensity": [kCIAttributeIdentity: 0,
                                        kCIAttributeClass: "NSNumber",
                                        kCIAttributeDefault: 1,
                                        kCIAttributeDisplayName: "Sepia Tone Intensity",
                                        kCIAttributeMin: 0,
                                        kCIAttributeSliderMin: 0,
                                        kCIAttributeSliderMax: 1,
                                        kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    override func setDefaults()
    {
        inputVignetteIntensity = 1
        inputVignetteRadius = 1
        inputSepiaToneIntensity = 1
    }
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        let finalImage = inputImage
            .applyingFilter("CIVignette",
                            parameters: [kCIInputIntensityKey: inputVignetteIntensity, kCIInputRadiusKey: inputVignetteRadius])
            .applyingFilter("CISepiaTone",
                            parameters: [kCIInputIntensityKey: inputSepiaToneIntensity])
        
        return finalImage
    }
    
}
