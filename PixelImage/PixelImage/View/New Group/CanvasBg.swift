//
//  CanvasBg.swift
//  PixelImage
//
//  Created by imac on 9/10/19.
//  Copyright © 2019 JeguLabs. All rights reserved.
//

import UIKit

class CanvasBg: UIView {
    
    // MARK: - Properties
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewComponents()
    }
    
    // MARK: - Helper Functions
    
    func setupViewComponents() {
        backgroundColor = .green
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
