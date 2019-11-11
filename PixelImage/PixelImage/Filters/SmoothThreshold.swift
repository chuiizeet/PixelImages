//
//  SmoothThreshold.swift
//  PixelImage
//
//  Created by imac on 11/11/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import CoreImage


class SmoothThreshold: CIFilter
{
    @objc var inputImage : CIImage?
    @objc var inputEdgeO: CGFloat = 0.25
    @objc var inputEdge1: CGFloat = 0.75
    
    override var attributes: [String : Any]
    {
        return [
            kCIAttributeFilterDisplayName: "Smooth Threshold Filter" as AnyObject,
            "inputImage": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "CIImage",
                           kCIAttributeDisplayName: "Image",
                           kCIAttributeType: kCIAttributeTypeImage],
            "inputEdgeO": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "NSNumber",
                           kCIAttributeDefault: 0.25,
                           kCIAttributeDisplayName: "Edge 0",
                           kCIAttributeMin: 0,
                           kCIAttributeSliderMin: 0,
                           kCIAttributeSliderMax: 1,
                           kCIAttributeType: kCIAttributeTypeScalar],
            "inputEdge1": [kCIAttributeIdentity: 0,
                           kCIAttributeClass: "NSNumber",
                           kCIAttributeDefault: 0.75,
                           kCIAttributeDisplayName: "Edge 1",
                           kCIAttributeMin: 0,
                           kCIAttributeSliderMin: 0,
                           kCIAttributeSliderMax: 1,
                           kCIAttributeType: kCIAttributeTypeScalar]
        ]
    }
    
    let colorKernel = CIColorKernel(source:
        "kernel vec4 color(__sample pixel, float inputEdgeO, float inputEdge1)" +
            "{" +
            "    float luma = dot(pixel.rgb, vec3(0.2126, 0.7152, 0.0722));" +
            "    float threshold = smoothstep(inputEdgeO, inputEdge1, luma);" +
            "    return vec4(threshold, threshold, threshold, 1.0);" +
        "}"
    )
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage,
            let colorKernel = colorKernel else
        {
            return nil
        }
        
        let extent = inputImage.extent
        let arguments = [inputImage,
                         min(inputEdgeO, inputEdge1),
                         max(inputEdgeO, inputEdge1),] as [Any]
        
        return colorKernel.apply(extent: extent, arguments: arguments)
    }
}

