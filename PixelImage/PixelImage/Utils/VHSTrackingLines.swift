//
//  VHSTrackingLines.swift
//  PixelImage
//
//  Created by imac on 9/11/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import CoreImage

class VHSTrackingLines: CIFilter
{
    var inputImage: CIImage?
    var inputTime: CGFloat = 0
    var inputSpacing: CGFloat = 50
    var inputStripeHeight: CGFloat = 0.5
    var inputBackgroundNoise: CGFloat = 0.05
    
    override func setDefaults()
    {
        inputSpacing = 50
        inputStripeHeight = 0.5
        inputBackgroundNoise = 0.05
    }
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "VHS Tracking Lines",
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            "inputTime": [kCIAttributeIdentity: 0,
                          kCIAttributeClass: "NSNumber",
                          kCIAttributeDefault: 8,
                          kCIAttributeDisplayName: "Time",
                          kCIAttributeMin: 0,
                          kCIAttributeSliderMin: 0,
                          kCIAttributeSliderMax: 2048,
                          kCIAttributeType: kCIAttributeTypeScalar],
            "inputSpacing": [kCIAttributeIdentity: 0,
                             kCIAttributeClass: "NSNumber",
                             kCIAttributeDefault: 50,
                             kCIAttributeDisplayName: "Spacing",
                             kCIAttributeMin: 20,
                             kCIAttributeSliderMin: 20,
                             kCIAttributeSliderMax: 200,
                             kCIAttributeType: kCIAttributeTypeScalar],
            "inputStripeHeight": [kCIAttributeIdentity: 0,
                                  kCIAttributeClass: "NSNumber",
                                  kCIAttributeDefault: 0.5,
                                  kCIAttributeDisplayName: "Stripe Height",
                                  kCIAttributeMin: 0,
                                  kCIAttributeSliderMin: 0,
                                  kCIAttributeSliderMax: 1,
                                  kCIAttributeType: kCIAttributeTypeScalar],
            "inputBackgroundNoise": [kCIAttributeIdentity: 0,
                                     kCIAttributeClass: "NSNumber",
                                     kCIAttributeDefault: 0.05,
                                     kCIAttributeDisplayName: "Background Noise",
                                     kCIAttributeMin: 0,
                                     kCIAttributeSliderMin: 0,
                                     kCIAttributeSliderMax: 0.25,
                                     kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        let tx = NSValue(cgAffineTransform: CGAffineTransform(translationX: CGFloat(drand48() * 100), y: CGFloat(drand48() * 100)))
        
        let noise = CIFilter(name: "CIRandomGenerator")!.outputImage!
            .applyingFilter("CIAffineTransform",
                            parameters: [kCIInputTransformKey: tx])
            .applyingFilter("CILanczosScaleTransform",
                            parameters: [kCIInputAspectRatioKey: 5])
            .cropped(to: inputImage.extent)
        
        
        let kernel = CIColorKernel(source:
            "kernel vec4 thresholdFilter(__sample image, __sample noise, float time, float spacing, float stripeHeight, float backgroundNoise)" +
                "{" +
                "   vec2 uv = destCoord();" +
                
                "   float stripe = smoothstep(1.0 - stripeHeight, 1.0, sin((time + uv.y) / spacing)); " +
                
                "   return image + (noise * noise * stripe) + (noise * backgroundNoise);" +
            "}"
            )!
        
        
        let extent = inputImage.extent
        let arguments = [inputImage, noise, inputTime, inputSpacing, inputStripeHeight, inputBackgroundNoise] as [Any]
        
        let final = kernel.apply(extent: extent, arguments: arguments)! .applyingFilter("CIPhotoEffectNoir")
        
        return final
    }
}

class CRTFilter: CIFilter
{
    var inputImage : CIImage?
    var inputPixelWidth: CGFloat = 8
    var inputPixelHeight: CGFloat = 12
    var inputBend: CGFloat = 3.2
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "CRT Filter",
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            "inputPixelWidth": [kCIAttributeIdentity: 0,
                                kCIAttributeClass: "NSNumber",
                                kCIAttributeDefault: 8,
                                kCIAttributeDisplayName: "Pixel Width",
                                kCIAttributeMin: 0,
                                kCIAttributeSliderMin: 0,
                                kCIAttributeSliderMax: 20,
                                kCIAttributeType: kCIAttributeTypeScalar],
            "inputPixelHeight": [kCIAttributeIdentity: 0,
                                 kCIAttributeClass: "NSNumber",
                                 kCIAttributeDefault: 12,
                                 kCIAttributeDisplayName: "Pixel Height",
                                 kCIAttributeMin: 0,
                                 kCIAttributeSliderMin: 0,
                                 kCIAttributeSliderMax: 20,
                                 kCIAttributeType: kCIAttributeTypeScalar],
            "inputBend": [kCIAttributeIdentity: 0,
                          kCIAttributeClass: "NSNumber",
                          kCIAttributeDefault: 3.2,
                          kCIAttributeDisplayName: "Bend",
                          kCIAttributeMin: 0.5,
                          kCIAttributeSliderMin: 0.5,
                          kCIAttributeSliderMax: 10,
                          kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    let crtWarpFilter = CRTWarpFilter()
    let crtColorFilter = CRTColorFilter()
    
    let vignette = CIFilter(name: "CIVignette",
                            parameters: [
                                kCIInputIntensityKey: 1.5,
                                kCIInputRadiusKey: 2])!
    
    override func setDefaults()
    {
        inputPixelWidth = 8
        inputPixelHeight = 12
        inputBend = 3.2
    }
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage else
        {
            return nil
        }
        
        crtColorFilter.pixelHeight = inputPixelHeight
        crtColorFilter.pixelWidth = inputPixelWidth
        crtWarpFilter.bend =  inputBend
        
        crtColorFilter.inputImage = inputImage
        vignette.setValue(crtColorFilter.outputImage,
                          forKey: kCIInputImageKey)
        crtWarpFilter.inputImage = vignette.outputImage!
        
        return crtWarpFilter.outputImage
    }
}
    
class CRTColorFilter: CIFilter
{
    var inputImage : CIImage?
    
    var pixelWidth: CGFloat = 8.0
    var pixelHeight: CGFloat = 12.0
    
    let crtColorKernel = CIColorKernel(source:
        "kernel vec4 crtColor(sampler image, float pixelWidth, float pixelHeight) \n" +
            "{ \n" +
            "   vec2 v2 = destCoord(); \n" +
            "   vec4 v4 = sample(image, samplerTransform(image, v2)); \n" +
            
            "   int columnIndex = int(mod(v2.x / pixelWidth, 3.0)); \n" +
            "   int rowIndex = int(mod(v2.y, pixelHeight)); \n" +
            
            "   float scanlineMultiplier = (rowIndex == 0 || rowIndex == 1) ? 0.3 : 1.0;" +
            
            "   float red = (columnIndex == 0) ? v4.r : v4.r * ((columnIndex == 2) ? 0.3 : 0.2); " +
            "   float green = (columnIndex == 1) ? v4.g : v4.g * ((columnIndex == 2) ? 0.3 : 0.2); " +
            "   float blue = (columnIndex == 2) ? v4.b : v4.b * 0.2; " +
            
            "   return vec4(red * scanlineMultiplier, green * scanlineMultiplier, blue * scanlineMultiplier, 1.0); \n" +
        "}"
    )
    
    
    override var outputImage: CIImage!
    {
        if let inputImage = inputImage,
            let crtColorKernel = crtColorKernel
        {
            let dod = inputImage.extent
            let args = [inputImage, pixelWidth, pixelHeight] as [Any]
            let img = crtColorKernel.apply(extent: dod, arguments: args)
            return img
        }
        return nil
    }
}
    
class CRTWarpFilter: CIFilter
{
    var inputImage : CIImage?
    var bend: CGFloat = 3.2
    
    let crtWarpKernel = CIWarpKernel(source:
        "kernel vec2 crtWarp(vec2 extent, float bend)" +
            "{" +
            "   vec2 coord = ((destCoord() / extent) - 0.5) * 2.0;" +
            
            "   coord.x *= 1.0 + pow((abs(coord.y) / bend), 2.0);" +
            "   coord.y *= 1.0 + pow((abs(coord.x) / bend), 2.0);" +
            
            "   coord  = ((coord / 2.0) + 0.5) * extent;" +
            
            "   return coord;" +
        "}"
    )
    
    override var outputImage : CIImage!
    {
        if let inputImage = inputImage,
            let crtWarpKernel = crtWarpKernel
        {
            let arguments = [CIVector(x: inputImage.extent.size.width, y: inputImage.extent.size.height), bend] as [Any]
            let extent = inputImage.extent.insetBy(dx: -1, dy: -1)
            
            return crtWarpKernel.apply(extent: extent,
                                       roiCallback:
                {
                    (index, rect) in
                    return rect
            },
                                       image: inputImage,
                                                 arguments: arguments)
        }
        return nil
    }
}



