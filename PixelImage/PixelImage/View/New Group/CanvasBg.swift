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
    
    var placheHolderPositions: [CGRect]? {
        didSet {
            
            for view in subviews {
                view.removeFromSuperview()
            }
            
            if self.placheHolderPositions != nil {
                
                for pos in self.placheHolderPositions! {
                    let placeH = PlaceHolderCollage()
                    addSubview(placeH)
                    placeH.frame = pos
                }
                
            } else {
                print("Empty")
            }
        }
    }
    
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
