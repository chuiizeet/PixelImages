
//  File.swift
//  PixelImage
//
//  Created by imac on 9/18/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import CoreImage

class BleachBypassFilter: CIFilter
{
    var inputImage : CIImage?
    var inputAmount = CGFloat(1)
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Bleach Bypass Filter",
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            
            "inputAmount": [kCIAttributeIdentity: 0,
                            kCIAttributeClass: "NSNumber",
                            kCIAttributeDefault: 1,
                            kCIAttributeDisplayName: "Amount",
                            kCIAttributeMin: 0,
                            kCIAttributeSliderMin: 0,
                            kCIAttributeSliderMax: 1,
                            kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    override func setDefaults()
    {
        inputAmount = 1
    }
    
    let bleachBypassKernel = CIColorKernel(source:
        "kernel vec4 bleachBypassFilter(__sample image, float amount) \n" +
            "{ \n" +
            "   float luma = dot(image.rgb, vec3(0.2126, 0.7152, 0.0722));" +
            
            "   float l = min(1.0, max (0.0, 10.0 * (luma - 0.45))); \n" +
            "   vec3 result1 = vec3(2.0) * image.rgb * vec3(luma); \n" +
            "   vec3 result2 = 1.0 - 2.0 * (1.0 - luma) * (1.0 - image.rgb); \n" +
            "   vec3 newColor = mix(result1,result2,l); \n" +
            
            "   return mix(image, vec4(newColor.r, newColor.g, newColor.b, image.a), amount); \n" +
        "}"
    )
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage,
            let bleachBypassKernel = bleachBypassKernel else
        {
            return nil
        }
        
        let extent = inputImage.extent
        let arguments = [inputImage, inputAmount] as [Any]
        
        return bleachBypassKernel.apply(extent: extent, arguments: arguments)
    }
}

// MARK: 3 Strip TechnicolorFilter
class TechnicolorFilter: CIFilter
{
    var inputImage : CIImage?
    var inputAmount = CGFloat(1)
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Technicolor Filter",
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            
            "inputAmount": [kCIAttributeIdentity: 0,
                            kCIAttributeClass: "NSNumber",
                            kCIAttributeDefault: 1,
                            kCIAttributeDisplayName: "Amount",
                            kCIAttributeMin: 0,
                            kCIAttributeSliderMin: 0,
                            kCIAttributeSliderMax: 1,
                            kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    override func setDefaults()
    {
        inputAmount = 1
    }
    
    let technicolorKernel = CIColorKernel(source:
        "kernel vec4 technicolorFilter(__sample image, float amount)" +
            "{" +
            "   vec3 redmatte = 1.0 - vec3(image.r - ((image.g + image.b)/2.0));" +
            "   vec3 greenmatte = 1.0 - vec3(image.g - ((image.r + image.b)/2.0));" +
            "   vec3 bluematte = 1.0 - vec3(image.b - ((image.r + image.g)/2.0)); " +
            
            "   vec3 red =  greenmatte * bluematte * image.r; " +
            "   vec3 green = redmatte * bluematte * image.g; " +
            "   vec3 blue = redmatte * greenmatte * image.b; " +
            
            "   return mix(image, vec4(red.r, green.g, blue.b, image.a), amount);" +
        "}"
    )
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage,
            let technicolorKernel = technicolorKernel else
        {
            return nil
        }
        
        let extent = inputImage.extent
        let arguments = [inputImage, inputAmount] as [Any]
        
        return technicolorKernel.apply(extent: extent, arguments: arguments)
    }
}


class ScatterWarp: CIFilter
{
    var inputImage: CIImage?
    var inputScatterRadius: CGFloat = 25
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Scatter (Warp Kernel)",
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            
            "inputScatterRadius": [kCIAttributeIdentity: 0,
                                   kCIAttributeClass: "NSNumber",
                                   kCIAttributeDefault: 25,
                                   kCIAttributeDisplayName: "Scatter Radius",
                                   kCIAttributeMin: 1,
                                   kCIAttributeSliderMin: 1,
                                   kCIAttributeSliderMax: 150,
                                   kCIAttributeType: kCIAttributeTypeScalar],
        ]
    }
    
    let kernel = CIWarpKernel(source:
        // based on https://www.shadertoy.com/view/ltB3zD - the additional seed
        // calculation prevents repetition when using destCoord() as the seed.
        "float noise(vec2 co)" +
            "{ " +
            "    vec2 seed = vec2(sin(co.x), cos(co.y)); " +
            "    return fract(sin(dot(seed ,vec2(12.9898,78.233))) * 43758.5453); " +
            "} " +
            
            "kernel vec2 scatter(float radius)" +
            "{" +
            "   float offsetX = radius * (-1.0 + noise(destCoord()) * 2.0); " +
            "   float offsetY = radius * (-1.0 + noise(destCoord().yx) * 2.0); " +
            "   return vec2(destCoord().x + offsetX, destCoord().y + offsetY); " +
        "}"
    )
    
    override var outputImage: CIImage?
    {
        guard let kernel = kernel, let inputImage = inputImage else
        {
            return nil
        }
        
        return  kernel.apply(
            extent: inputImage.extent,
            roiCallback:
            {
                (index, rect) in
                return rect
        },
            image: inputImage,
            arguments: [inputScatterRadius])
    }
}

// Pixel scattering filter using CIRandomGenerator as its source. The output of the
// random generator can be blurred allowing for a smoothness attribute.
class Scatter: CIFilter
{
    var inputImage: CIImage?
    var inputScatterRadius: CGFloat = 25
    var inputScatterSmoothness: CGFloat = 1.0
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Scatter",
            
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            
            "inputScatterRadius": [kCIAttributeIdentity: 0,
                                   kCIAttributeClass: "NSNumber",
                                   kCIAttributeDefault: 25,
                                   kCIAttributeDisplayName: "Scatter Radius",
                                   kCIAttributeMin: 1,
                                   kCIAttributeSliderMin: 1,
                                   kCIAttributeSliderMax: 150,
                                   kCIAttributeType: kCIAttributeTypeScalar],
            
            "inputScatterSmoothness": [kCIAttributeIdentity: 0,
                                       kCIAttributeClass: "NSNumber",
                                       kCIAttributeDefault: 1,
                                       kCIAttributeDisplayName: "Scatter Smoothness",
                                       kCIAttributeMin: 0,
                                       kCIAttributeSliderMin: 0,
                                       kCIAttributeSliderMax: 4,
                                       kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    let kernel = CIKernel(source:
        "kernel vec4 scatter(sampler image, sampler noise, float radius)" +
            "{" +
            "   vec2 workingSpaceCoord = destCoord() + -radius + sample(noise, samplerCoord(noise)).xy * radius * 2.0; " +
            "   vec2 imageSpaceCoord = samplerTransform(image, workingSpaceCoord); " +
            "   return sample(image, imageSpaceCoord);" +
        "}")
    
    override var outputImage: CIImage?
    {
        guard let kernel = kernel, let inputImage = inputImage else
        {
            return nil
        }
        
        let noise = CIFilter(name: "CIRandomGenerator")!.outputImage!
            .applyingFilter("CIGaussianBlur", parameters: [kCIInputRadiusKey: inputScatterSmoothness])
            .cropped(to: inputImage.extent)
        
        let arguments = [inputImage, noise, inputScatterRadius] as [Any]
        
        return kernel.apply(
            extent: inputImage.extent,
            roiCallback:
            {
                (index, rect) in
                return rect
        },
            arguments: arguments)
        
    }
}

class HomogeneousColorBlur: CIFilter
{
    var inputImage: CIImage?
    var inputColorThreshold: CGFloat = 0.2
    var inputRadius: CGFloat = 10
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Homogeneous Color Blur",
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            "inputColorThreshold": [kCIAttributeIdentity: 0,
                                    kCIAttributeClass: "NSNumber",
                                    kCIAttributeDefault: 0.2,
                                    kCIAttributeDisplayName: "Color Threshold",
                                    kCIAttributeMin: 0,
                                    kCIAttributeSliderMin: 0,
                                    kCIAttributeSliderMax: 1,
                                    kCIAttributeType: kCIAttributeTypeScalar],
            "inputRadius": [kCIAttributeIdentity: 0,
                            kCIAttributeClass: "NSNumber",
                            kCIAttributeDefault: 10,
                            kCIAttributeDisplayName: "Radius",
                            kCIAttributeMin: 1,
                            kCIAttributeSliderMin: 1,
                            kCIAttributeSliderMax: 40,
                            kCIAttributeType: kCIAttributeTypeScalar],
        ]
    }
    
    let kernel = CIKernel(source:
        "kernel vec4 colorDirectedBlurKernel(sampler image, float radius, float threshold)" +
            "{" +
            "   int r = int(radius);" +
            "   float n = 0.0;" +
            "   vec2 d = destCoord();" +
            "   vec3 thisPixel = sample(image, samplerCoord(image)).rgb;" +
            "   vec3 accumulator = vec3(0.0, 0.0, 0.0);" +
            "   for (int x = -r; x <= r; x++) " +
            "   { " +
            "       for (int y = -r; y <= r; y++) " +
            "       { " +
            "           vec3 offsetPixel = sample(image, samplerTransform(image, d + vec2(x ,y))).rgb; \n" +
            
            "           float distanceMultiplier = step(length(vec2(x,y)), radius); \n" +
            "           float colorMultiplier = step(distance(offsetPixel, thisPixel), threshold); \n" +
            
            "           accumulator += offsetPixel * distanceMultiplier * colorMultiplier; \n" +
            "           n += distanceMultiplier * colorMultiplier; \n" +
            "       }" +
            "   }" +
            "   return vec4(accumulator / n, 1.0); " +
        "}")
    
    override var outputImage: CIImage?
    {
        guard let inputImage = inputImage, let kernel = kernel else
        {
            return nil
        }
        
        let arguments = [inputImage, inputRadius, inputColorThreshold * sqrt(3.0)] as [Any]
        
        return kernel.apply(
            extent: inputImage.extent,
            roiCallback:
            {
                (index, rect) in
                return rect
        },
            arguments: arguments)
    }
}
