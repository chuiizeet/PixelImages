//
//  MaskImageView.swift
//  PixelImage
//
//  Created by imac on 9/11/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

class MaskImageView: UIImageView {

    var maskImageView = UIImageView()
    
    var maskImage: UIImage? {
        didSet {
            maskImageView.image = maskImage
            maskImageView.frame = frame
            mask = maskImageView
        }
    }
    
}
