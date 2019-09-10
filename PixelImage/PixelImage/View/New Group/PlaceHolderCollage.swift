//
//  PlaceHolderCollage.swift
//  PixelImage
//
//  Created by imac on 9/10/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

class PlaceHolderCollage: UIView {

    // MARK: - Properties
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewComponents()
    }
    
    // MARK: - Helper Functions
    
    func setupViewComponents() {
        backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
