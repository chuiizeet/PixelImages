//
//  Filter.swift
//  PixelImage
//
//  Created by imac on 9/7/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

protocol Filter {
    func apply(input: Image) -> Image
}
