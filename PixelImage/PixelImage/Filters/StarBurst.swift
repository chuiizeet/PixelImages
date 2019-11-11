//
//  StarBurst.swift
//  PixelImage
//
//  Created by imac on 11/11/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import CoreImage

class StarBurstFilter: CIFilter
{
    @objc var inputImage : CIImage?
    @objc var inputThreshold: CGFloat = 0.9
    @objc var inputRadius: CGFloat = 20
    @objc var inputAngle: CGFloat = 0
    @objc var inputBeamCount: Int = 3
    @objc var inputStarburstBrightness: CGFloat = 0
    
    let thresholdFilter = ThresholdToAlphaFilter()
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Starburst Filter" as AnyObject,
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            
            "inputThreshold": [kCIAttributeIdentity: 0,
                               kCIAttributeClass: "NSNumber",
                               kCIAttributeDefault: 0.9,
                               kCIAttributeDisplayName: "Threshold",
                               kCIAttributeMin: 0,
                               kCIAttributeSliderMin: 0,
                               kCIAttributeSliderMax: 1,
                               kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputRadius": [kCIAttributeIdentity: 0,
                            kCIAttributeClass: "NSNumber",
                            kCIAttributeDefault: 20,
                            kCIAttributeDisplayName: "Radius",
                            kCIAttributeMin: 0,
                            kCIAttributeSliderMin: 0,
                            kCIAttributeSliderMax: 100,
                            kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputAngle": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "NSNumber",
                           kCIAttributeDefault: 0,
                           kCIAttributeDisplayName: "Angle",
                           kCIAttributeMin: 0,
                           kCIAttributeSliderMin: 0,
                           kCIAttributeSliderMax: Double.pi,
                           kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputStarburstBrightness": [kCIAttributeIdentity: 0,
                                         kCIAttributeClass: "NSNumber",
                                         kCIAttributeDefault: 0,
                                         kCIAttributeDisplayName: "Starburst Brightness",
                                         kCIAttributeMin: -1,
                                         kCIAttributeSliderMin: -1,
                                         kCIAttributeSliderMax: 0.5,
                                         kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputBeamCount": [kCIAttributeIdentity: 0,
                               kCIAttributeClass: "NSNumber",
                               kCIAttributeDefault: 3,
                               kCIAttributeDisplayName: "Beam Count",
                               kCIAttributeMin: 1,
                               kCIAttributeSliderMin: 1,
                               kCIAttributeSliderMax: 10,
                               kCIAttributeType: kCIAttributeTypeInteger]
        ]
    }
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        thresholdFilter.inputThreshold = inputThreshold
        thresholdFilter.inputImage = inputImage
        
        let thresholdImage = thresholdFilter.outputImage!
        
        let starBurstAccumulator = CIImageAccumulator(extent: thresholdImage.extent,
                                                      format: CIFormat.ARGB8)
        
        for i in 0 ..< inputBeamCount
        {
            let angle = CGFloat((Double.pi / Double(inputBeamCount)) * Double(i))
            
            let starburst = thresholdImage.applyingFilter("CIMotionBlur",
                                                          parameters: [kCIInputRadiusKey: inputRadius, kCIInputAngleKey: inputAngle + angle])
                .cropped(to: thresholdImage.extent)
                .applyingFilter("CIAdditionCompositing", parameters: [kCIInputBackgroundImageKey: starBurstAccumulator?.image() as Any])
            
            starBurstAccumulator?.setImage(starburst)
        }
        
        let adjustedStarBurst = starBurstAccumulator?.image()
            .applyingFilter("CIColorControls", parameters: [kCIInputBrightnessKey: inputStarburstBrightness])
        
        let final = inputImage.applyingFilter("CIAdditionCompositing", parameters: [kCIInputBackgroundImageKey: adjustedStarBurst as Any])
        
        return final
    }
    
}

class ThresholdFilter: CIFilter
{
    @objc var inputImage : CIImage?
    @objc var inputThreshold: CGFloat = 0.75
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Threshold Filter" as AnyObject,
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            "inputThreshold": [kCIAttributeIdentity: 0,
                               kCIAttributeClass: "NSNumber",
                               kCIAttributeDefault: 0.75,
                               kCIAttributeDisplayName: "Threshold",
                               kCIAttributeMin: 0,
                               kCIAttributeSliderMin: 0,
                               kCIAttributeSliderMax: 1,
                               kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    override func setDefaults()
    {
        inputThreshold = 0.75
    }
    
    override init()
    {
        super.init()
        thresholdKernel = CIColorKernel(source:
            "kernel vec4 thresholdFilter(__sample image, float threshold)" +
                "{" +
                "   float luma = dot(image.rgb, vec3(0.2126, 0.7152, 0.0722));" +
                
                "   return vec4(step(threshold, luma));" +
            "}"
        )
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var thresholdKernel: CIColorKernel?
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage,
            let thresholdKernel = thresholdKernel else
        {
            return nil
        }
        
        let extent = inputImage.extent
        let arguments = [inputImage, inputThreshold] as [Any]
        
        return thresholdKernel.apply(extent: extent, arguments: arguments)
    }
}

class ThresholdToAlphaFilter: ThresholdFilter
{
    override var attributes: [String : Any]
    {
        var superAttributes = super.attributes
        
        superAttributes[kCIAttributeFilterDisplayName] = "Threshold To Alpha Filter" as AnyObject?
        
        return superAttributes
    }
    
    override init()
    {
        super.init()
        
        thresholdKernel = CIColorKernel(source:
            "kernel vec4 thresholdFilter(__sample image, float threshold)" +
                "{" +
                "   float luma = dot(image.rgb, vec3(0.2126, 0.7152, 0.0722));" +
                
                "   return vec4(image.rgb, image.a * step(threshold, luma));" +
            "}"
        )
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
